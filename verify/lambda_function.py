# lambda_function.py — v4: BULLETPROOF S3 EVENT HANDLING
import json
import boto3
import os
import urllib.parse
from datetime import datetime

s3 = boto3.client('s3')
sm = boto3.client('sagemaker')
slack_webhook = os.environ.get('SLACK_WEBHOOK')

BUCKET = 'clgihq-audio'
MODEL_KEY = None
MODEL_NAME = None
ENDPOINT_CONFIG_NAME = None
ENDPOINT_NAME = "verify-model-endpoint"

def handler(event, context):
    global MODEL_KEY, MODEL_NAME, ENDPOINT_CONFIG_NAME

    print(f"Received event: {json.dumps(event)}")  # DEBUG

    # === 1. ROBUST S3 EVENT PARSING ===
    MODEL_KEY = None
    for record in event.get('Records', []):
        # Handle real S3 events
        if 's3' in record:
            s3_info = record['s3']
            bucket = s3_info['bucket']['name']
            key = urllib.parse.unquote_plus(s3_info['object']['key'])
        # Handle Lambda test events (console)
        elif 'body' in record:
            body = json.loads(record['body'])
            bucket = body['Records'][0]['s3']['bucket']['name']
            key = urllib.parse.unquote_plus(body['Records'][0]['s3']['object']['key'])
        else:
            continue

        if not key.endswith('.onnx') or 'validation-results' in key:
            continue

        if bucket != BUCKET:
            continue

        MODEL_KEY = key
        break

    if not MODEL_KEY:
        print("No valid .onnx model found in event.")
        return {"statusCode": 200, "body": "Ignored"}

    print(f"Processing model: {MODEL_KEY}")

    # === 2. Download & Verify ===
    local_path = f"/tmp/{os.path.basename(MODEL_KEY)}"
    try:
        s3.download_file(BUCKET, MODEL_KEY, local_path)
    except Exception as e:
        send_slack(f"S3 download failed: {e}")
        return {"statusCode": 500, "body": str(e)}

    try:
        import onnxruntime as ort
        session = ort.InferenceSession(local_path)
        inputs = session.get_inputs()
        if not inputs or inputs[0].name != 'input_values':
            raise ValueError(f"Expected input 'input_values', got {[i.name for i in inputs]}")

        import torch
        dummy = torch.randn(1, 16000)
        output = session.run(None, {'input_values': dummy.numpy()})[0]
        if output.shape[1] < 100:
            raise ValueError("Logits too small")
    except Exception as e:
        send_slack(f"Verification FAILED: {e}")
        return {"statusCode": 400, "body": str(e)}

    # === 3. Upload Report ===
    report = {
        "model_key": MODEL_KEY,
        "verified": True,
        "timestamp": datetime.utcnow().isoformat(),
        "input_shape": [1, 16000],
        "output_shape": list(output.shape)
    }
    report_key = MODEL_KEY.replace('.onnx', '.json').replace('models/', 'models/validation-results/')
    s3.put_object(
        Bucket=BUCKET,
        Key=report_key,
        Body=json.dumps(report, indent=2),
        ContentType='application/json'
    )

    # === 4. Deploy to SageMaker ===
    MODEL_NAME = f"verify-model-{int(datetime.utcnow().timestamp())}"
    ENDPOINT_CONFIG_NAME = f"{MODEL_NAME}-config"

    try:
        sm.create_model(
            ModelName=MODEL_NAME,
            PrimaryContainer={
                'Image': '763104351884.dkr.ecr.us-east-1.amazonaws.com/pytorch-inference:2.3.0-gpu-py310',
                'ModelDataUrl': f"s3://{BUCKET}/{MODEL_KEY}",
                'Environment': {
                    'SAGEMAKER_MODEL_SERVER_TIMEOUT': '3600',
                    'SAGEMAKER_MODEL_SERVER_WORKERS': '1'
                }
            },
            ExecutionRoleArn='arn:aws:iam::224553687012:role/SageMakerExecutionRole'
        )

        sm.create_endpoint_config(
            EndpointConfigName=ENDPOINT_CONFIG_NAME,
            ProductionVariants=[{
                'VariantName': 'AllTraffic',
                'ModelName': MODEL_NAME,
                'InitialInstanceCount': 1,
                'InstanceType': 'ml.g5.xlarge',
                'InitialVariantWeight': 1.0
            }]
        )

        try:
            sm.create_endpoint(EndpointName=ENDPOINT_NAME, EndpointConfigName=ENDPOINT_CONFIG_NAME)
            status = "created"
        except sm.exceptions.ClientError:
            sm.update_endpoint(EndpointName=ENDPOINT_NAME, EndpointConfigName=ENDPOINT_CONFIG_NAME)
            status = "updated"

        send_slack(f"Model DEPLOYED to SageMaker!\nEndpoint: `{ENDPOINT_NAME}`\nStatus: `{status}`\nModel: `{MODEL_KEY}`")

    except Exception as e:
        send_slack(f"SageMaker deploy FAILED: {e}")
        raise

    return {
        "statusCode": 200,
        "body": json.dumps({
            "report_key": report_key,
            "sagemaker_endpoint": ENDPOINT_NAME,
            "model_name": MODEL_NAME
        })
    }

def send_slack(message):
    if not slack_webhook:
        return
    import urllib.request
    payload = {"text": message}
    data = json.dumps(payload).encode()
    req = urllib.request.Request(
        slack_webhook,
        data=data,
        headers={'Content-Type': 'application/json'}
    )
    try:
        urllib.request.urlopen(req)
    except:
        pass
