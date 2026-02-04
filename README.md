# My PowerShell Settings

Apply or append my preferred PowerShell settings with these simple commands:

## Installation Options

### Option 1: Auto-Install (One-Liner)
Run the automated installer script:
```powershell
iwr -useb https://raw.githubusercontent.com/TehDomic/My-PowerShell-Settings/main/AutoInstall.ps1 | iex
```

### Option 2: Manual Installation
Download and **append the settings** to your existing PowerShell profile:
```powershell
iwr -useb https://raw.githubusercontent.com/TehDomic/My-PowerShell-Settings/main/Microsoft.PowerShell_profile.ps1 >> $PROFILE
```