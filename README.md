# My PowerShell Settings

Easily set up and apply my custom PowerShell configuration with the following options:

## Installation Options

### Option 1: Auto-Install (One-Liner)
For a fully automated setup, run this command:
```powershell
iwr -useb https://raw.githubusercontent.com/TehDomic/My-PowerShell-Settings/main/AutoInstall.ps1 | iex
```

This will:
1. Install WinGet (if missing).
2. Install Windows Terminal.
3. Configure Windows Terminal as the default terminal (on Windows 11).
4. Install PowerShell 7.x if not already installed.
5. Install or update the PSReadLine module.
6. Append the custom PowerShell profile settings for all users.

---

### Option 2: Manual Installation

If you prefer, you can follow these step-by-step instructions to manually set everything up.

---

#### **Step 1: Install WinGet**
1. Check if WinGet is installed:
   ```powershell
   winget --version
   ```
   - If it's already installed, proceed to the next step.
   - If not, follow these instructions:
     - **Option A**: Install via Add-AppxPackage:
       ```powershell
       $Uri = "https://aka.ms/getwinget"
       Invoke-WebRequest -Uri $Uri -OutFile "$env:TEMP\\WinGet.msix"
       Add-AppxPackage "$env:TEMP\\WinGet.msix"
       ```
     - **Option B**: Get the standalone executable:
       ```powershell
       iwr -useb https://github.com/microsoft/winget-cli/releases/latest/download/winget.exe -OutFile $env:SystemRoot\\System32\\winget.exe
       ```

---

#### **Step 2: Install Windows Terminal**
1. Check if Windows Terminal is installed:
   ```powershell
   winget list --id Microsoft.WindowsTerminal -q
   ```
2. If not installed, run:
   ```powershell
   winget install --id Microsoft.WindowsTerminal -e --source winget
   ```

---

#### **Step 3: Set Windows Terminal as Default Terminal (Windows 11 Only)**
1. Run the following command to configure Windows Terminal as the default:
   ```powershell
   Set-ItemProperty -Path "HKCU:\Console" -Name "DefaultTerminalApplication" -Value "WindowsTerminal"
   ```
2. On Windows 10, follow these manual steps:
   1. Open Windows Terminal.
   2. Go to **Settings** > **Startup**.
   3. Select Windows Terminal as the default terminal application.

---

#### **Step 4: Install PowerShell 7.x**
1. Check if PowerShell 7.x is installed:
   ```powershell
   pwsh --version
   ```
2. If not installed, run:
   ```powershell
   winget install --id Microsoft.PowerShell -e --source winget
   ```

---

#### **Step 5: Install or Update PSReadLine**
1. Check if the PSReadLine module is installed:
   ```powershell
   Get-Module -Name PSReadLine -ListAvailable
   ```
2. If not installed, or if the installed version is outdated:
   ```powershell
   Install-Module -Name PSReadLine -Force -Scope CurrentUser -SkipPublisherCheck
   ```

---

#### **Step 6: Apply Custom PowerShell Profile**
1. **Download the Profile Settings**:
   ```powershell
   iwr -useb https://raw.githubusercontent.com/TehDomic/My-PowerShell-Settings/main/Microsoft.PowerShell_profile.ps1 -OutFile Microsoft.PowerShell_profile.ps1
   ```

2. **Append the Settings to Your Current Profile**:
   ```powershell
   type Microsoft.PowerShell_profile.ps1 >> $PROFILE
   ```

3. **Restart PowerShell**: Close and reopen your terminal to apply the changes.

---

That's it! You've now manually set up your environment. If you encounter any issues, double-check each step or try the auto-install script.