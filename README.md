# 🎶 Church AI Accompaniment  
**CLGI and other Pentecostal Gospel Audio → AI Model → Cantabile Accompaniment**  
*Fully automated, GitHub-native, iPhone-controlled pipeline to source audio, label and train the audio and then create an AI model that gets trained on the data which is then loaded onto a gaming PC to provide music accompaniment to a singer*
*Singer is able to sing in the mic and the AI is able to understand the pitch, tempo and what advanced chords/notes to play to accompany the singer all in real time*
---

## 📖 Requirements

| Name                                   | Purpose                                                                                |
| -------------------------------------- | -------------------------------------------------------------------------------------- |
| AWS ACCOUNT                            | Need S3, SQS, Lambda, Batch, IAM, ECS, ECR, Autoscalling, EC2, Sagemaker               |
| Radeon Gaming PC w/ GPU 5090           | Needed to reduce latency to under 15ms so AI music is not laggy                        |
| RME BABYFACE FS PRO AUDIO INTERFACE    | Needed to connect a microphone or PA system to the PC and reduce latency               |
| PC OPTIMAZATION SCRIPTS                | Further help reduce latency & Jitter (throttles CPU and RAM an other parts of the PC)  |


---


---

## 📖 Overview

| Step | Service | Output |
|------|----------|---------|
| 1 | `download-chunk.yml` | Raw audio → S3 |
| 2 | AWS Batch (Labeler) | Annotations |
| 3 | AWS Batch (Trainer) | `.pt` + `.onnx` |
| 4 | Lambda (`verify-model-lambda`) | ONNX validation |
| 5 | SageMaker | Live inference endpoint |
| 6 | **Cantabile** | **AI ACCOMPANIES** |

---

## 🔄 Pipeline Flow

```mermaid
graph TD
    A[GitHub Actions] --> B[S3: Raw Audio]
    B --> C[AWS Batch: Labeler]
    C --> D[S3: Annotations]
    D --> E[AWS Batch: Trainer]
    E --> F[S3: .pt + .onnx]
    F --> G[Lambda: Verify]
    G --> H[SageMaker Endpoint]
    H --> I[Cantabile Sings]
````

---

## ⚙️ GitHub Actions (Auto-Run on Push)

| Workflow             | Trigger            | Description                   |
| -------------------- | ------------------ | ----------------------------- |
| `download-chunk.yml` | Weekly or Manual   | Download & chunk gospel audio |
| `build-labeler.yml`  | Push to `labeler/` | Build & deploy labeler image  |
| `build-trainer.yml`  | Push to `trainer/` | Build & deploy trainer image  |
| `build-verify.yml`   | Push to `verify/`  | Update verification Lambda    |

---

## 🎵 Sources (DRM-Free Black Gospel)

| Source             | Type                 | Link                                                     |
| ------------------ | -------------------- | -------------------------------------------------------- |
| YouTube            | Pentecostal Services | `urls.txt`                                               |
| Internet Archive   | Public Domain        | [archive.org](https://archive.org)                       |
| Free Music Archive | Gospel               | [freemusicarchive.org](https://freemusicarchive.org)     |
| Baylor BGMPP       | Black Gospel Archive | [library.web.baylor.edu](https://library.web.baylor.edu) |

---

## 📱 iPhone Control (No Computer Required)

1. Open **GitHub App** → Edit file → Commit → Auto-build triggers
2. In **Actions tab**, run `download-chunk.yml` → starts full pipeline
3. Use **AWS Console App → CloudShell** to monitor:

   ```bash
   aws s3 ls s3://clgihq-audio/models/
   aws logs tail /aws/lambda/verify-model-lambda
   aws batch list-jobs --job-queue gpu-queue
   ```

---

## 📂 Directory Structure

```
church-ai-pipeline/
├── .github/workflows/
│   ├── build-trainer.yml
│   ├── build-labeler.yml
│   ├── build-verify.yml
│   └── download-chunk.yml
├── trainer/          → Dockerfile, trainer.py
├── labeler/          → Dockerfile, labeler.py
├── verify/           → Dockerfile, lambda_function.py
├── .github/scripts/  → download_chunk.py
├── urls.txt          → Gospel source URLs
└── README.md         → This file
```

---

## 🔐 GitHub Secrets

> Set these in **Settings → Secrets and Variables → Actions**

| Name                    | Description         |
| ----------------------- | ------------------- |
| `AWS_ACCESS_KEY_ID`     | Your AWS access key |
| `AWS_SECRET_ACCESS_KEY` | Your AWS secret key |
| `YOUTUBE_COOKIES`       | COOKIES.TXT file    |

---

## 🧪 Test the Pipeline (from iPhone)

1. In **GitHub App**, open **Actions → download-chunk.yml → Run workflow**
2. Wait for completion → Check S3: `data/raw_audio/`
3. Observe AWS Batch: `annotations/` → `models/`
4. **Cantabile** calls SageMaker → 🎶 **AI ACCOMPANIES**
5. NOTE - (Place AI model exported by Sagemaker along with Cantibile/Loopmidi/ASIO4ALL drivers and Pitch-Detection.py script on Gaming PC with Nividia Graphics card model 5090 at minimum in accord for AI to accompany without delay or latency)

---

## 💻 Local Development (Optional)

```powershell
# Build & deploy the verify Lambda
.\verify-model-lambda-deploy.ps1

# Test upload
aws s3 cp test.onnx s3://clgihq-audio/models/debug-test.onnx
```

---

## 🌅 The Vision

> **"To help encourage the saints with a joyful noise unto the Lord."**
> From CLGI trained harmony — to fully automated, musical accompaniment for any Praise and Worship Leader.

---

## 🧱 Built With

* **GitHub Actions** — automation engine
* **AWS Batch, Lambda, SageMaker** — model lifecycle
* **Docker + Python** — reproducible builds
* **iPhone + AWS Console App** — mobile control

---

### ✝️ THE CHURCH AI ACCOMPANIMENT — HELPING CHURCHES ONE KEY AT A TIME





