# 🎶 Church AI Accompaniment

Fully automated, GitHub-native, iPhone-controlled pipeline that sources, labels, trains, and deploys Pentecostal Gospel audio into an AI model that provides real-time musical accompaniment for live singers.

Singer uses a microphone → AI understands pitch, tempo, and chords → AI plays advanced accompaniment in real time.
CLGI and other Pentecostal Gospel Audio → AI Model → Cantabile Accompaniment

⸻

📜 Purpose

To empower Pentecostal and Gospel musicians with an AI-driven accompanist that listens, learns, and plays along in real time — enabling worship anywhere, by anyone.

⸻

⚙️ System Overview

Layer	Environment	Purpose
GitHub Actions + OIDC	Cloud	Secure automation using GitHub → AWS trust (no keys)
AWS Cloud	Cloud	Stores, labels, trains, and deploys the AI model
Gaming PC (C++/Python)	On-Prem	Runs the real-time AI inference system
iPhone	Controller	Triggers workflows and monitors status remotely


⸻

🧩 Requirements

Name	Purpose	Approx. Cost
AWS Account	Required for S3, SQS, Lambda, Batch, CodeBuild, SageMaker	~$200/mo
Gaming PC (NVIDIA/Radeon 5090 GPU)	Real-time inference <15 ms latency	~$6000
RME Babyface Pro FS	Audio interface for mic/PA input	~$1000 (rme-usa.com￼)
Cantabile Performer	Hosts AI-driven accompaniment VST	$60–$500
C++ Real-Time Engine	Low-latency inference layer connecting ONNX model to MIDI/VST	Included
PC Optimization Scripts	Adjust CPU/RAM/ASIO/BIOS settings for minimal jitter	Free–$100
GitHub Mobile + AWS Console App	iPhone-based monitoring and control	Free


⸻

🏗️ Infrastructure Setup (Before Running the Pipeline)

⚠️ The AI pipeline requires core AWS resources (S3, SQS, Lambda, Batch, CodeBuild, SageMaker).
These can be created manually or automatically using the provided CloudFormation stack or PowerShell setup script.

Option 1 – One-Time Setup Script (Recommended)

Use a PowerShell or Bash helper script (example):

# setup_infra.sh
aws cloudformation deploy \
  --template-file infrastructure.yml \
  --stack-name church-ai-infra \
  --capabilities CAPABILITY_IAM

# Creates:
# - S3 bucket (audio + models)
# - SQS queue for job triggers
# - Lambda (verify ONNX)
# - AWS Batch compute environment + job queues
# - CodeBuild project for container builds

Option 2 – High-Level Manual Steps
	1.	Create an S3 bucket for storing audio and model files
	2.	Create an AWS Batch compute environment (Fargate or GPU EC2)
	3.	Create ECR repositories for the labeler, trainer, and verifier containers
	4.	Create a Lambda function for ONNX verification
	5.	Create a SageMaker endpoint for model deployment
	6.	Connect your GitHub repository → AWS via OIDC (IAM role trust relationship)

⸻

🔐 Authentication (OIDC)

GitHub OIDC is used instead of static AWS credentials.
This means no AWS_ACCESS_KEY_ID or SECRET_ACCESS_KEY are required.

Steps:
	1.	Create an IAM role in AWS with trust policy for your GitHub org/repo.
	2.	Assign permissions for S3, Batch, Lambda, SageMaker, and CodeBuild.
	3.	Reference the OIDC role ARN in your GitHub Actions workflows:

permissions:
  id-token: write
  contents: read
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<ACCOUNT_ID>:role/GitHubOIDCDeployRole
          aws-region: us-east-1



⸻

🔄 Full Pipeline Flow

Step	Platform	Function	Output
1	GitHub Actions	download-chunk.yml — Downloads & chunks Gospel audio	S3 raw_audio/
2	AWS Batch	Labeler — Extracts note/pitch annotations	S3 annotations/
3	AWS Batch	Trainer — Builds .pt + .onnx models	S3 models/
4	AWS Lambda	Validates exported ONNX model	Verified model
5	SageMaker	Deploys ONNX to live inference endpoint	Active model
6	Gaming PC	C++/Python engine reads .onnx for real-time accompaniment	🎹 Live AI musician


