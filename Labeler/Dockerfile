FROM python:3.9-slim
RUN pip install --no-cache-dir boto3 librosa numpy scipy botocore
WORKDIR /app
COPY labeler.py /app/labeler.py
CMD ["python", "/app/labeler.py"]
