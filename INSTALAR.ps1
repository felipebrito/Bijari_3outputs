# Bijari 3 Outputs - Instalacao PowerShell
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Bijari 3 Outputs - Instalacao" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se estamos na pasta correta
if (-not (Test-Path "requirements.txt")) {
    Write-Host "ERRO: Arquivo requirements.txt nao encontrado!" -ForegroundColor Red
    Write-Host "Certifique-se de que voce esta na pasta correta do projeto" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

if (-not (Test-Path "video_sync.py")) {
    Write-Host "ERRO: Arquivo video_sync.py nao encontrado!" -ForegroundColor Red
    Write-Host "Certifique-se de que voce esta na pasta correta do projeto" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "✓ Arquivos necessarios encontrados!" -ForegroundColor Green
Write-Host ""

# Verificar Python
Write-Host "[1/4] Verificando Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python encontrado: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Python nao encontrado!" -ForegroundColor Red
    Write-Host "Baixe Python em: https://www.python.org/downloads/" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""

# Instalar dependencias
Write-Host "[2/4] Instalando dependencias..." -ForegroundColor Yellow

# Primeiro, tenta instalar psutil com pre-compiled wheel
Write-Host "Instalando psutil..." -ForegroundColor Cyan
try {
    pip install --only-binary=all psutil
    Write-Host "✓ psutil instalado com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "Tentando instalar versao mais recente do psutil..." -ForegroundColor Yellow
    try {
        pip install --upgrade psutil
        Write-Host "✓ psutil instalado com sucesso!" -ForegroundColor Green
    } catch {
        Write-Host "ERRO: Nao foi possivel instalar psutil!" -ForegroundColor Red
        Write-Host "SOLUCOES ALTERNATIVAS:" -ForegroundColor Yellow
        Write-Host "1. Instale Microsoft C++ Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/" -ForegroundColor White
        Write-Host "2. Use Anaconda/Miniconda: https://www.anaconda.com/products/distribution" -ForegroundColor White
        Write-Host "3. Execute: conda install psutil" -ForegroundColor White
        Read-Host "Pressione Enter para sair"
        exit 1
    }
}

# Instalar outras dependencias
Write-Host "Instalando outras dependencias..." -ForegroundColor Cyan
try {
    pip install keyboard pywin32
    Write-Host "✓ Dependencias instaladas com sucesso!" -ForegroundColor Green
} catch {
    Write-Host "ERRO: Falha ao instalar outras dependencias!" -ForegroundColor Red
    Write-Host "Verifique sua conexao com a internet e tente novamente" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""

# Verificar VLC
Write-Host "[3/4] Verificando VLC..." -ForegroundColor Yellow
if (Test-Path "C:\Program Files\VideoLAN\VLC\vlc.exe") {
    Write-Host "✓ VLC encontrado!" -ForegroundColor Green
} else {
    Write-Host "AVISO: VLC nao encontrado!" -ForegroundColor Yellow
    Write-Host "Baixe VLC em: https://www.videolan.org/vlc/" -ForegroundColor White
    Write-Host "Instale no caminho padrao e execute este script novamente" -ForegroundColor White
    Read-Host "Pressione Enter para continuar"
}

Write-Host ""

# Verificar FFmpeg
Write-Host "[3.5/4] Verificando FFmpeg..." -ForegroundColor Yellow
if (Test-Path "ffmpeg.exe") {
    Write-Host "✓ FFmpeg encontrado na pasta do projeto!" -ForegroundColor Green
} else {
    try {
        ffmpeg -version | Out-Null
        Write-Host "✓ FFmpeg encontrado no sistema!" -ForegroundColor Green
    } catch {
        Write-Host "AVISO: FFmpeg nao encontrado!" -ForegroundColor Yellow
        Write-Host "OPCOES:" -ForegroundColor White
        Write-Host "1. Instalar via Chocolatey: choco install ffmpeg -y" -ForegroundColor White
        Write-Host "2. Baixar manualmente: https://ffmpeg.org/download.html" -ForegroundColor White
        Write-Host "3. Continuar sem FFmpeg (sera baixado automaticamente quando necessario)" -ForegroundColor White
        $ffmpegChoice = Read-Host "Digite sua opcao (1-3)"
        
        if ($ffmpegChoice -eq "1") {
            try {
                choco install ffmpeg -y
                Write-Host "✓ FFmpeg instalado via Chocolatey!" -ForegroundColor Green
            } catch {
                Write-Host "ERRO: Falha ao instalar FFmpeg via Chocolatey" -ForegroundColor Red
                Write-Host "Tente instalar manualmente" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host ""

# Verificar videos
Write-Host "[4/4] Verificando videos..." -ForegroundColor Yellow
if (Test-Path "Tela01.mp4") {
    Write-Host "✓ Videos encontrados!" -ForegroundColor Green
} else {
    Write-Host "ERRO: Tela01.mp4 nao encontrado!" -ForegroundColor Red
    Write-Host "Coloque os videos Tela01.mp4, Tela02.mp4, Tela03.mp4 nesta pasta" -ForegroundColor Yellow
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  INSTALACAO CONCLUIDA COM SUCESSO!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Para usar o sistema:" -ForegroundColor White
Write-Host "1. Para PRODUCAO: Execute 'INICIAR_PRODUCAO.bat'" -ForegroundColor Cyan
Write-Host "2. Para DESENVOLVIMENTO: Execute 'INICIAR_DESENVOLVIMENTO.bat'" -ForegroundColor Cyan
Write-Host ""
Read-Host "Pressione Enter para sair"
