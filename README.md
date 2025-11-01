Church AI Accompaniment
Fully automated, GitHub-native, iPhone-controlled pipeline that sources, labels, trains, and deploys Pentecostal Gospel audio into an AI model that provides real-time musical accompaniment for live singers.
Singer uses a microphone → AI understands pitch, tempo, and chords → AI plays advanced accompaniment in real time. CLGI and other Pentecostal Gospel Audio → AI Model → Cantabile Accompaniment

Purpose
To empower Pentecostal and Gospel musicians with an AI-driven accompanist that listens, learns, and plays along in real time — enabling worship anywhere, by anyone.

System Overview
Layer
Environment
Purpose
GitHub Actions + OIDC
Cloud
Secure automation using GitHub → AWS trust (no keys)
AWS Cloud
Cloud
Stores, labels, trains, and deploys the AI model
Gaming PC (C++/ONNX)
On-Prem
Runs the real-time AI inference system (< 15 ms latency)
iPhone
Controller
Triggers workflows and monitors status remotely

Requirements
Name
Purpose
Approx. Cost
AWS Account
S3, CodeBuild, CloudFront, SNS
~$50–$200/mo
Gaming PC (NVIDIA GPU)
Real-time inference < 15 ms
~$6000
RME Babyface Pro FS
Audio interface for mic/PA input
~$1000 (rme-usa.com)
Cantabile Performer
Hosts AI-driven accompaniment VST
$60–$500
C++ Real-Time Engine
Low-latency inference layer connecting ONNX model to MIDI/VST
Included
PC Optimization Scripts
Adjust CPU/RAM/ASIO/BIOS settings for minimal jitter
Free
GitHub Mobile + AWS Console App
iPhone-based monitoring and control
Free

Infrastructure Setup (One-Time)
No SQS, Lambda, or Batch required. Use GitHub + CodeBuild + S3 + CloudFront.
Option 1 – One-Click CodeBuild Project (Recommended)
aws codebuild create-project \
  --name church-ai-pipeline \
  --source type=GITHUB,location=https://github.com/your-org/church-ai-musician-accompaniment \
  --artifacts type=S3,location=clgihq-audio \
  --environment \
    type=LINUX_GPU_CONTAINER,\
    image=aws/codebuild/standard:7.0,\
    computeType=BUILD_GENERAL1_LARGE,\
    privilegedMode=true \
  --service-role arn:aws:iam::123456789012:role/CodeBuildServiceRole
This creates a GPU-enabled CodeBuild project that runs on every Git push.

Authentication (OIDC)
No AWS keys. No secrets.
Steps:
	1	Create IAM role with GitHub OIDC trust
	2	Attach policies: AmazonS3FullAccess, AWSCodeBuildAdminAccess, CloudFrontFullAccess
	3	Use in GitHub Actions:
permissions:
  id-token: write
  contents: read

- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::123456789012:role/GitHubOIDCDeployRole
    aws-region: us-east-1

Full Pipeline Flow
Step
Platform
Function
Output
1
GitHub Actions
Trigger CodeBuild
S3 raw_audio/
2
AWS CodeBuild
Labeler (Docker)
S3 annotations/
3
AWS CodeBuild
Trainer (GPU)
model_int8_vYYYYMMDD_HHMMSS.onnx
4
AWS CodeBuild
Verify + Quantize INT8
Verified model
5
S3 + CloudFront
Host model + SHA256
CDN URL
6
Gaming PC
C++ engine downloads & runs
Live AI accompaniment

Pipeline Diagram
graph TD
    A[GitHub Push] --> B[GitHub Actions]
    B --> C[AWS CodeBuild (GPU)]
    C --> D[Labeler → Trainer → Export INT8 ONNX]
    D --> E[S3 + CloudFront]
    E --> F[C++ App: Download + Verify SHA256]
    F --> G[ASIO → ONNX → MIDI → Cantabile → < 15 ms]

Continuous Model Updates
Model improves automatically as new audio is added.
Trigger: S3 → SNS → GitHub
// S3 Event → SNS
{
  "Event": "s3:ObjectCreated:*",
  "Prefix": "raw/",
  "Suffix": ".wav",
  "SnsTopic": "arn:aws:sns:us-east-1:123456789012:church-ai-retrain"
}
# SNS → GitHub Dispatch
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:church-ai-retrain \
  --protocol https \
  --notification-endpoint https://api.github.com/repos/your-org/church-ai-musician-accompaniment/dispatches \
  --attributes '{"RawMessageDelivery":"true"}'

