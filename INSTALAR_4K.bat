@echo off
title Bijari 4K - Instalacao Automatica
echo ========================================
echo   Bijari 4K - Matriz 2x2 - Instalacao
echo ========================================
echo.
echo Este script vai instalar tudo automaticamente para a versao 4K!
echo Layout: [Tela01] [Tela02]
echo         [Tela03] [Tela03]
echo Resolucao: 3840x2560 (4K)
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
if not exist "video_sync_4k.py" (
    echo ERRO: Arquivo video_sync_4k.py nao encontrado!
    echo.
    echo SOLUCAO:
    echo 1. Certifique-se de que voce esta na pasta correta do projeto
    echo 2. Verifique se todos os arquivos foram copiados corretamente
    echo 3. Execute este script novamente
    echo.
    pause
    exit /b 1
)
if not exist "config_4k.py" (
    echo ERRO: Arquivo config_4k.py nao encontrado!
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
echo Tentando instalar com pre-compiled wheels...

REM Primeiro, tenta instalar psutil especificamente com pre-compiled wheel
echo Instalando psutil...
pip install --only-binary=all psutil
if errorlevel 1 (
    echo Tentando instalar versao mais recente do psutil...
    pip install --upgrade psutil
    if errorlevel 1 (
        echo Tentando instalar sem dependencias de compilacao...
        pip install --no-deps psutil
        if errorlevel 1 (
            echo ERRO: Nao foi possivel instalar psutil!
            echo.
            echo SOLUCOES ALTERNATIVAS:
            echo 1. Instale Microsoft C++ Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/
            echo 2. Use Anaconda/Miniconda: https://www.anaconda.com/products/distribution
            echo 3. Execute: conda install psutil
            echo.
            pause
            exit /b 1
        )
    )
)

REM Agora instala as outras dependencias
echo Instalando outras dependencias...
pip install keyboard pywin32
if errorlevel 1 (
    echo ERRO: Falha ao instalar outras dependencias!
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
if exist "ffmpeg.exe" (
    echo ✓ FFmpeg encontrado na pasta do projeto!
) else (
    ffmpeg -version >nul 2>&1
    if errorlevel 1 (
        echo AVISO: FFmpeg nao encontrado!
        echo.
        echo OPCOES:
        echo 1. Instalar automaticamente (recomendado)
        echo 2. Continuar sem FFmpeg
        echo 3. Instrucoes manuais
        echo.
        set /p ffmpeg_choice="Digite sua opcao (1-3): "
        
        if "%ffmpeg_choice%"=="1" (
            echo.
            echo Baixando FFmpeg diretamente...
            if exist "BAIXAR_FFMPEG_DIRETO.bat" (
                call BAIXAR_FFMPEG_DIRETO.bat
            ) else if exist "COPIAR_FFMPEG.bat" (
                call COPIAR_FFMPEG.bat
            ) else (
                echo ERRO: Scripts de FFmpeg nao encontrados!
                echo FFmpeg sera baixado automaticamente quando necessario.
            )
        ) else if "%ffmpeg_choice%"=="3" (
            echo.
            echo INSTRUCOES MANUAIS:
            echo 1. Baixe FFmpeg em: https://ffmpeg.org/download.html
            echo 2. Extraia para C:\ffmpeg\
            echo 3. Adicione C:\ffmpeg\bin\ ao PATH do sistema
            echo 4. Ou coloque ffmpeg.exe na pasta do projeto
            echo 5. Ou execute: choco install ffmpeg -y
            echo.
            pause
        ) else (
            echo CONTINUANDO SEM FFmpeg...
            echo (O sistema tentara encontrar automaticamente)
        )
        echo.
    ) else (
        echo ✓ FFmpeg encontrado no sistema!
    )
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
if not exist "Tela02.mp4" (
    echo ERRO: Tela02.mp4 nao encontrado!
    echo.
    echo INSTRUCOES:
    echo 1. Coloque os videos Tela01.mp4, Tela02.mp4, Tela03.mp4 nesta pasta
    echo 2. Execute este script novamente
    echo.
    pause
    exit /b 1
)
if not exist "Tela03.mp4" (
    echo ERRO: Tela03.mp4 nao encontrado!
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
echo   INSTALACAO 4K CONCLUIDA COM SUCESSO!
echo ========================================
echo.
echo Layout da matriz 2x2:
echo [Tela01] [Tela02]
echo [Tela03] [Tela03]
echo.
echo Resolucao final: 3840x2560 (4K)
echo.
echo Para usar o sistema:
echo 1. Para PRODUCAO 4K: Execute "INICIAR_PRODUCAO_4K.bat"
echo 2. Para DESENVOLVIMENTO 4K: Execute "INICIAR_DESENVOLVIMENTO_4K.bat"
echo.
pause
