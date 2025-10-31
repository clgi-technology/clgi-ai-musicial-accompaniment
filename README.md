# 🎶 Church AI Pipeline  
**Black Gospel Pentecostal Audio → AI Model → Cantabile Sings**  
*Fully automated, GitHub-native, iPhone-controlled*

---

## 📖 Overview

| Step | Service | Output |
|------|----------|---------|
| 1 | `download-chunk.yml` | Raw audio → S3 |
| 2 | AWS Batch (Labeler) | Annotations |
| 3 | AWS Batch (Trainer) | `.pt` + `.onnx` |
| 4 | Lambda (`verify-model-lambda`) | ONNX validation |
| 5 | SageMaker | Live inference endpoint |
| 6 | **Cantabile** | **AI SINGS** |

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

---

## 🧪 Test the Pipeline (from iPhone)

1. In **GitHub App**, open **Actions → download-chunk.yml → Run workflow**
2. Wait for completion → Check S3: `data/raw_audio/`
3. Observe AWS Batch: `annotations/` → `models/`
4. **Cantabile** calls SageMaker → 🎶 **AI SINGS**

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

> **"Let the AI sing with the voice of the saints."**
> From raw Black Gospel to trained harmony — fully automated, eternally singing.

---

## 🧱 Built With

* **GitHub Actions** — automation engine
* **AWS Batch, Lambda, SageMaker** — model lifecycle
* **Docker + Python** — reproducible builds
* **iPhone + AWS Console App** — mobile control

---

### ✝️ THE CHURCH AI IS ALIVE — AND WILL SING FOREVER

```

```


