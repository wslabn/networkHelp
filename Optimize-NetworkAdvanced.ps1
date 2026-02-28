#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Advanced network optimization script with modular options.
.PARAMETER All
    Apply all optimizations
.PARAMETER Basic
    Apply basic optimizations only (P2P, OneDrive, NetBIOS, DNS)
.PARAMETER Services
    Disable chatty services (LLMNR, SSDP, Teredo, HomeGroup)
.PARAMETER Performance
    Apply performance tweaks (throttling, RSS, Superfetch)
.PARAMETER Privacy
    Disable telemetry and background apps
#>

param(
    [switch]$All,
    [switch]$Basic,
    [switch]$Services,
    [switch]$Performance,
    [switch]$Privacy
)

if (-not ($All -or $Basic -or $Services -or $Performance -or $Privacy)) {
    Write-Host "=== Network Optimization Menu ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Select optimizations to apply:"
    Write-Host "  1. Basic only (P2P, OneDrive, NetBIOS, DNS)"
    Write-Host "  2. Services only (LLMNR, SSDP, Teredo, HomeGroup, Remote Registry)"
    Write-Host "  3. Performance only (Throttling, Superfetch, Search, IPv6)"
    Write-Host "  4. Privacy only (Telemetry, Tips, Store, Xbox)"
    Write-Host "  5. All optimizations (Recommended)"
    Write-Host "  6. Custom (Choose multiple categories)"
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-6)"
    
    switch ($choice) {
        "1" { $Basic = $true }
        "2" { $Services = $true }
        "3" { $Performance = $true }
        "4" { $Privacy = $true }
        "5" { $All = $true }
        "6" {
            Write-Host ""
            $Basic = (Read-Host "Apply Basic? (y/n)") -eq 'y'
            $Services = (Read-Host "Apply Services? (y/n)") -eq 'y'
            $Performance = (Read-Host "Apply Performance? (y/n)") -eq 'y'
            $Privacy = (Read-Host "Apply Privacy? (y/n)") -eq 'y'
        }
        default { 
            Write-Host "Invalid choice. Exiting." -ForegroundColor Red
            exit
        }
    }
    Write-Host ""
}

Write-Host "=== Advanced Network Optimization Script ===" -ForegroundColor Cyan
Write-Host ""

# BASIC OPTIMIZATIONS
if ($Basic -or $All) {
    Write-Host "--- BASIC OPTIMIZATIONS ---" -ForegroundColor Magenta
    
    Write-Host "[1] Disabling Delivery Optimization..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[2] Enabling OneDrive Files On-Demand..." -ForegroundColor Yellow
    try {
        if (Test-Path "HKCU:\Software\Microsoft\OneDrive") {
            Set-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive" -Name "EnableFileOnDemand" -Value 1 -Type DWord -Force
            Write-Host "  ✓ Done" -ForegroundColor Green
        } else { Write-Host "  ⚠ OneDrive not found" -ForegroundColor Yellow }
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[3] Disabling NetBIOS..." -ForegroundColor Yellow
    try {
        $adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }
        foreach ($adapter in $adapters) { $adapter.SetTcpipNetbios(2) | Out-Null }
        Write-Host "  ✓ Done on $($adapters.Count) adapter(s)" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[4] Flushing DNS cache..." -ForegroundColor Yellow
    try {
        Clear-DnsClientCache
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }
    Write-Host ""
}

# SERVICE OPTIMIZATIONS
if ($Services -or $All) {
    Write-Host "--- SERVICE OPTIMIZATIONS ---" -ForegroundColor Magenta
    
    Write-Host "[5] Disabling LLMNR..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" -Name "EnableMulticast" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[6] Disabling SSDP Discovery..." -ForegroundColor Yellow
    try {
        Stop-Service "SSDPSRV" -Force -ErrorAction SilentlyContinue
        Set-Service "SSDPSRV" -StartupType Disabled -ErrorAction Stop
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[7] Disabling Teredo..." -ForegroundColor Yellow
    try {
        Set-NetTeredoConfiguration -Type Disabled -ErrorAction Stop
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[8] Disabling HomeGroup services..." -ForegroundColor Yellow
    try {
        $hgServices = @("HomeGroupListener", "HomeGroupProvider")
        foreach ($svc in $hgServices) {
            if (Get-Service $svc -ErrorAction SilentlyContinue) {
                Stop-Service $svc -Force -ErrorAction SilentlyContinue
                Set-Service $svc -StartupType Disabled -ErrorAction SilentlyContinue
            }
        }
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[9] Disabling Remote Registry..." -ForegroundColor Yellow
    try {
        Stop-Service "RemoteRegistry" -Force -ErrorAction SilentlyContinue
        Set-Service "RemoteRegistry" -StartupType Disabled -ErrorAction Stop
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }
    Write-Host ""
}

# PERFORMANCE OPTIMIZATIONS
if ($Performance -or $All) {
    Write-Host "--- PERFORMANCE OPTIMIZATIONS ---" -ForegroundColor Magenta
    
    Write-Host "[10] Disabling Network Throttling..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[11] Disabling Superfetch/Sysmain..." -ForegroundColor Yellow
    try {
        Stop-Service "SysMain" -Force -ErrorAction SilentlyContinue
        Set-Service "SysMain" -StartupType Disabled -ErrorAction Stop
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[12] Disabling Windows Search network indexing..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Search" -Name "DisableRemovableDriveIndexing" -Value 1 -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[13] Disabling IPv6 (if not needed)..." -ForegroundColor Yellow
    try {
        Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6 -ErrorAction Stop
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }
    Write-Host ""
}

# PRIVACY OPTIMIZATIONS
if ($Privacy -or $All) {
    Write-Host "--- PRIVACY & BACKGROUND APPS ---" -ForegroundColor Magenta
    
    Write-Host "[14] Disabling Telemetry..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
        Stop-Service "DiagTrack" -Force -ErrorAction SilentlyContinue
        Set-Service "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[15] Disabling Windows Tips..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableSoftLanding" -Value 1 -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[16] Disabling Microsoft Store auto-updates..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Name "AutoDownload" -Value 2 -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }

    Write-Host "[17] Disabling Xbox Game DVR..." -ForegroundColor Yellow
    try {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord -Force
        Write-Host "  ✓ Done" -ForegroundColor Green
    } catch { Write-Host "  ✗ Failed: $_" -ForegroundColor Red }
    Write-Host ""
}

Write-Host "=== Optimization Complete ===" -ForegroundColor Cyan
Write-Host "Restart your computer for all changes to take effect." -ForegroundColor Yellow
