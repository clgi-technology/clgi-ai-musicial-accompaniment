# verify-model-lambda-deploy.ps1 — v16: VERIFIED PUSH + RETRY + DEBUG
$ErrorActionPreference = "Continue"

# === CONFIG ===
$ECR_REPO = "224553687012.dkr.ecr.us-east-1.amazonaws.com/verify-model-repo"
$FUNCTION_NAME = "verify-model-lambda"
$ROLE_ARN = "arn:aws:iam::224553687012:role/LambdaBatchTriggerRole"
$REGION = "us-east-1"

# === 1. CLEAN & CREATE BUILDX ===
Write-Host "Setting up Docker Buildx..." -ForegroundColor Green
docker buildx rm lambda-builder *>&1 | Out-Null
docker buildx create --use --name lambda-builder --driver docker-container --platform linux/amd64 *>&1 | Out-Null
docker buildx inspect --bootstrap *>&1 | Out-Null

# === 2. BUILD & PUSH WITH VERIFICATION ===
Write-Host "Building and pushing image..." -ForegroundColor Green
$imageUri = "$ECR_REPO`:latest"

# Build and push
docker buildx build `
  --no-cache `
  --platform linux/amd64 `
  --provenance=false `
  -t $imageUri `
  --push `
  --output type=registry,oci-mediatypes=true `
  .

# === 3. WAIT & VERIFY IMAGE EXISTS IN ECR ===
Write-Host "Verifying image in ECR..." -ForegroundColor Green
$maxRetries = 12
$retry = 0
$digest = $null

do {
    Start-Sleep -Seconds 5
    $digest = aws ecr describe-images `
      --repository-name verify-model-repo `
      --region $REGION `
      --image-ids imageTag=latest `
      --query 'imageDetails[0].imageDigest' `
      --output text 2>$null

    if ($digest) {
        Write-Host "IMAGE CONFIRMED IN ECR: $digest" -ForegroundColor Green
        break
    }

    $retry++
    Write-Host "Retry $retry/$maxRetries - waiting for ECR sync..." -ForegroundColor Yellow
} while ($retry -lt $maxRetries)

if (-not $digest) {
    Write-Host "ERROR: Image failed to appear in ECR after 60s" -ForegroundColor Red
    exit 1
}

# === 4. UPDATE LAMBDA (SMART) ===
Write-Host "Updating Lambda function..." -ForegroundColor Green
try {
    aws lambda update-function-code `
      --function-name $FUNCTION_NAME `
      --image-uri $imageUri `
      --region $REGION | Out-Null
    Write-Host "Lambda UPDATED with $imageUri" -ForegroundColor Green

    # Optional: Ensure config
    aws lambda update-function-configuration `
      --function-name $FUNCTION_NAME `
      --timeout 180 `
      --memory-size 3008 `
      --region $REGION | Out-Null
} catch {
    Write-Host "Function not found. Creating..." -ForegroundColor Yellow
    aws lambda create-function `
      --function-name $FUNCTION_NAME `
      --package-type Image `
      --code ImageUri=$imageUri `
      --role $ROLE_ARN `
      --timeout 180 `
      --memory-size 3008 `
      --region $REGION
    Write-Host "Lambda CREATED." -ForegroundColor Green
}

Write-Host "`nLAMBDA READY!" -ForegroundColor Green
Write-Host "Test upload:" -ForegroundColor Yellow
Write-Host "  aws s3 cp test.onnx s3://clgihq-audio/models/debug-test.onnx"
Write-Host "`nWatch logs:" -ForegroundColor Cyan
Write-Host "  aws logs filter-log-events --log-group-name /aws/lambda/verify-model-lambda --filter-pattern 'DEBUG' --start-time (Get-Date).AddMinutes(-10).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ')"