# 자동 배포 스크립트 (Auto-Deployer for index.html)
# 이 창을 띄워두고 index.html을 저장할 때마다 자동으로 깃허브에 배포됩니다.

$path = $PSScriptRoot
$file = "index.html"
$fullPath = Join-Path $path $file

Write-Host "🚀 자동 배포 로봇이 가동되었습니다!" -ForegroundColor Cyan
Write-Host "📁 감시 대상: $fullPath" -ForegroundColor White
Write-Host "✨ 이제 index.html을 수정하고 저장하면 자동으로 깃허브에 업데이트됩니다." -ForegroundColor Yellow
Write-Host "--------------------------------------------------------"

# 파일 감시 설정
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.Filter = $file
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# 변경 이벤트 발생 시 실행할 코드
$action = {
    $time = Get-Date -Format "HH:mm:ss"
    Write-Host "[$time] 📝 변경 감지! 깃허브로 전송을 시작합니다..." -ForegroundColor Green
    
    try {
        Set-Location $path
        git add $file
        git commit -m "Auto-update: $time"
        git push origin dev
        Write-Host "[$time] ✅ 업로드 완료! (dev 브랜치)" -ForegroundColor Cyan
        Write-Host "[$time] 🔍 품질 검사 루틴이 깃허브에서 시작되었습니다." -ForegroundColor White
    }
    catch {
        Write-Host "[$time] ❌ 오류 발생: $_" -ForegroundColor Red
    }
    Write-Host "--------------------------------------------------------"
}

# Remove existing event if any to avoid duplication
Unregister-Event -SourceIdentifier "FileChanged" -ErrorAction SilentlyContinue

# Connect the event
Register-ObjectEvent $watcher "Changed" -SourceIdentifier "FileChanged" -Action $action | Out-Null

Write-Host "⌛ Monitoring... (Press Ctrl+C to stop)" -ForegroundColor DarkGray
while ($true) { Start-Sleep -Seconds 1 }
}

# Remove existing event if any to avoid duplication
Unregister-Event -SourceIdentifier "FileChanged" -ErrorAction SilentlyContinue

# Connect the event
Register-ObjectEvent $watcher "Changed" -SourceIdentifier "FileChanged" -Action $action | Out-Null

Write-Host "⌛ Monitoring... (Press Ctrl+C to stop)" -ForegroundColor DarkGray
while ($true) { Start-Sleep -Seconds 1 }
