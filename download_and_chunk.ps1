param (
    [Parameter(Mandatory=$true)][string]$YouTubeUrl,
    [Parameter(Mandatory=$true)][string]$OutputDir,
    [Parameter(Mandatory=$true)][string]$AwsAccessKey,
    [Parameter(Mandatory=$true)][string]$AwsSecretKey,
    [Parameter(Mandatory=$true)][string]$AwsBucketName,
    [Parameter(Mandatory=$true)][string]$AwsRegion,
    [Parameter(Mandatory=$false)][string]$LogFile = "C:\Scripts\processed_ids.txt",
    [Parameter(Mandatory=$false)][string]$CookiesFile = "C:\Scripts\cookies.txt",
    [Parameter(Mandatory=$false)][switch]$ScheduleTask,
    [Parameter(Mandatory=$false)][string]$ScheduleTime = "02:00",
    [Parameter(Mandatory=$false)][string]$TaskName = "YouTubeAudioProcessor"
)

# Ensure output folder exists
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

# Validate cookies file exists if specified
$useCookies = $false
if (Test-Path $CookiesFile) {
    $cookieContent = Get-Content $CookiesFile -Raw
    $requiredCookies = "__Secure-1PAPISID", "__Secure-1PSID", "__Secure-1PSIDTS", "__Secure-ROLLOUT_TOKEN", "__Secure-YSC", "APISID", "SID", "HSID", "SAPISID", "Secure-APISID"
    $foundCookies = (Select-String -InputObject $cookieContent -Pattern ($requiredCookies -join "|") -AllMatches).Matches.Value | Sort-Object -Unique
    if ($foundCookies.Count -gt 0) {
        $useCookies = $true
        Write-Verbose -Message "Using cookies from $CookiesFile. Found: $($foundCookies -join ', ')" -Verbose
        if ($foundCookies -notcontains "__Secure-YSC") {
            Write-Warning -Message "Missing __Secure-YSC (session cookie). May fail for live or new videos."
        }
    } else {
        Write-Warning -Message "Cookies file at $CookiesFile exists but lacks required cookies. Proceeding without cookies may fail for restricted videos."
    }
} else {
    Write-Warning -Message "Cookies file not found at $CookiesFile. Proceeding without cookies (may fail for restricted videos)."
}

# Initialize processed IDs log
if (-not (Test-Path $LogFile)) {
    New-Item -ItemType File -Path $LogFile | Out-Null
}
$processedIds = Get-Content $LogFile -ErrorAction SilentlyContinue | Where-Object { $_ -ne $null }

# Get all video IDs from the playlist/channel
if ($YouTubeUrl -match "@[a-zA-Z0-9_-]+" -or $YouTubeUrl -match "channel/UC[a-zA-Z0-9_-]{22}") {
    Write-Verbose -Message "Fetching video IDs from channel: $YouTubeUrl" -Verbose
    $videoIds = yt-dlp --get-id --flat-playlist $YouTubeUrl
} else {
    Write-Verbose -Message "Processing single video: $YouTubeUrl" -Verbose
    $videoIds = @(yt-dlp --get-id $YouTubeUrl)
}
$totalVideos = $videoIds.Count
Write-Verbose -Message "Total videos found: $totalVideos." -Verbose

# Function to upload with retry
function Send-ToS3WithRetry {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory=$true)][string]$FilePath,
        [Parameter(Mandatory=$true)][string]$BucketName,
        [Parameter(Mandatory=$false)][string]$Subfolder = "data/raw_audio",
        [Parameter(Mandatory=$true)][string]$AwsAccessKey,
        [Parameter(Mandatory=$true)][string]$AwsSecretKey,
        [Parameter(Mandatory=$true)][string]$AwsRegion
    )
    aws configure set aws_access_key_id $AwsAccessKey
    aws configure set aws_secret_access_key $AwsSecretKey
    aws configure set default.region $AwsRegion

    $maxRetries = 3
    $retryDelay = 2
    for ($i = 1; $i -le $maxRetries; $i++) {
        try {
            aws s3 cp $FilePath "s3://$BucketName/$Subfolder/" --region $AwsRegion
            Write-Verbose -Message "Uploaded $($FilePath) to s3://$BucketName/$Subfolder/" -Verbose
            return $true
        } catch {
            Write-Warning -Message ("Upload attempt {0} failed for {1}: {2}" -f $i, $FilePath, $_)
            if ($i -eq $maxRetries) {
                Write-Error -Message "Upload failed after $maxRetries attempts for $FilePath."
                return $false
            }
            Start-Sleep -Seconds ([Math]::Pow($retryDelay, $i))
        }
    }
}

