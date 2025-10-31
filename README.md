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

