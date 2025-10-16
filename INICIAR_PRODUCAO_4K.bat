@echo off
title Bijari 4K - Producao
echo ========================================
echo   Bijari 4K - Matriz 2x2 - PRODUCAO
echo ========================================
echo.
echo Layout: [Tela01] [Tela02]
echo         [Tela03] [Tela03]
echo Resolucao: 3840x2560 (4K)
echo.
echo Iniciando sistema de producao 4K...
echo.

REM Verifica se o Python esta instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo Execute INSTALAR_4K.bat primeiro.
    pause
    exit /b 1
)

REM Verifica se os arquivos necessarios existem
if not exist "video_sync_4k.py" (
    echo ERRO: video_sync_4k.py nao encontrado!
    echo Execute INSTALAR_4K.bat primeiro.
    pause
    exit /b 1
)

if not exist "config_4k.py" (
    echo ERRO: config_4k.py nao encontrado!
    echo Execute INSTALAR_4K.bat primeiro.
    pause
    exit /b 1
)

REM Verifica se os videos existem
if not exist "Tela01.mp4" (
    echo ERRO: Tela01.mp4 nao encontrado!
    echo Coloque os videos Tela01.mp4, Tela02.mp4, Tela03.mp4 nesta pasta.
    pause
    exit /b 1
)

if not exist "Tela02.mp4" (
    echo ERRO: Tela02.mp4 nao encontrado!
    echo Coloque os videos Tela01.mp4, Tela02.mp4, Tela03.mp4 nesta pasta.
    pause
    exit /b 1
)

if not exist "Tela03.mp4" (
    echo ERRO: Tela03.mp4 nao encontrado!
    echo Coloque os videos Tela01.mp4, Tela02.mp4, Tela03.mp4 nesta pasta.
    pause
    exit /b 1
)

echo ✓ Todos os arquivos encontrados!
echo.
echo Iniciando sistema 4K...
echo.
echo CONTROLES:
echo - CTRL+Q: Sair do sistema
echo - O VLC sera mantido sempre em foco automaticamente
echo.

REM Executa o sistema 4K
python video_sync_4k.py

echo.
echo Sistema 4K finalizado.
pause