⸻

Pipeline Diagram

graph TD
    A[GitHub Actions] --> B[S3: Raw Audio]
    B --> C[AWS Batch: Labeler]
    C --> D[S3: Annotations]
    D --> E[AWS Batch: Trainer]
    E --> F[S3: Models (.pt, .onnx)]
    F --> G[Lambda: Verify Model]
    G --> H[SageMaker Endpoint]
    H --> I[C++ Engine: Real-Time Cantabile Output]


⸻

⚙️ GitHub Actions Workflows

Workflow	Trigger	Description
download-chunk.yml	Manual or Weekly	Download and chunk Gospel audio
build-labeler.yml	Push to labeler/	Build and deploy labeler image
build-trainer.yml	Push to trainer/	Build and deploy trainer image
build-verify.yml	Push to verify/	Build and update Lambda
trigger-build.yml	Manual	Run full AWS CodeBuild pipeline
inference-sync.yml	On model update	Sync new ONNX to Gaming PC S3 folder


⸻

💻 Local Real-Time System (C++ + Python)

Component	Purpose
PitchDetection.cpp	Real-time pitch/tempo extraction
ONNXRuntime.cpp	Loads exported model for inference
MidiMapper.cpp	Converts model outputs to MIDI chords
AccompanimentEngine.cpp	Plays accompaniment through VST host
Pitch-Detection.py	Optional diagnostic test
Cantabile Performer	Runs VSTs with LoopMIDI routing
ASIO4ALL	Driver ensuring <15 ms latency

Example Launch (Windows)

AI_Accompaniment.exe --model model_latest.onnx --midi-out "LoopMIDI Port 1"


⸻

📁 Directory Structure

church-ai-musician-accompaniment/
├── .github/
│   ├── workflows/
│   │   ├── download-chunk.yml
│   │   ├── trigger-build.yml
│   │   ├── build-labeler.yml
│   │   ├── build-trainer.yml
│   │   └── build-verify.yml
│   └── scripts/
│       └── download_chunk.py
├── labeler/
│   ├── Dockerfile
│   └── labeler.py
├── trainer/
│   ├── Dockerfile
│   └── trainer.py
├── verify/
│   ├── Dockerfile
│   └── lambda_function.py
├── cpp-engine/
│   ├── PitchDetection.cpp
│   ├── ONNXRuntime.cpp
│   ├── MidiMapper.cpp
│   ├── AccompanimentEngine.cpp
│   └── CMakeLists.txt
├── urls.txt
├── buildspec.yml
└── README.md


⸻

📱 iPhone Control
	1.	Open GitHub App → Actions → Run download-chunk.yml
	2.	Monitor progress via AWS Console Mobile App → CloudShell
	3.	Commands to monitor:

aws s3 ls s3://clgihq-audio/models/
aws batch list-jobs --job-queue gpu-queue
aws logs tail /aws/lambda/verify-model-lambda


	4.	When model verified → download .onnx → load into PC C++ engine
	5.	Launch Cantabile → 🎶 AI ACCOMPANIES IN REAL TIME

⸻

🧠 Training and Performance Notes
	•	Trainer uses AWS Batch GPU instances (e.g. g5.xlarge).
	•	Model exported to .onnx for cross-platform C++ runtime.
	•	Local inference must maintain:
	•	Sample rate: 48 kHz
	•	Buffer: ≤ 64 samples
	•	Thread priority: Realtime
	•	Driver: RME or ASIO4ALL

⸻

🎵 Audio Sources

Source	Type	Link
YouTube	Pentecostal Services	urls.txt
Internet Archive	Public Domain	archive.org￼
Free Music Archive	Gospel	freemusicarchive.org￼
Baylor BGMPP	Gospel Archive	library.web.baylor.edu￼


⸻

🌅 The Vision

“To help encourage the saints with making a joyful noise unto the Lord.”
From CLGI-trained harmony to fully automated accompaniment for every Praise and Worship leader.

⸻

