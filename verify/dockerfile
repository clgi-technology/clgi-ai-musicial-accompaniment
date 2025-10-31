# Dockerfile — v8: Lambda + SageMaker SDK
FROM public.ecr.aws/lambda/python:3.11

LABEL maintainer="aiops@clgihq.com"

# Install PyTorch + ONNX
RUN pip install \
    torch==2.6.0+cpu \
    torchvision==0.21.0+cpu \
    --index-url https://download.pytorch.org/whl/cpu \
    --no-cache-dir

# Install deps + SageMaker
RUN pip install onnxruntime==1.16.3 numpy boto3 sagemaker --no-cache-dir

COPY --chown=sbx_user1051:sbx_grp1051 lambda_function.py ${LAMBDA_TASK_ROOT}

RUN python -c "import torch; print('PyTorch preloaded')"

RUN rm -rf /root/.cache

CMD ["lambda_function.handler"]
