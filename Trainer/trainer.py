# trainer.py — v29: GZIP, FAST TRAIN, ONNX, MEMORY CLEAN
import os
import json
import boto3
import torch
import numpy as np
import logging
import gzip
from datetime import datetime
from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC, TrainingArguments, Trainer
from dataclasses import dataclass
from typing import Dict, List

# === 1. LOGGING ===
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# === 2. ENV VALIDATION ===
required = ["S3_BUCKET", "MODEL_OUTPUT"]
for var in required:
    if not os.environ.get(var):
        raise EnvironmentError(f"Missing {var}")

s3 = boto3.client('s3')
BUCKET = os.environ['S3_BUCKET']
MODEL_OUTPUT = os.environ['MODEL_OUTPUT']
MODEL_ONNX = MODEL_OUTPUT.rsplit('.', 1)[0] + '.onnx'
ANNOTATION_KEY = os.environ.get('ANNOTATION_KEY')

# === 3. VERSIONED OUTPUTS ===
timestamp = datetime.utcnow().strftime("%Y%m%d-%H%M%S")
MODEL_OUT_V = MODEL_OUTPUT.replace(".pt", f"-{timestamp}.pt")
ONNX_OUT_V = MODEL_ONNX.replace(".onnx", f"-{timestamp}.onnx")

# === 4. GPU ===
device = "cuda" if torch.cuda.is_available() else "cpu"
logger.info(f"Using device: {device}")

# === 5. PROCESSOR ===
processor = Wav2Vec2Processor.from_pretrained("facebook/wav2vec2-base-960h")

# === 6. DATASET ===
class AudioDataset(torch.utils.data.Dataset):
    def __init__(self, annotations):
        self.annotations = annotations
    def __len__(self): return len(self.annotations)
    def __getitem__(self, idx):
        ann = self.annotations[idx]
        audio_path = f"/tmp/{os.path.basename(ann['audio_s3_key'])}"
        audio = np.load(audio_path)['arr_0']
        input_values = processor(audio, sampling_rate=16000, return_tensors="pt").input_values[0]
        labels = processor.text2ids(ann.get('transcript', ''))
        return {"input_values": input_values, "labels": torch.tensor(labels)}

# === 7. COLLATOR ===
@dataclass
class CTCCollator:
    processor: Wav2Vec2Processor
    def __call__(self, features):
        input_features = [{"input_values": f["input_values"]} for f in features]
        label_features = [{"input_ids": f["labels"]} for f in features]
        batch = self.processor.pad(input_features, return_tensors="pt")
        labels_batch = self.processor.pad(label_features, return_tensors="pt")
        labels = labels_batch["input_ids"].masked_fill(labels_batch.attention_mask.ne(1), -100)
        batch["labels"] = labels
        return batch

collator = CTCCollator(processor)

# === 8. LOAD MODEL SAFELY ===
def load_model():
    model_path = "/tmp/prev.pt"
    try:
        if not MODEL_OUTPUT.endswith('.pt'):
            raise ValueError("MODEL_OUTPUT must end in .pt")
        s3.head_object(Bucket=BUCKET, Key=MODEL_OUTPUT)
        s3.download_file(BUCKET, MODEL_OUTPUT, model_path)
        state = torch.load(model_path, map_location=device, weights_only=True)
        model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
        model.load_state_dict(state, strict=False)
        logger.info("Loaded previous .pt")
    except Exception as e:
        logger.warning(f"No .pt: {e}. Starting fresh.")
        model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
    return model.to(device)

# === 9. DOWNLOAD + DECOMPRESS GZIP ===
def download_gzip(key, dest):
    gz_path = dest + '.gz'
    logger.info(f"Downloading {key} → {gz_path}")
    s3.download_file(BUCKET, key, gz_path)
    logger.info(f"Decompressing → {dest}")
    with gzip.open(gz_path, 'rb') as f_in, open(dest, 'wb') as f_out:
        f_out.write(f_in.read())
    os.remove(gz_path)

# === 10. GET DATA ===
def get_data():
    annotations = []
    if ANNOTATION_KEY:
        logger.info(f"Using: {ANNOTATION_KEY}")
        local_ann = f"/tmp/ann.json"
        download_gzip(ANNOTATION_KEY, local_ann)
        with open(local_ann) as f:
            data = json.load(f)
        if data.get('global_voiced_ratio', 0) >= 0.01:
            audio_key = data['audio_s3_key']
            local_audio = f"/tmp/{os.path.basename(audio_key)}"
            s3.download_file(BUCKET, audio_key, local_audio)
            annotations.append(data)
    if not annotations:
        logger.error("NO VALID DATA")
        return []
    logger.info(f"Loaded {len(annotations)} annotations")
    return annotations

# === 11. MAIN ===
def main():
    logger.info("START TRAINING")
    model = load_model()
    annotations = get_data()
    if not annotations: return

    dataset = AudioDataset(annotations)
    args = TrainingArguments(
        output_dir="/tmp",
        per_device_train_batch_size=2,
        gradient_accumulation_steps=4,
        learning_rate=3e-5,
        num_train_epochs=1,
        logging_steps=5,
        save_steps=50,
        fp16=(device == "cuda"),
        report_to=[],
        disable_tqdm=False,
    )
    trainer = Trainer(model=model, args=args, train_dataset=dataset, data_collator=collator)
    trainer.train()

    # === SAVE .pt ===
    pt_path = "/tmp/model.pt"
    torch.save(trainer.model.state_dict(), pt_path)
    s3.upload_file(pt_path, BUCKET, MODEL_OUT_V)
    s3.upload_file(pt_path, BUCKET, MODEL_OUTPUT)
    logger.info(f"Saved .pt → {MODEL_OUT_V}")

    # === EXPORT ONNX ===
    onnx_path = "/tmp/model.onnx"
    dummy = torch.randn(1, 16000).to(device)
    torch.onnx.export(
        trainer.model, dummy, onnx_path,
        opset_version=17,
        input_names=["input_values"],
        output_names=["logits"],
        dynamic_axes={"input_values": {0: "batch", 1: "time"}, "logits": {0: "batch", 1: "time"}}
    )
    s3.upload_file(onnx_path, BUCKET, ONNX_OUT_V)
    s3.upload_file(onnx_path, BUCKET, MODEL_ONNX)
    logger.info(f"ONNX → {ONNX_OUT_V}")

    # === CLEANUP ===
    del trainer, model
    if device == "cuda":
        torch.cuda.empty_cache()
    logger.info("TRAINING DONE — CLEANED")

if __name__ == "__main__":
    main()
