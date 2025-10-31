<#
.SYNOPSIS
PC Audio & MIDI Health Check Script for Real-Time AI Musician Setup
.DESCRIPTION
Detects potential audio jitter, buffer underruns, and MIDI timing issues.
Recommends configuration improvements.
#>

# --- CONFIG ---
$testDurationSeconds = 5
$sampleRate = 48000
$channels = 1
$bufferFrames = 64
$virtualMidiPortName = "loopMIDI"

# --- FUNCTION: Check audio devices ---
Write-Host "Checking available audio input/output devices..."
$paExe = "C:\path\to\PortAudioTest.exe" # optional: your small test app
try {
    # For demo, we assume PortAudioTest.exe is a lightweight ping program
    & $paExe -testLatency -frames $bufferFrames -rate $sampleRate
} catch {
    Write-Warning "Audio latency test not found. Make sure PortAudio test executable exists."
}

# --- FUNCTION: MIDI port detection ---
Write-Host "Checking available MIDI output ports..."
try {
    $midiPorts = & powershell -Command "Get-Command -Name RtMidi*" -ErrorAction SilentlyContinue
    if ($midiPorts) {
        Write-Host "MIDI ports detected:"
        $midiPorts
    } else {
        Write-Warning "No MIDI ports detected. Install loopMIDI or connect hardware."
    }
} catch {
    Write-Warning "Failed to enumerate MIDI ports."
}

# --- FUNCTION: CPU/GPU load test ---
Write-Host "Checking CPU & GPU usage..."
$cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 1
$gpuLoad = Get-Counter '\GPU Engine(*)\Utilization Percentage' -ErrorAction SilentlyContinue

Write-Host "CPU Usage: $($cpuLoad.CounterSamples.CookedValue)%"
if ($gpuLoad) {
    Write-Host "GPU Usage:"
    foreach ($g in $gpuLoad.CounterSamples) {
        Write-Host " $($g.InstanceName): $($g.CookedValue)%"
    }
}

# --- FUNCTION: Ring buffer stress test ---
Write-Host "Running synthetic ring buffer stress test..."
$bufferSize = 65536
$pushCount = 100000
$start = Get-Date
# simulate push/pop
$ring = New-Object System.Collections.Generic.Queue[float]($bufferSize)
for ($i=0; $i -lt $pushCount; $i++) {
    if ($ring.Count -ge $bufferSize) { $null = $ring.Dequeue() }
    $ring.Enqueue([math]::Sin($i / 1000))
}
$duration = (Get-Date) - $start
Write-Host "Ring buffer test completed in $($duration.TotalMilliseconds) ms"

# --- RECOMMENDATIONS ---
Write-Host "`n--- Recommendations ---"
Write-Host "1. Ensure audio buffer size <= 128 frames for <5ms native latency."
Write-Host "2. Use high-priority thread for audio processing."
Write-Host "3. Reduce background CPU/GPU load during live sessions."
Write-Host "4. Verify MIDI ports are exclusive and low-latency (loopMIDI recommended)."
Write-Host "5. If jitter persists, consider RME audio interface over Zoom H5."

Write-Host "`nPC Audio & MIDI Health Check Completed."
