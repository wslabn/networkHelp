#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Reduces network chattiness by optimizing Windows Update P2P, OneDrive, NetBIOS, and DNS cache.
.DESCRIPTION
    Performs the following optimizations:
    1. Disables Windows Update P2P (Delivery Optimization)
    2. Enables OneDrive Files On-Demand
    3. Disables NetBIOS over TCP/IP on all adapters
    4. Flushes DNS cache
#>

Write-Host "=== Network Chattiness Optimization Script ===" -ForegroundColor Cyan
Write-Host ""

# 1. Disable Windows Update P2P (Delivery Optimization)
Write-Host "[1/4] Disabling Windows Update P2P (Delivery Optimization)..." -ForegroundColor Yellow
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0 -Type DWord -ErrorAction Stop
    Write-Host "  ✓ Delivery Optimization disabled" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed: $_" -ForegroundColor Red
}

# 2. Enable OneDrive Files On-Demand
Write-Host "[2/4] Enabling OneDrive Files On-Demand..." -ForegroundColor Yellow
try {
    $oneDrivePath = "HKCU:\Software\Microsoft\OneDrive"
    if (Test-Path $oneDrivePath) {
        Set-ItemProperty -Path $oneDrivePath -Name "EnableFileOnDemand" -Value 1 -Type DWord -ErrorAction Stop
        Write-Host "  ✓ OneDrive Files On-Demand enabled" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ OneDrive not installed or registry path not found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ✗ Failed: $_" -ForegroundColor Red
}

# 3. Disable NetBIOS over TCP/IP on all network adapters
Write-Host "[3/4] Disabling NetBIOS over TCP/IP..." -ForegroundColor Yellow
try {
    $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $count = 0
    foreach ($adapter in $adapters) {
        $adapter.SetTcpipNetbios(2) | Out-Null  # 2 = Disable NetBIOS
        $count++
    }
    Write-Host "  ✓ NetBIOS disabled on $count adapter(s)" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed: $_" -ForegroundColor Red
}

# 4. Flush DNS Cache
Write-Host "[4/4] Flushing DNS cache..." -ForegroundColor Yellow
try {
    Clear-DnsClientCache -ErrorAction Stop
    Write-Host "  ✓ DNS cache flushed successfully" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Optimization Complete ===" -ForegroundColor Cyan
Write-Host "A system restart is recommended for all changes to take effect." -ForegroundColor Yellow