GitHub Actions Workflows
Workflow
Trigger
Description
retrain.yml
repository_dispatch
Runs on new audio upload
build-labeler.yml
Push to labeler/
Build labeler Docker
build-trainer.yml
Push to trainer/
Build trainer Docker
model-deploy.yml
On model update
Upload to S3 + CloudFront
inference-sync.yml
Manual
Force C++ app to check for updates

Local Real-Time System (C++ + ONNX)
Component | Purpose
—|— PitchDetection.cpp | Real-time pitch/tempo extraction ONNXRuntime.cpp | Loads INT8 ONNX model for inference MidiMapper.cpp | Converts model outputs to MIDI chords AccompanimentEngine.cpp | Plays accompaniment through VST host Cantabile Performer | Runs VSTs with LoopMIDI routing ASIO (RME) | Driver ensuring < 15 ms latency

Critical Launch Settings
	•	Model: model_int8_*.onnx (INT8 quantized)
	•	GPU: --cuda flag
	•	Buffer: 64 samples @ 48 kHz
	•	MIDI: loopMIDI port "RealtimeAI"
# Download latest model
curl -L https://cdn.ai-music.com/models/latest/model_int8.onnx -o model_int8.onnx

# Launch
.\ChurchAI.exe --model model_int8.onnx --cuda --midi "RealtimeAI"

Directory Structure
church-ai-musician-accompaniment/
├── .github/
│   ├── workflows/
│   │   ├── retrain.yml
│   │   ├── model-deploy.yml
│   │   └── build-*.yml
│   └── scripts/
│       └── download_chunk.py
├── labeler/
│   ├── Dockerfile
│   └── labeler.py
├── trainer/
│   ├── Dockerfile
│   └── trainer.py
├── cpp-engine/
│   ├── PitchDetection.cpp
│   ├── ONNXRuntime.cpp
│   ├── MidiMapper.cpp
│   ├── AccompanimentEngine.cpp
│   └── CMakeLists.txt
├── urls.txt
├── buildspec.yml
└── README.md

iPhone Control
	1	Open GitHub App → Actions → Run retrain.yml
	2	Monitor via AWS Console Mobile App → CodeBuild
	3	Check logs:
aws codebuild batch-get-builds --ids 
	4	When model verified → C++ app auto-downloads new version
	5	Launch Cantabile → AI ACCOMPANIES IN REAL TIME

Training and Performance Notes
	•	Trainer uses AWS CodeBuild GPU (g5.xlarge)
	•	Model exported to INT8 ONNX for C++ runtime
	•	Local inference must maintain:
	◦	Sample rate: 48 kHz
	◦	Buffer: ≤ 64 samples
	◦	Thread priority: Realtime
	◦	Driver: RME or ASIO4ALL

Audio Sources
Source
Type
Link
YouTube
Pentecostal Services
urls.txt
Internet Archive
Public Domain
archive.org
Free Music Archive
Gospel
freemusicarchive.org
Baylor BGMPP
Gospel Archive
library.web.baylor.edu

The Vision
“To help encourage the saints with making a joyful noise unto the Lord.” From CLGI-trained harmony to fully automated accompaniment for every Praise and Worship leader.

Built With
	•	GitHub Actions (OIDC) – secure automation
	•	AWS CodeBuild (GPU) – training
	•	S3 + CloudFront – model distribution
	•	C++ + ONNX Runtime – real-time inference engine
	•	iPhone + AWS Console App – remote control & monitoring

THE CHURCH AI ACCOMPANIMENT
Helping Churches — One Key at a Time

Continuous Improvement (How the Model Gets Better)
	1	New audio uploaded to s3://clgihq-audio/raw/
	2	S3 Event → SNS → GitHub Dispatch
	3	GitHub Actions → CodeBuild (GPU)
	4	CodeBuild:
	◦	Labels new audio
	◦	Resumes training from previous checkpoint
	◦	Exports new INT8 ONNX model with version v20250405_120000
	◦	Uploads to s3://clgihq-audio/models/v20250405_120000/
	◦	Updates latest.txt
	5	C++ App (on startup):
	◦	Checks latest.txt
	◦	Downloads new model + SHA256
	◦	Verifies integrity
	◦	Reloads model without restart
Every new worship recording makes the AI smarter.

S3 Lifecycle (Auto-Cleanup)
{
  "Rules": [
    {
      "ID": "CleanRawAudio",
      "Prefix": "raw/",
      "Status": "Enabled",
      "Expiration": { "Days": 30 }
    }
  ]
}

Final Notes
	•	No SQS, Lambda, or Batch
	•	No local training
	•	No FP32 models
	•	No manual model updates
Train in the cloud. Accompany in the Spirit. Latency under 15 ms.
