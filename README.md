# Network Optimization Scripts for Windows

PowerShell scripts to reduce network chattiness and improve performance on Windows systems.

## Scripts

### 1. `Optimize-NetworkChattiness.ps1`
Basic network optimization script that performs the four most impactful fixes.

**What it does:**
- Disables Windows Update P2P (Delivery Optimization)
- Enables OneDrive Files On-Demand
- Disables NetBIOS over TCP/IP
- Flushes DNS cache

**Usage:**
```powershell
.\Optimize-NetworkChattiness.ps1
```

### 2. `Optimize-NetworkAdvanced.ps1`
Advanced optimization script with 17 modular optimizations across 4 categories.

**Categories:**
- **Basic**: P2P, OneDrive, NetBIOS, DNS (4 optimizations)
- **Services**: LLMNR, SSDP, Teredo, HomeGroup, Remote Registry (5 optimizations)
- **Performance**: Network throttling, Superfetch, Search indexing, IPv6 (4 optimizations)
- **Privacy**: Telemetry, Tips, Store updates, Xbox DVR (4 optimizations)

**Usage:**
```powershell
# Apply all optimizations
.\Optimize-NetworkAdvanced.ps1 -All

# Apply specific categories
.\Optimize-NetworkAdvanced.ps1 -Basic
.\Optimize-NetworkAdvanced.ps1 -Services
.\Optimize-NetworkAdvanced.ps1 -Performance
.\Optimize-NetworkAdvanced.ps1 -Privacy

# Combine multiple categories
.\Optimize-NetworkAdvanced.ps1 -Basic -Services
```

## Requirements

- Windows 10/11
- PowerShell 5.1 or later
- Administrator privileges

## Installation

```powershell
# Clone the repository
git clone https://github.com/wslabn/networkHelp.git
cd networkHelp

# Run as Administrator
.\Optimize-NetworkChattiness.ps1
# or
.\Optimize-NetworkAdvanced.ps1 -All
```

## Important Notes

- **Administrator rights required**: Both scripts must be run as Administrator
- **Restart recommended**: Restart your computer after running for all changes to take effect
- **IPv6 warning**: The Performance category disables IPv6. Skip this if you need IPv6
- **Backup**: Consider creating a system restore point before running

## What Gets Optimized

### Network Chattiness Reduction
- Stops PC from sharing Windows updates with other computers
- Reduces broadcast traffic on local network
- Eliminates legacy protocol noise (NetBIOS, LLMNR)
- Disables UPnP device discovery

### Performance Improvements
- Removes network throttling limits
- Optimizes OneDrive sync behavior
- Reduces background disk I/O
- Clears DNS resolver cache

### Privacy & Background Activity
- Disables telemetry collection
- Stops automatic app updates
- Reduces background app network usage
- Disables Xbox Game DVR recording

## Troubleshooting

If you need to revert changes:
- Re-enable Delivery Optimization in Windows Settings
- Re-enable services via `services.msc`
- Re-enable IPv6: `Enable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6`

## License

MIT License - Feel free to use and modify

## Contributing

Issues and pull requests welcome!
