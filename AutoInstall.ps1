# Fully Automated Script: Setting up WinGet, Windows Terminal, PowerShell 7.x, and PSReadLine
# Covers both Windows 10 and Windows 11 scenarios.

# Step 1: Verify/Ensure WinGet is Available
try {
    winget --version
    Write-Host "WinGet is already installed. Proceeding..." -ForegroundColor Green
} catch {
    Write-Host "WinGet not found. Attempting to install..." -ForegroundColor Yellow

    # Option 1: Try programmatic installation via Add-AppxPackage
    try {
        $Uri = "https://aka.ms/getwinget"
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $Uri -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msix"
        Add-AppxPackage "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msix"
        Write-Host "WinGet installed successfully." -ForegroundColor Green
    } catch {
        Write-Host "Could not install WinGet programmatically. Attempting fallback options..." -ForegroundColor Yellow

        # Option 2: Manual installation via GitHub if AppX infrastructure is missing
        Write-Host "AppX infrastructure may be missing. Using GitHub fallback..." -ForegroundColor Red

        try {
            $GitHubUri = "https://github.com/microsoft/winget-cli/releases/latest/download/winget.exe"
            Invoke-WebRequest -Uri $GitHubUri -OutFile "$env:SystemRoot\\System32\\winget.exe" -UseBasicParsing
            Write-Host "GitHub version of WinGet installed. Please note: updates will be manual." -ForegroundColor Green
        } catch {
            Write-Host "`nError: Could not install any version of WinGet. Please visit the following URLs for manual installation:" -ForegroundColor Red
            Write-Host "Microsoft Store: https://www.microsoft.com/store/productId/9NBLGGH4NNS1" -ForegroundColor Cyan
            Write-Host "GitHub Releases: https://github.com/microsoft/winget-cli/releases" -ForegroundColor Cyan
            exit
        }
    }
}

# Step 2: Verify/Ensure Windows Terminal is Installed
try {
    winget list --id "Microsoft.WindowsTerminal"
    Write-Host "Windows Terminal is already installed. Proceeding..." -ForegroundColor Green
} catch {
    Write-Host "Installing Windows Terminal..." -ForegroundColor Yellow
    winget install --id Microsoft.WindowsTerminal -e --source winget
}

# Step 3: Windows Terminal as Default Terminal Application
$winVersion = (Get-CimInstance Win32_OperatingSystem).Version
if ($winVersion -ge "10.0.22000") {
    # Windows 11
    Write-Host "Windows 11 detected. Setting Windows Terminal as the default terminal programmatically..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKCU:\Console" -Name "DefaultTerminalApplication" -Value "WindowsTerminal"
        Write-Host "Windows Terminal has been set as the default terminal application." -ForegroundColor Green
    } catch {
        Write-Host "Failed to set Windows Terminal as default programmatically. You might need to set it manually via system settings." -ForegroundColor Red
    }
} else {
    # Windows 10 or Unsupported OS
    Write-Host "Windows 10 detected. Skipping default terminal configuration, as it is not supported." -ForegroundColor Yellow
    Write-Host "You can still use Windows Terminal manually for your terminal tasks."
}

# Step 4: Install Latest Stable PowerShell 7.x
if (Get-Command pwsh -ErrorAction SilentlyContinue) {
    Write-Host "PowerShell 7 is already installed. Proceeding..." -ForegroundColor Green
} else {
    Write-Host "Installing PowerShell 7.x..." -ForegroundColor Yellow
    winget install --id Microsoft.PowerShell --source winget
}

# Step 5: Ensure Latest PSReadLine is Installed
Write-Host "Ensuring PSReadLine module is installed and up-to-date..." -ForegroundColor Yellow

# Fetch the latest version from PSGallery
$latestVersion = (Find-Module -Name PSReadLine -Repository PSGallery).Version
$installedVersion = (Get-Module -Name PSReadLine -ListAvailable | Select-Object -First 1).Version

if (-not $installedVersion -or $installedVersion -lt $latestVersion) {
    Write-Host "Installing/Updating PSReadLine to the latest version ($latestVersion)..." -ForegroundColor Yellow
    Install-Module -Name PSReadLine -Force -Scope CurrentUser -SkipPublisherCheck
} else {
    Write-Host "PSReadLine is already up-to-date (Version: $installedVersion)." -ForegroundColor Green
}

# Verify installation
if (Get-Module -Name PSReadLine -ListAvailable) {
    Write-Host "PSReadLine module is installed and ready to use." -ForegroundColor Green
} else {
    Write-Host "Error: PSReadLine installation failed. Please try manually." -ForegroundColor Red
}

# Step 6: Add PowerShell Profile Settings
$profilePath = $PROFILE.CurrentUserAllHosts
$settingsUrl = "https://github.com/TehDomic/My-PowerShell-Settings/raw/main/Microsoft.PowerShell_profile.ps1"
Write-Host "Adding custom PowerShell profile settings..." -ForegroundColor Yellow
if (-Not (Test-Path -Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
}
$settingsContent = Invoke-WebRequest -Uri $settingsUrl -UseBasicParsing | Select-Object -ExpandProperty Content
Add-Content -Path $profilePath -Value "`n# Custom PowerShell Profile Settings`n$settingsContent"
Write-Host "Custom settings added. Restart PowerShell to apply." -ForegroundColor Green