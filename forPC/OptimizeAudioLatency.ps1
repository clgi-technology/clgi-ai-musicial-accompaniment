# ===============================================
# Windows Audio Optimization Script
# for Real-Time AI & VST Performance (v2025)
# ===============================================

Write-Host "Applying system optimizations for low-latency audio..."

# --- 1. Power plan: High performance or Ultimate
Write-Host "Setting power plan to High Performance..."
powercfg -setactive SCHEME_MIN  # High Performance GUID
# Optional (if available)
if ((powercfg /list) -match "Ultimate Performance") {
    Write-Host "Enabling Ultimate Performance plan..."
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
}

# --- 2. Disable CPU core parking and frequency scaling
Write-Host "Disabling core parking and CPU throttling..."
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMAXCORES 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg -setactive SCHEME_CURRENT

# --- 3. Disable USB selective suspend
Write-Host "Disabling USB selective suspend..."
powercfg -setacvalueindex SCHEME_CURRENT SUB_USB USBSELECTSUSPEND 0

# --- 4. Disable system sleep/hibernate
powercfg -change -standby-timeout-ac 0
powercfg -change -hibernate-timeout-ac 0
powercfg -h off

# --- 5. Disable Windows visual effects (best performance)
Write-Host "Setting visual effects to Best Performance..."
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2 -Force

# --- 6. Disable background apps (privacy settings)
Write-Host "Disabling background apps..."
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 1 -Force

# --- 7. Disable Xbox/Game Bar features
Write-Host "Disabling Game Bar and Xbox overlays..."
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f

# --- 8. Disable Windows tips & background telemetry (safe level)
Write-Host "Reducing background telemetry..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f

# --- 9. Disable automatic updates temporarily (manual control)
Write-Host "Setting Windows Update to manual (you can re-enable later)..."
sc config wuauserv start= demand

# --- 10. Set audio service priority boost
Write-Host "Boosting Audio Service thread priority..."
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Scheduling Category" /t REG_SZ /d "High" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio" /v "Priority" /t REG_DWORD /d 6 /f

Write-Host "Optimization complete. Restart your PC for all changes to apply."
# ===============================================
