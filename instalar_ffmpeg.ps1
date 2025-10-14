# Instalador FFmpeg via PowerShell
# Execute como Administrador

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALADOR FFMPEG VIA POWERSHELL" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se está executando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERRO: Execute como Administrador!" -ForegroundColor Red
    Write-Host "Clique com botão direito no PowerShell e escolha 'Executar como administrador'" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Verificando Chocolatey..." -ForegroundColor Yellow
try {
    $chocoVersion = choco --version
    Write-Host "✓ Chocolatey encontrado: $chocoVersion" -ForegroundColor Green
} catch {
    Write-Host "Chocolatey não encontrado. Instalando..." -ForegroundColor Yellow
    
    # Instalar Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Atualizar PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
    
    Write-Host "✓ Chocolatey instalado!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Instalando FFmpeg..." -ForegroundColor Yellow
try {
    choco install ffmpeg -y
    Write-Host "✓ FFmpeg instalado com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Falha ao instalar FFmpeg via Chocolatey" -ForegroundColor Red
    Write-Host "Tentando download direto..." -ForegroundColor Yellow
    
    # Download direto
    $downloadUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
    $zipFile = "ffmpeg.zip"
    $extractPath = "C:\ffmpeg"
    
    Write-Host "Baixando FFmpeg..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile -UseBasicParsing
    
    Write-Host "Extraindo para $extractPath..." -ForegroundColor Yellow
    if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }
    Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force
    
    # Mover executáveis
    $binPath = "$extractPath\bin"
    if (Test-Path $binPath) {
        New-Item -ItemType Directory -Path $binPath -Force | Out-Null
        Get-ChildItem -Path "$extractPath\ffmpeg-master-latest-win64-gpl\*\bin\*.exe" | ForEach-Object {
            Copy-Item $_.FullName -Destination $binPath
        }
    }
    
    # Adicionar ao PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
    if ($currentPath -notlike "*$binPath*") {
        [Environment]::SetEnvironmentVariable("PATH", "$currentPath;$binPath", "Machine")
        $env:PATH += ";$binPath"
    }
    
    # Limpar
    Remove-Item $zipFile -Force
    Remove-Item "$extractPath\ffmpeg-master-latest-win64-gpl" -Recurse -Force
    
    Write-Host "✓ FFmpeg instalado em $binPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "Verificando instalação..." -ForegroundColor Yellow
try {
    $ffmpegVersion = ffmpeg -version 2>$null | Select-String "ffmpeg version"
    Write-Host "✓ FFmpeg funcionando: $ffmpegVersion" -ForegroundColor Green
} catch {
    Write-Host "AVISO: FFmpeg instalado mas pode precisar reiniciar o terminal" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Pressione Enter para sair"
