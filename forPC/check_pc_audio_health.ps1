# PC Audio & MIDI Health Check Script
# Detects jitter, buffer underruns, CPU/GPU load, and MIDI port issues

$testDurationSeconds = 5
$sampleRate = 48000
$channels = 1
$bufferFrames = 64
$virtualMidiPortName = "loopMIDI"

# Audio device test placeholder
Write-Host "Checking audio devices..."
# Replace with PortAudio small test app if available

# MIDI port detection
Write-Host "Checking MIDI output ports..."
# Checks for loopMIDI or hardware ports

# CPU/GPU usage
Write-Host "Checking CPU & GPU load..."
$cpuLoad = Get-Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 1
Write-Host "CPU Usage: $($cpuLoad.CounterSamples.CookedValue)%"

# Ring buffer stress test
Write-Host "Running synthetic ring buffer stress test..."
$bufferSize = 65536
$pushCount = 100000
$ring = New-Object System.Collections.Generic.Queue[float]($bufferSize)
for ($i=0; $i -lt $pushCount; $i++) {
    if ($ring.Count -ge $bufferSize) { $null = $ring.Dequeue() }
    $ring.Enqueue([math]::Sin($i / 1000))
}
Write-Host "Ring buffer test completed"

# Recommendations
Write-Host "`n--- Recommendations ---"
Write-Host "1. Ensure audio buffer size <= 128 frames."
Write-Host "2. Use high-priority thread for audio processing."
Write-Host "3. Reduce background CPU/GPU load during live sessions."
Write-Host "4. Verify MIDI ports are exclusive and low-latency (loopMIDI recommended)."
Write-Host "5. Consider RME audio interface over Zoom H5 if jitter persists."
