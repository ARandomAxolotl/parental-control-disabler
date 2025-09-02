#
# Tập lệnh bootloader - Tải và chạy tập lệnh cập nhật chính
# Tên file: start_app.ps1
#

# --- Cấu hình URLs ---
# Thay thế các URL này bằng URL "raw" từ GitHub Gist của bạn
$configUrl = "https://gist.githubusercontent.com/tên_người_dùng/id_gist_config/raw/config.txt"
$updateScriptUrl = "https://gist.githubusercontent.com/tên_người_dùng/id_gist_update/raw/update_script.ps1"

# --- Chức năng chính ---
function Initialize-Update-System {
    try {
        $configPath = "config.txt"
        $updateScriptPath = "update_script.ps1"
        
        $shouldDownloadConfig = -not (Test-Path $configPath)
        $shouldDownloadScript = -not (Test-Path $updateScriptPath)

        if ($shouldDownloadConfig) {
            Write-Host "Không tìm thấy file config.txt. Đang tải xuống..."
            Invoke-WebRequest -Uri $configUrl -OutFile $configPath
            Write-Host "Tải xuống config.txt hoàn tất."
        }

        if ($shouldDownloadScript) {
            Write-Host "Không tìm thấy file update_script.ps1. Đang tải xuống..."
            Invoke-WebRequest -Uri $updateScriptUrl -OutFile $updateScriptPath
            Write-Host "Tải xuống update_script.ps1 hoàn tất."
        }

        # Khởi chạy tập lệnh cập nhật chính
        Write-Host "Đang khởi chạy hệ thống cập nhật..."
        & "$updateScriptPath"
        
    } catch {
        Write-Host "Lỗi trong quá trình khởi tạo: $_" -ForegroundColor Red
    }
}

Initialize-Update-System