# Function to create or update Task Scheduler task
function New-ScheduledTaskCustom {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory=$true)][string]$ScriptPath,
        [Parameter(Mandatory=$true)][string]$TaskName,
        [Parameter(Mandatory=$true)][string]$ScheduleTime,
        [Parameter(Mandatory=$true)][string]$YouTubeUrl,
        [Parameter(Mandatory=$true)][string]$AwsAccessKey,
        [Parameter(Mandatory=$true)][string]$AwsSecretKey,
        [Parameter(Mandatory=$true)][string]$AwsBucketName,
        [Parameter(Mandatory=$true)][string]$AwsRegion,
        [Parameter(Mandatory=$true)][string]$CookiesFile
    )

    if ($PSCmdlet.ShouldProcess("Task Scheduler", "Create or update task '$TaskName'")) {
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $ScriptPath -YouTubeUrl '$YouTubeUrl' -OutputDir '$OutputDir' -AwsAccessKey '$AwsAccessKey' -AwsSecretKey '$AwsSecretKey' -AwsBucketName '$AwsBucketName' -AwsRegion '$AwsRegion' -CookiesFile '$CookiesFile' -ScheduleTask"
        $trigger = New-ScheduledTaskTrigger -Daily -At $ScheduleTime
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 5)

        try {
            Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -ErrorAction Stop
            Write-Verbose -Message "Scheduled task '$TaskName' created or updated to run daily at $ScheduleTime." -Verbose
        } catch {
            Write-Error -Message "Failed to create scheduled task: $_"
        }
    }
}

# Create scheduled task if requested
if ($ScheduleTask) {
    $scriptPath = $PSCommandPath
    New-ScheduledTaskCustom -ScriptPath $scriptPath -TaskName $TaskName -ScheduleTime $ScheduleTime -YouTubeUrl $YouTubeUrl -AwsAccessKey $AwsAccessKey -AwsSecretKey $AwsSecretKey -AwsBucketName $AwsBucketName -AwsRegion $AwsRegion -CookiesFile $CookiesFile
    exit 0
}

# Process each video individually
foreach ($videoId in $videoIds) {
    if ($processedIds -contains $videoId) {
        Write-Verbose -Message "Skipping $videoId – already processed." -Verbose
        continue
    }

    $videoUrl = "https://www.youtube.com/watch?v=$videoId"
    Write-Verbose -Message "Processing video: $videoUrl" -Verbose

    # Download audio in WAV format with cookies if available
    $ytDlpArgs = @("-x", "--format", "bestaudio", "--audio-format", "wav", $videoUrl, "-o", "$OutputDir\%(title)s_$videoId.%(ext)s", "--restrict-filenames", "--sleep-requests", "10")
    $downloadOutput = $null
    if ($useCookies) {
        $ytDlpArgs += "--cookies", $CookiesFile
        Write-Verbose -Message "Using cookies from $CookiesFile for authentication." -Verbose
        $downloadOutput = & yt-dlp @ytDlpArgs 2>&1 | ForEach-Object { "$_" }
        if ($downloadOutput -match "The provided YouTube account cookies are no longer valid") {
            Write-Warning -Message "Cookies in $CookiesFile are invalid. Please re-export from a fresh browser session. See https://github.com/yt-dlp/yt-dlp/wiki/Extractors#exporting-youtube-cookies for details."
            $useCookies = $false
        }
    }
    if (-not $useCookies) {
        Write-Verbose -Message "Proceeding without cookies due to invalidation or absence." -Verbose
        $downloadOutput = & yt-dlp @ytDlpArgs 2>&1 | ForEach-Object { "$_" }
    }

    # Check download success
    if ($LASTEXITCODE -ne 0 -or $downloadOutput -match "ERROR|Unable to download") {
        Write-Warning -Message "Download failed for $videoId. Output: $downloadOutput"
        continue
    }

    # Locate downloaded WAV file
    $wavFile = Get-ChildItem -Path $OutputDir -Filter "*$videoId*.wav" | Select-Object -First 1
    if (-not $wavFile) {
        Write-Warning -Message "WAV file for $videoId not found. Skipping."
        continue
    }

    Write-Verbose -Message "Chunking $($wavFile.Name) into 30-second segments..." -Verbose
    $chunkPrefix = "$OutputDir\chunk_$($wavFile.BaseName)_%03d.wav"
    & "C:\Program Files\ffmpeg\bin\ffmpeg.exe" -i $wavFile.FullName -f segment -segment_time 30 -c copy $chunkPrefix -y 2>$null

    if ($LASTEXITCODE -ne 0) {
        Write-Warning -Message "Chunking failed for $($wavFile.Name). Skipping."
        Remove-Item $wavFile.FullName -Force
        continue
    }

    # Remove original WAV to save space
    Remove-Item $wavFile.FullName -Force

    # Upload chunks to S3 and remove after upload
    $chunks = Get-ChildItem -Path $OutputDir -Filter "chunk_$($wavFile.BaseName)_*.wav"
    foreach ($chunk in $chunks) {
        if (Send-ToS3WithRetry -FilePath $chunk.FullName -BucketName $AwsBucketName -AwsAccessKey $AwsAccessKey -AwsSecretKey $AwsSecretKey -AwsRegion $AwsRegion) {
            Remove-Item $chunk.FullName -Force
        } else {
            Write-Warning -Message "Failed to upload $($chunk.Name). Keeping file for retry."
        }
    }

    # Mark video as processed
    Add-Content -Path $LogFile -Value $videoId -ErrorAction SilentlyContinue
    $processedIds += $videoId
    Write-Verbose -Message "Completed processing for $videoId." -Verbose
} # Explicitly closing foreach loop

Write-Output "All videos processed or skipped." # Explicitly standalone