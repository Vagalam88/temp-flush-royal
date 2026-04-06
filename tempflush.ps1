# =====================================================
#   Temp Flush Royal
#   Ultimate Temporary & Unnecessary Files Cleaner
#   Windows 11 - with Drive Selection
# =====================================================

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Auto-elevate to Administrator if needed
if (-not (Test-Administrator)) {
    Write-Host "WARNING: This script must run as Administrator." -ForegroundColor Yellow
    Write-Host "Restarting in Administrator mode..." -ForegroundColor Cyan
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Clear-Host
Write-Host "TEMP FLUSH ROYAL" -ForegroundColor Green
Write-Host "Ultimate Temporary & Unnecessary Files Cleaner" -ForegroundColor White
Write-Host "Version 2.0 - With Multi-Drive Selection`n" -ForegroundColor Gray

# ====================== DRIVE SELECTION ======================
Write-Host "Scanning available drives..." -ForegroundColor Cyan

$drives = Get-Volume | 
    Where-Object { $_.DriveLetter -and $_.DriveType -in 'Fixed','Removable' } | 
    Select-Object DriveLetter, 
                  @{Name='Label';Expression={$_.FileSystemLabel}},
                  @{Name='Type';Expression={if($_.DriveType -eq 'Fixed'){'Internal HDD/SSD'} else {'Removable / USB / External'}}},
                  @{Name='SizeGB';Expression={[math]::Round($_.Size/1GB,1)}},
                  @{Name='FreeGB';Expression={[math]::Round($_.SizeRemaining/1GB,1)}} |
    Sort-Object DriveLetter

if ($drives.Count -eq 0) {
    Write-Host "No drives found!" -ForegroundColor Red
    exit
}

# Display drives
Write-Host "`nAvailable Drives:" -ForegroundColor Magenta
Write-Host "-----------------------------------------------------" -ForegroundColor Magenta
$i = 1
$driveList = @{}
foreach ($d in $drives) {
    $typeColor = if ($d.Type -like "*Internal*") {'White'} else {'Cyan'}
    Write-Host "$i. $($d.DriveLetter): " -NoNewline
    Write-Host "$($d.Label)" -ForegroundColor $typeColor -NoNewline
    Write-Host "  | Type: $($d.Type)  | Size: $($d.SizeGB) GB  | Free: $($d.FreeGB) GB"
    $driveList[$i] = $d.DriveLetter
    $i++
}
Write-Host "-----------------------------------------------------" -ForegroundColor Magenta

# User selection
Write-Host "`nWhich drive(s) do you want to clean?" -ForegroundColor Yellow
Write-Host "Examples: C     or     C,D,E     or     All" -ForegroundColor Gray
$selection = Read-Host "Enter drive letter(s) or 'All'"

# Process selection
$selectedDrives = @()
if ($selection -eq 'All' -or $selection -eq 'all') {
    $selectedDrives = $drives.DriveLetter
} else {
    $letters = $selection -split ',' | ForEach-Object { $_.Trim().ToUpper() }
    foreach ($letter in $letters) {
        if ($letter -match '^[A-Z]$' -and $drives.DriveLetter -contains $letter) {
            $selectedDrives += $letter
        }
    }
}

if ($selectedDrives.Count -eq 0) {
    Write-Host "`nNo valid drive selected. Exiting." -ForegroundColor Red
    exit
}

Write-Host "`nSelected drives for cleanup: $($selectedDrives -join ', ')" -ForegroundColor Green

$systemDrive = $env:SystemDrive.TrimEnd(':')

# ==================== PREVIEW PHASE ====================
$totalItems = 0

foreach ($drive in $selectedDrives) {
    $basePath = "$drive`:"
    Write-Host "`nPreview for drive $drive`:" -ForegroundColor Cyan

    $folders = @("$basePath\Temp")

    if (Test-Path "$basePath\Windows\Temp") {
        $folders += "$basePath\Windows\Temp"
    }

    if ($drive -eq $systemDrive) {
        $folders += @(
            "$env:SystemRoot\Prefetch",
            "$env:SystemRoot\SoftwareDistribution\Download",
            "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCookies",
            "$env:LOCALAPPDATA\Temp"
        )
    }

    foreach ($folder in $folders) {
        if (Test-Path $folder) {
            $count = (Get-ChildItem -Path "$folder\*" -Recurse -Force -ErrorAction SilentlyContinue).Count
            if ($count -gt 0) {
                Write-Host "   → $folder ($count items)" -ForegroundColor Yellow
                $totalItems += $count
            }
        }
    }
}

Write-Host "`nTOTAL ITEMS TO DELETE: $totalItems" -ForegroundColor Green
Write-Host "-----------------------------------------------------`n" -ForegroundColor Magenta

$confirmation = Read-Host "Proceed with deletion? (Y/N)"
if ($confirmation -notlike "Y*") {
    Write-Host "`nCleanup cancelled by user." -ForegroundColor Red
    exit
}

# ==================== CLEANUP PHASE ====================
Write-Host "`nStarting cleanup..." -ForegroundColor Green

foreach ($drive in $selectedDrives) {
    $basePath = "$drive`:"
    $folders = @("$basePath\Temp")

    if (Test-Path "$basePath\Windows\Temp") {
        $folders += "$basePath\Windows\Temp"
    }

    if ($drive -eq $systemDrive) {
        $folders += @(
            "$env:SystemRoot\Prefetch",
            "$env:SystemRoot\SoftwareDistribution\Download",
            "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCookies",
            "$env:LOCALAPPDATA\Temp"
        )
    }

    foreach ($folder in $folders) {
        if (Test-Path $folder) {
            Write-Host "Cleaning: $folder" -ForegroundColor Cyan
            Remove-Item -Path "$folder\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Extra system cleanup (only if system drive was selected)
if ($selectedDrives -contains $systemDrive) {
    Write-Host "Cleaning Thumbnail cache..." -ForegroundColor Cyan
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*" -Force -ErrorAction SilentlyContinue

    Write-Host "Emptying Recycle Bin..." -ForegroundColor Cyan
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
}

Write-Host "`nTEMP FLUSH ROYAL completed successfully!" -ForegroundColor Green
Write-Host "Drives cleaned: $($selectedDrives -join ', ')" -ForegroundColor White
Write-Host "`nTip: Restart your PC for best results." -ForegroundColor Yellow
Write-Host "You can now close this window." -ForegroundColor Gray
