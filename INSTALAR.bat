@echo off
title Bijari 3 Outputs - Instalacao Automatica
echo ========================================
echo   Bijari 3 Outputs - Instalacao
echo ========================================
echo.
echo Este script vai instalar tudo automaticamente!
echo.
echo Verificando arquivos necessarios...
if not exist "requirements.txt" (
    echo ERRO: Arquivo requirements.txt nao encontrado!
    echo.
    echo SOLUCAO:
    echo 1. Certifique-se de que voce esta na pasta correta do projeto
    echo 2. Verifique se todos os arquivos foram copiados corretamente
    echo 3. Execute este script novamente
    echo.
    pause
    exit /b 1
)
if not exist "video_sync.py" (
    echo ERRO: Arquivo video_sync.py nao encontrado!
    echo.
    echo SOLUCAO:
    echo 1. Certifique-se de que voce esta na pasta correta do projeto
    echo 2. Verifique se todos os arquivos foram copiados corretamente
    echo 3. Execute este script novamente
    echo.
    pause
    exit /b 1
)
echo ✓ Arquivos necessarios encontrados!
echo.
pause

echo [1/4] Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo.
    echo INSTRUCOES:
    echo 1. Baixe Python em: https://www.python.org/downloads/
    echo 2. Instale marcando "Add Python to PATH"
    echo 3. Execute este script novamente
    echo.
    pause
    exit /b 1
)
echo ✓ Python encontrado!

echo.
echo [2/4] Instalando dependencias...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERRO: Falha ao instalar as dependencias!
    echo.
    echo INSTRUCOES:
    echo 1. Verifique sua conexao com a internet
    echo 2. Execute este script novamente
    echo 3. Se o problema persistir, entre em contato com o suporte tecnico
    echo.
    pause
    exit /b 1
)
echo ✓ Dependencias instaladas!

echo.
echo [3/4] Verificando VLC...
if not exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    echo AVISO: VLC nao encontrado!
    echo.
    echo INSTRUCOES:
    echo 1. Baixe VLC em: https://www.videolan.org/vlc/
    echo 2. Instale no caminho padrao
    echo 3. Execute este script novamente
    echo.
    pause
    exit /b 1
)
echo ✓ VLC encontrado!

echo.
echo [3.5/4] Verificando FFmpeg...
ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo AVISO: FFmpeg nao encontrado!
    echo.
    echo INSTRUCOES:
    echo 1. Baixe FFmpeg em: https://ffmpeg.org/download.html
    echo 2. Extraia para C:\ffmpeg\
    echo 3. Adicione C:\ffmpeg\bin\ ao PATH do sistema
    echo 4. Ou coloque ffmpeg.exe na pasta do projeto
    echo.
    echo CONTINUANDO SEM FFmpeg...
    echo (O sistema tentara encontrar automaticamente)
    echo.
) else (
    echo ✓ FFmpeg encontrado!
)

echo.
echo [4/4] Verificando videos...
if not exist "Tela01.mp4" (
    echo ERRO: Tela01.mp4 nao encontrado!
    echo.
    echo INSTRUCOES:
    echo 1. Coloque os videos Tela01.mp4, Tela02.mp4, Tela03.mp4 nesta pasta
    echo 2. Execute este script novamente
    echo.
    pause
    exit /b 1
)
echo ✓ Videos encontrados!

echo.
echo ========================================
echo   INSTALACAO CONCLUIDA COM SUCESSO!
echo ========================================
echo.
echo Para usar o sistema:
echo 1. Para PRODUCAO: Execute "INICIAR_PRODUCAO.bat"
echo 2. Para DESENVOLVIMENTO: Execute "INICIAR_DESENVOLVIMENTO.bat"
echo.
pause
