# labeler.py — FINAL v9 (PITCHES PER SEGMENT + SILENT HANDLING)
import boto3
import librosa
import numpy as np
import os
import json
import sys
import re
import gzip
from botocore.exceptions import ClientError
from scipy.stats import entropy

s3 = boto3.client('s3')
bucket = os.getenv('S3_BUCKET')
input_uri = os.getenv('INPUT_S3_URI')
output_uri = os.getenv('OUTPUT_S3_URI')

if not all([bucket, input_uri, output_uri]):
    print("Error: Missing env vars", file=sys.stderr)
    sys.exit(1)

# === 1. Extract key & video_id (ROBUST) ===
key = input_uri.replace(f"s3://{bucket}/", "")
basename = os.path.splitext(os.path.basename(key))[0]
parts = basename.split('_')
video_id = parts[-2] if len(parts) >= 2 else parts[-1]
print(f"Extracted video_id: {video_id} from {key}")

metadata_key = f"data/raw_audio/{video_id}_metadata.json"
local_audio_path = '/tmp/audio.wav'
local_metadata_path = '/tmp/metadata.json'
output_json_path = '/tmp/annotations.json'
output_gz_path = '/tmp/annotations.json.gz'

# === 2. Download audio (404 → exit 0) ===
try:
    s3.download_file(bucket, key, local_audio_path)
except ClientError as e:
    code = e.response["Error"].get("Code", "")
    if code in ("NoSuchKey", "404"):
        print(f"Audio not found: {key}", file=sys.stderr)
        sys.exit(0)
    else:
        raise

y, sr = librosa.load(local_audio_path, sr=16000)
duration = len(y) / 16000
print(f"Loaded: {duration:.1f}s")

# === 3. Pitch & Features (FRAME-LEVEL) ===
hop_length = 512
f0, voiced_flag, voiced_probs = librosa.pyin(
    y, fmin=librosa.note_to_hz('C2'), fmax=librosa.note_to_hz('C7'),
    sr=sr, hop_length=hop_length
)
pitches_per_frame = [0 if np.isnan(f) else round(librosa.hz_to_midi(f)) for f in f0]

# Safe voiced_ratio
voiced_ratio = float(np.nanmean(voiced_flag)) if np.any(~np.isnan(voiced_flag)) else 0.0

S = np.abs(librosa.stft(y, hop_length=hop_length))
centroid = librosa.feature.spectral_centroid(S=S)[0]
rms = librosa.feature.rms(y=y, hop_length=hop_length)[0]

chroma = librosa.feature.chroma_stft(y=y, sr=sr, hop_length=hop_length * 4)
chroma_sum = chroma.sum(axis=0, keepdims=True)
chroma_norm = chroma / np.maximum(chroma_sum, 1e-6)
chroma_entropy = entropy(chroma_norm, base=2, axis=0)
chroma_entropy_resampled = np.interp(
    np.arange(len(pitches_per_frame)),
    np.linspace(0, len(pitches_per_frame), len(chroma_entropy)),
    chroma_entropy
)

onset_env = librosa.onset.onset_strength(y=y, sr=sr)
tempo, _ = librosa.beat.beat_track(onset_envelope=onset_env, sr=sr)

# === 4. Segment classification ===
def classify(p, v, c, r, e):
    p = np.array(p)
    v = np.array(v)
    c = np.array(c)
    r = np.array(r)
    e = np.array(e)

    voiced = np.nanmean(v)
    pitch_std = np.std(p[p > 0]) if np.any(p > 0) else 0
    cent_mean = np.mean(c)
    rms_mean = np.mean(r)
    chroma_ent = np.mean(e)
    conf = min(voiced, 0.9) + min(1.0 - (chroma_ent / 3.5), 0.5)

    if voiced < 0.3 and rms_mean > 0.01:
        return ("prayer" if pitch_std < 3 else "testimony"), conf
    if voiced < 0.2 and rms_mean > 0.005:
        return "sermon", conf
    if voiced > 0.7 and tempo > 120:
        return "praise_medley", conf
    if voiced > 0.6 and chroma_ent > 2.5:
        return "choir_song", conf
    if 0.4 < voiced < 0.7 and pitch_std < 4:
        return "solo", conf
    if voiced > 0.5 and tempo < 80:
        return "prayer_song", conf
    if voiced < 0.3 and rms_mean > 0.02:
        return "drummer_only", conf
    if voiced > 0.4 and pitch_std < 2 and rms_mean < 0.03:
        return "preacher_chords", conf
    if voiced > 0.6 and chroma_ent < 1.5:
        return "choir_vamp", conf
    return "worship_song", conf

