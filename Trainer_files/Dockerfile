# Dockerfile — v29: FAST BUILD (<15 min), GPU TRAIN, GZIP, ONNX EXPORT
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04 AS builder

LABEL maintainer="CLGI AI Musician <technology@clgi.org>" \
      build="v29" \
      purpose="Wav2Vec2 fine-tuning + ONNX export" \
      version="29.0" \
      date="2025-10-30"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    CUDA_VISIBLE_DEVICES=0

# === 1. APT MIRRORS + RETRY ===
RUN rm -rf /etc/apt/sources.list.d/cuda.list && \
    echo "deb [trusted=yes] http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb [trusted=yes] http://archive.ubuntu.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list

RUN for i in 1 2 3; do \
        apt-get update && \
        apt-get install -y --no-install-recommends \
            python3.10 python3-pip python3.10-distutils libsndfile1 ffmpeg git && \
        break || sleep 15; \
    done && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# === 2. UPGRADE PIP + INSTALL TORCH (CACHED) ===
RUN pip install --upgrade pip
RUN pip install --no-cache-dir \
    torch==2.4.0+cu124 torchvision==0.19.0+cu124 torchaudio==2.4.0+cu124 \
    --index-url https://download.pytorch.org/whl/cu124

# === 3. INSTALL PYPI (CACHED) ===
RUN pip install --no-cache-dir \
    boto3==1.35.0 \
    transformers==4.44.2 \
    onnx==1.16.0 \
    onnxruntime-gpu==1.19.2 \
    numpy==1.26.4 \
    huggingface-hub==0.24.6 \
    tokenizers==0.19.1 \
    safetensors==0.5.3 \
    accelerate==0.34.2 \
    librosa==0.10.2

# === 4. COPY TRAINER ===
COPY trainer.py /app/trainer.py

# === 5. RUNTIME IMAGE (SLIM) ===
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

COPY --from=builder /usr/local/lib/python3.10/dist-packages /usr/local/lib/python3.10/dist-packages
COPY --from=builder /app/trainer.py /app/trainer.py

WORKDIR /app
CMD ["python", "trainer.py"]

HEALTHCHECK --interval=30s --timeout=10s CMD nvidia-smi || exit 1
