# Network Optimization Script for Windows

PowerShell script to reduce network chattiness and improve performance on Windows systems.

## Optimize-NetworkAdvanced.ps1

Modular optimization script with 17 optimizations across 4 categories.

**Categories:**
- **Basic**: P2P, OneDrive, NetBIOS, DNS (4 optimizations)
- **Services**: LLMNR, SSDP, Teredo, HomeGroup, Remote Registry (5 optimizations)
- **Performance**: Network throttling, Superfetch, Search indexing, IPv6 (4 optimizations)
- **Privacy**: Telemetry, Tips, Store updates, Xbox DVR (4 optimizations)

**Usage:**
```powershell
# Interactive menu (right-click > Run with PowerShell)
.\Optimize-NetworkAdvanced.ps1

# Or use command-line parameters
.\Optimize-NetworkAdvanced.ps1 -All
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
.\Optimize-NetworkAdvanced.ps1 -Basic  # Quick fix (4 optimizations)
.\Optimize-NetworkAdvanced.ps1 -All    # Full optimization (17 optimizations)
```

## Important Notes

- **Administrator rights required**: Script must be run as Administrator
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
