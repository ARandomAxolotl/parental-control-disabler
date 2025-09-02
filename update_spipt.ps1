#
# Tập lệnh kiểm tra, tải, giải nén và dọn dẹp bản cập nhật từ GitHub
# Tên file: update_script.ps1
#

# --- Đọc cấu hình từ file config.txt ---
$configPath = "config.txt"
if (-not (Test-Path $configPath)) {
    Write-Host "Lỗi: Không tìm thấy file config.txt. Vui lòng tạo file này và điền thông tin." -ForegroundColor Red
    exit
}

$config = @{}
Get-Content $configPath | Where-Object { $_ -match '=' } | ForEach-Object {
    $parts = $_.Split('=')
    $key = $parts[0].Trim()
    $value = $parts[1].Trim()
    $config[$key] = $value
}

$githubUser = $config['GithubUser']
$githubRepo = $config['GithubRepo']
$currentVersion = $config['CurrentVersion']
$allowSnapshots = [bool]::Parse($config['AllowSnapshots'])
$allowAutoUpdate = [bool]::Parse($config['AllowAutoUpdate'])
$internetCheckingAllowed = [bool]::Parse($config['InternetCheckingAllowed'])
$appPath = Get-Location

# --- Chức năng chính ---
function Check-For-Updates {
    # Kiểm tra tùy chọn tự động cập nhật
    if (-not $allowAutoUpdate) {
        Write-Host "Auto update is disabler in the config.txt"
        return
    }

    # Kiểm tra kết nối internet
    if (-not $internetCheckingAllowed) {
        Write-Host "Connect to the internet to start installing"
        return
    }

    try {
        Write-Host "Checking for updates..."
        
        # Thêm một bước kiểm tra kết nối internet đơn giản trước khi gọi API
        try {
            # Ping Google DNS để kiểm tra kết nối
            $pingResult = Test-Connection -ComputerName "8.8.8.8" -Count 1 -ErrorAction Stop | Select-Object -ExpandProperty StatusCode
            if ($pingResult -ne 0) {
                Write-Host "No Internet connection!" -ForegroundColor Yellow
                return
            }
        }
        catch {
            Write-Host "No Internet connection, please try again later..." -ForegroundColor Yellow
            return
        }

        $apiUrl = "https://api.github.com/repos/$githubUser/$githubRepo/releases"
        $releases = Invoke-RestMethod -Uri $apiUrl -Method Get

        $suitableRelease = $null
        $latestVersionFound = [version]"0.0.0"

        foreach ($release in $releases) {
            $versionTag = $release.tag_name.TrimStart('v')
            $versionParts = $versionTag.Split('.')
            
            if ($versionParts.Count -lt 3) { continue }
            
            $versionType = [int]$versionParts[1]
            $currentVersionParsed = [version]$currentVersion

            if ([version]$versionTag -le $currentVersionParsed) { continue }
            
            if (($versionType -eq 0 -or $versionType -eq 1) -and ([version]$versionTag -gt $latestVersionFound)) {
                $latestVersionFound = [version]$versionTag
                $suitableRelease = $release
            } elseif ($allowSnapshots -and $versionType -eq 3 -and ([version]$versionTag -gt $latestVersionFound)) {
                $latestVersionFound = [version]$versionTag
                $suitableRelease = $release
            }
        }
        
        if ($null -ne $suitableRelease) {
            Write-Host "Có phiên bản mới: $($latestVersionFound). Đang tải xuống..."
            
            $assetUrl = $null
            $fileName = $null
            
            foreach ($asset in $suitableRelease.assets) {
                if ($asset.name.EndsWith(".zip")) {
                    $assetUrl = $asset.browser_download_url
                    $fileName = $asset.name
                    break
                }
            }
            
            if ($assetUrl) {
                $downloadedFilePath = Join-Path $appPath $fileName
                $extractPath = Join-Path $appPath "update_temp"
                
                Write-Host "Downloading $fileName..."
                Invoke-WebRequest -Uri $assetUrl -OutFile $downloadedFilePath
                Write-Host "Finished download, extracting"
                
                if (Test-Path $extractPath) {
                    Remove-Item $extractPath -Recurse -Force
                }
                Expand-Archive -Path $downloadedFilePath -DestinationPath $extractPath -Force
                
                Write-Host "Moving files and folders..."
                Get-ChildItem -Path $extractPath -Recurse -Force | ForEach-Object {
                    $destFile = $_.FullName -replace [regex]::Escape($extractPath), [regex]::Escape($appPath)
                    if ($_.PSIsContainer) {
                        if (-not (Test-Path $destFile)) { New-Item -ItemType Directory -Path $destFile | Out-Null }
                    } else {
                        Copy-Item -Path $_.FullName -Destination $destFile -Force
                    }
                }
                
                Write-Host "Finished update, cleaning up..."
                Remove-Item $downloadedFilePath -Force
                Remove-Item $extractPath -Recurse -Force
                Write-Host "Cập nhật thành công!"
            } else {
                Write-Host "Can't find the download .zip file"
            }
        } else {
            Write-Host "You are using the newest verson : ($currentVersion)."
        }
    } catch {
        Write-Host "An error : $_" -ForegroundColor Red
    }
}

Check-For-Updates