window_frames = int(10 * sr / hop_length)
segments = []

# === 5. Build segments with PITCHES ===
if voiced_ratio < 0.05:
    print(f"Silent chunk: voiced_ratio={voiced_ratio:.3f}")
    segments.append({
        "start": 0.0,
        "end": round(duration, 2),
        "label": "silence",
        "voiced_ratio": round(voiced_ratio, 3),
        "confidence": 0.95,
        "pitches": [0] * int(duration * sr / hop_length)
    })
else:
    for start in range(0, len(pitches_per_frame) - window_frames, window_frames // 2):
        end = start + window_frames
        label, conf = classify(
            pitches_per_frame[start:end],
            voiced_flag[start:end],
            centroid[start:end],
            rms[start:end],
            chroma_entropy_resampled[start:end]
        )
        start_sec = start * hop_length / sr
        end_sec = end * hop_length / sr

        # Extract pitch sequence for this segment
        seg_pitches = pitches_per_frame[start:end]
        # Pad if needed
        if len(seg_pitches) < (end - start):
            seg_pitches = seg_pitches + [seg_pitches[-1]] * ((end - start) - len(seg_pitches))

        segments.append({
            "start": round(start_sec, 2),
            "end": round(end_sec, 2),
            "label": label,
            "voiced_ratio": round(float(np.nanmean(voiced_flag[start:end])), 3),
            "confidence": round(float(conf), 2),
            "pitches": seg_pitches  # ← PITCHES PER FRAME
        })

# Merge consecutive same-label segments
merged = []
for seg in segments:
    if not merged or merged[-1]["label"] != seg["label"]:
        merged.append(seg.copy())
    else:
        merged[-1]["end"] = seg["end"]
        merged[-1]["confidence"] = max(merged[-1]["confidence"], seg["confidence"])
        # Merge pitches
        merged[-1]["pitches"].extend(seg["pitches"])

# === 6. METADATA (404 → skip) ===
video_title = ''
instruments = [i.strip() for i in os.getenv('INSTRUMENTS', 'piano,organ,guitar,drums').split(',')]
try:
    s3.download_file(bucket, metadata_key, local_metadata_path)
    with open(local_metadata_path, 'r') as f:
        metadata = json.load(f)
    video_title = metadata.get('title', '')
    print(f"Title: {video_title}")
except ClientError as e:
    code = e.response["Error"].get("Code", "")
    if code in ("NoSuchKey", "404"):
        print(f"Metadata not found: {metadata_key} — using defaults")
    else:
        raise

title_lower = video_title.lower()
detected_instruments = [
    i for i in instruments if re.search(rf'\b{re.escape(i)}\b', title_lower)
] or ['piano']

# === 7. Save & upload ===
annotations = {
    'video_id': video_id,
    'title': video_title,
    'duration_seconds': round(duration, 2),
    'segments': merged,
    'global_tempo': round(float(tempo), 1),
    'global_voiced_ratio': round(float(voiced_ratio), 3),
    'instruments': detected_instruments,
    'sample_rate': sr,
    'hop_length': hop_length
}

with open(output_json_path, 'w') as f:
    json.dump(annotations, f, separators=(',', ':'))
with open(output_json_path, 'rb') as f_in, gzip.open(output_gz_path, 'wb') as f_out:
    f_out.writelines(f_in)

output_key = output_uri.replace(f"s3://{bucket}/", "")
s3.upload_file(output_gz_path, bucket, output_key)
print(f"Uploaded {len(merged)} segments → {output_uri}")
