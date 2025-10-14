# Script PowerShell para encontrar e copiar FFmpeg
# Execute como: powershell -ExecutionPolicy Bypass -File encontrar_ffmpeg.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ENCONTRADOR E COPIADOR FFMPEG" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (Test-Path "ffmpeg.exe") {
    Write-Host "✓ FFmpeg já está na pasta do projeto!" -ForegroundColor Green
    Write-Host "Não precisa copiar novamente." -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 0
}

Write-Host "Procurando FFmpeg instalado..." -ForegroundColor Yellow

# Caminhos possíveis onde o FFmpeg pode estar
$possiblePaths = @(
    "C:\ProgramData\chocolatey\lib\ffmpeg\tools\ffmpeg\bin\ffmpeg.exe",
    "C:\tools\ffmpeg\bin\ffmpeg.exe",
    "C:\Program Files\ffmpeg\bin\ffmpeg.exe",
    "C:\Program Files (x86)\ffmpeg\bin\ffmpeg.exe",
    "C:\ffmpeg\bin\ffmpeg.exe"
)

$ffmpegFound = $null

# Verifica caminhos fixos
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $ffmpegFound = Split-Path $path -Parent
        Write-Host "✓ FFmpeg encontrado em: $ffmpegFound" -ForegroundColor Green
        break
    }
}

# Se não encontrou, tenta usar Get-Command
if (-not $ffmpegFound) {
    Write-Host "Procurando FFmpeg no PATH do sistema..." -ForegroundColor Yellow
    try {
        $ffmpegCommand = Get-Command ffmpeg -ErrorAction Stop
        $ffmpegFound = Split-Path $ffmpegCommand.Source -Parent
        Write-Host "✓ FFmpeg encontrado no PATH: $ffmpegFound" -ForegroundColor Green
    } catch {
        Write-Host "✗ FFmpeg não encontrado!" -ForegroundColor Red
        Write-Host ""
        Write-Host "SOLUÇÕES:" -ForegroundColor Yellow
        Write-Host "1. Execute: choco install ffmpeg -y" -ForegroundColor White
        Write-Host "2. Reinicie o terminal" -ForegroundColor White
        Write-Host "3. Execute este script novamente" -ForegroundColor White
        Write-Host ""
        Read-Host "Pressione Enter para sair"
        exit 1
    }
}

Write-Host ""
Write-Host "Copiando FFmpeg para a pasta do projeto..." -ForegroundColor Yellow

# Copia ffmpeg.exe
$ffmpegSource = Join-Path $ffmpegFound "ffmpeg.exe"
if (Test-Path $ffmpegSource) {
    Copy-Item $ffmpegSource "ffmpeg.exe" -Force
    Write-Host "✓ ffmpeg.exe copiado!" -ForegroundColor Green
} else {
    Write-Host "✗ ffmpeg.exe não encontrado em $ffmpegFound" -ForegroundColor Red
}

# Copia ffprobe.exe se existir
$ffprobeSource = Join-Path $ffmpegFound "ffprobe.exe"
if (Test-Path $ffprobeSource) {
    Copy-Item $ffprobeSource "ffprobe.exe" -Force
    Write-Host "✓ ffprobe.exe copiado!" -ForegroundColor Green
}

Write-Host ""
Write-Host "✓ FFmpeg copiado com sucesso para a pasta do projeto!" -ForegroundColor Green
Write-Host "Agora você pode usar o sistema normalmente." -ForegroundColor Yellow
Write-Host ""
Read-Host "Pressione Enter para sair"