🧱 Built With
	•	GitHub Actions (OIDC) – secure automation
	•	AWS Batch / Lambda / SageMaker – model lifecycle
	•	Docker + Python – reproducible builds
	•	C++ + ONNX Runtime – real-time inference engine
	•	iPhone + AWS Console App – remote control & monitoring

⸻

✝️ THE CHURCH AI ACCOMPANIMENT

Helping Churches — One Key at a Time

⸻


⸻

🧠 AI Pipeline Setup: S3 → SQS → Lambda → AWS Batch (with GitHub OIDC)

This repository implements a modular, event-driven AI data pipeline using AWS services and GitHub Actions (OIDC) authentication — no AWS secrets required.

It supports both CPU and GPU (G5) compute environments and provides a clear path to deploy, train, and infer ML workloads on AWS, fully automated via GitHub.

⸻

⚙️ Pipeline Overview

S3 (data upload)
  ↓ event trigger
SQS (queue buffering)
  ↓ event trigger
Lambda (dispatch job)
  ↓
AWS Batch (C++ or Python workload)

Data flow summary:
	1.	Upload a file to S3.
	2.	S3 event sends notification to SQS.
	3.	Lambda consumes the SQS message and triggers an AWS Batch job.
	4.	AWS Batch runs a container task (e.g., preprocessing, inference, or model training).
	5.	Lifecycle rules clean up or archive results after completion.

⸻

🧩 OIDC Authentication (No AWS Secrets Required)

The GitHub workflow uses OpenID Connect (OIDC) for temporary credentials to access AWS.

Steps to enable:
	1.	In IAM → Create Role → “Web Identity” → “GitHub.”
	2.	Add your repo in the trust relationship (replace with your repo name):

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<account-id>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:sub": "repo:your-org/your-repo:ref:refs/heads/main"
        }
      }
    }
  ]
}


	3.	Attach these AWS managed policies:
	•	AmazonS3FullAccess
	•	AWSBatchFullAccess
	•	AWSLambda_FullAccess
	•	AmazonSQSFullAccess
	•	CloudWatchLogsFullAccess
	4.	In your GitHub workflow:

permissions:
  id-token: write
  contents: read

- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::<account-id>:role/GitHubOIDCRole
    aws-region: us-east-1



⸻

🧠 GPU / G5 Instance Requirement

If your AWS Batch jobs require GPU acceleration:
	•	Ensure G5 EC2 instances are enabled in your AWS account.
(Request a service quota increase under EC2 → Limits → Instance Types → G5.)
	•	In your Batch Compute Environment, specify:

InstanceTypes:
  - g5.xlarge



⸻

🧰 Optional YAML Control File

You can include a simple pipeline-control.yml file in your repo to enable/disable Lambda triggers:

lambda_trigger:
  enabled: true

Set enabled: false to pause the pipeline temporarily without deleting resources.

⸻

🧱 Bootstrap Script (Optional Quick Setup)

You can use the following script to create the pipeline components manually:

#!/bin/bash
# setup_pipeline.sh — quick setup script

set -e

AWS_REGION="us-east-1"
ACCOUNT_ID="<account-id>"
PROJECT_NAME="ai-pipeline"
BUCKET_NAME="${PROJECT_NAME}-data"
QUEUE_NAME="${PROJECT_NAME}-queue"
LAMBDA_NAME="${PROJECT_NAME}-trigger"
BATCH_ENV="${PROJECT_NAME}-env"
BATCH_QUEUE="${PROJECT_NAME}-job-queue"

# 1. S3 bucket
aws s3 mb s3://$BUCKET_NAME --region $AWS_REGION

# 2. SQS queue
aws sqs create-queue --queue-name $QUEUE_NAME

# 3. Lambda (placeholder zip)
aws lambda create-function \
  --function-name $LAMBDA_NAME \
  --runtime python3.11 \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://lambda.zip \
  --role arn:aws:iam::$ACCOUNT_ID:role/LambdaExecutionRole

# 4. Batch environment
aws batch create-compute-environment \
  --compute-environment-name $BATCH_ENV \
  --type MANAGED \
  --compute-resources type=FARGATE,allocationStrategy=SPOT_CAPACITY_OPTIMIZED,maxvCpus=256,subnets=subnet-xxxxxx,securityGroupIds=sg-xxxxxx,instanceRole=ecsInstanceRole \
  --service-role arn:aws:iam::$ACCOUNT_ID:role/AWSBatchServiceRole

