```
church-ai-pipeline/
├── .github/workflows/
│   ├── build-trainer.yml
│   ├── build-labeler.yml
│   ├── build-verify.yml
│   └── download-chunk.yml
├── trainer/
│   ├── Dockerfile
│   └── trainer.py
├── labeler/
│   ├── Dockerfile
│   └── labeler.py
├── verify/
│   ├── Dockerfile
│   └── lambda_function.py
├── download-chunk/
│   ├── download-chunk.ps1
│   └── chunk.ps1
├── .github/scripts/
│   └── download_chunk.py
├── urls.txt
└── README.md
```

# Church AI Pipeline  
**Black Gospel Pentecostal Audio → AI Model → Cantabile Sings**  
*Fully automated, GitHub-native, iPhone-controlled*

---

## Overview

| Step | Service | Output |
|------|--------|--------|
| 1 | `download-chunk.yml` | Raw audio → S3 |
| 2 | AWS Batch (Labeler) | Annotations |
| 3 | AWS Batch (Trainer) | `.pt` + `.onnx` |
| 4 | Lambda (`verify-model-lambda`) | ONNX validation |
| 5 | SageMaker | Live inference endpoint |
| 6 | **Cantabile** | **AI SINGS** |

---

## Pipeline Flow

```
mermaid
graph TD
    A[GitHub Actions] --> B[S3: Raw Audio]
    B --> C[AWS Batch: Labeler]
    C --> D[S3: Annotations]
    D --> E[AWS Batch: Trainer]
    E --> F[S3: .pt + .onnx]
    F --> G[Lambda: Verify]
    G --> H[SageMaker Endpoint]
    H --> I[Cantabile Sings]

GitHub Actions (Auto-Run on Push)


WorkflowTriggerActiondownload-chunk.ymlWeekly or ManualDownload + chunk gospel audiobuild-labeler.ymlPush to labeler/Build & deploy labelerbuild-trainer.ymlPush to trainer/Build & deploy trainerbuild-verify.ymlPush to verify/Update Lambda

Sources (DRM-Free Black Gospel)


SourceTypeLinkYouTubePentecostal Servicesurls.txtInternet ArchivePublic Domainarchive.orgFree Music ArchiveGospelfreemusicarchive.orgBaylor BGMPPBlack Gospel Archivelibrary.web.baylor.edu

iPhone Control (No Computer)

GitHub App → Edit file → Commit → Auto-build
Actions → Run download-chunk.yml → Start pipeline
AWS Console App → CloudShell → Run:
bashaws s3 ls s3://clgihq-audio/models/
aws logs tail /aws/lambda/verify-model-lambda
aws batch list-jobs --job-queue gpu-queue



Directory Structure
textchurch-ai-pipeline/
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

Secrets (GitHub Settings → Secrets)


NameValueAWS_ACCESS_KEY_IDYour keyAWS_SECRET_ACCESS_KEYYour secret

Test the Pipeline (iPhone)

GitHub App → Actions → download-chunk.yml → Run workflow
Wait → Check S3: data/raw_audio/
Watch Batch jobs → annotations/ → models/
Cantabile → Call SageMaker → AI SINGS


Local Development (Optional)
powershell# Build & deploy verify Lambda
.\verify-model-lambda-deploy.ps1

# Test
aws s3 cp test.onnx s3://clgihq-audio/models/debug-test.onnx

The Vision

"Let the AI sing with the voice of the saints."
— From raw Black Gospel to AI harmony, fully automated, eternally singing.


Built with

GitHub Actions
AWS Batch + Lambda + SageMaker
Docker + Python
iPhone + AWS Console App