# 5. Batch queue
aws batch create-job-queue \
  --job-queue-name $BATCH_QUEUE \
  --state ENABLED \
  --priority 1 \
  --compute-environment-order order=1,computeEnvironment=$BATCH_ENV


⸻

☁️ Optional CloudFormation Stack

You can deploy everything automatically using CloudFormation.
This template provisions:

✅ Components Created

Resource	Description
S3 Bucket	Stores input/output data and event triggers.
S3 Lifecycle Rule	Cleans up or archives processed files.
SQS Queue	Buffers S3 events to decouple processing.
Lambda Function	Reads messages from SQS and triggers Batch.
AWS Batch Compute Environment	Fargate or EC2 (optionally GPU-enabled).
AWS Batch Job Queue	Dispatches jobs to the compute environment.
IAM Roles & Policies	Grants correct access to each AWS component.


⸻

🧾 Roles and Permissions Created

Role	Key Permissions	Used By
LambdaExecutionRole	AWSLambdaBasicExecutionRole, AmazonSQSFullAccess, AWSBatchSubmitJobAccess	Lambda
BatchServiceRole	service-role/AWSBatchServiceRole	AWS Batch
BatchInstanceProfile	AmazonEC2ContainerServiceforEC2Role, CloudWatchLogsFullAccess	Batch EC2 instances
S3Policy	Allows S3 GetObject, PutObject, and event notification setup	S3
SQSPolicy	Grants SQS read/write and Lambda trigger permissions	SQS
GitHubOIDCRole	Trusts GitHub OIDC tokens for temporary AWS access	GitHub Actions


⸻

📜 CloudFormation Template (Excerpt)

AWSTemplateFormatVersion: "2010-09-09"
Description: "AI Pipeline Stack - S3 → SQS → Lambda → AWS Batch with OIDC"

Resources:
  DataBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "${AWS::StackName}-data"
      LifecycleConfiguration:
        Rules:
          - Id: CleanupOldFiles
            Status: Enabled
            ExpirationInDays: 30

  Queue:
    Type: AWS::SQS::Queue
    Properties:
      QueueName: !Sub "${AWS::StackName}-queue"

  LambdaRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
        - arn:aws:iam::aws:policy/AmazonSQSFullAccess
        - arn:aws:iam::aws:policy/AWSBatchFullAccess

  LambdaFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: !Sub "${AWS::StackName}-trigger"
      Runtime: python3.11
      Handler: lambda_function.lambda_handler
      Role: !GetAtt LambdaRole.Arn
      Code:
        ZipFile: |
          import boto3, json, os
          def lambda_handler(event, context):
              batch = boto3.client('batch')
              for record in event['Records']:
                  msg = json.loads(record['body'])
                  s3_key = msg['Records'][0]['s3']['object']['key']
                  batch.submit_job(
                      jobName=f"process-{s3_key}",
                      jobQueue=os.environ['BATCH_QUEUE'],
                      jobDefinition=os.environ['BATCH_JOB_DEF'],
                      containerOverrides={'environment': [{'name': 'S3_KEY', 'value': s3_key}]}
                  )
              return {'status': 'ok'}

  BatchServiceRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: batch.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole

Outputs:
  BucketName:
    Value: !Ref DataBucket
  QueueURL:
    Value: !Ref Queue
  LambdaName:
    Value: !Ref LambdaFunction


⸻

🪜 Deployment

To deploy the stack:

aws cloudformation deploy \
  --template-file ai-pipeline-stack.yml \
  --stack-name ai-pipeline \
  --capabilities CAPABILITY_NAMED_IAM


⸻

✅ Summary

Feature	Description
Fully Event-Driven	No cron jobs — triggers cascade automatically.
No Static Secrets	Uses OIDC federation from GitHub Actions.
Configurable Pipeline	YAML toggle for pausing Lambda trigger.
Lifecycle Management	S3 cleanup built-in.
GPU-Ready	Supports G5 instances for AI workloads.
One-Click Stack	Optional CloudFormation template to deploy everything.


⸻
