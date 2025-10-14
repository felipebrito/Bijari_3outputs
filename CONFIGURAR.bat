@echo off
title Bijari 3 Outputs - Configuracao
echo ========================================
echo   Bijari 3 Outputs - Configuracao
echo ========================================
echo.
echo Este script permite configurar o sistema
echo.

:menu
echo.
echo Escolha uma opcao:
echo.
echo 1. Verificar instalacao
echo 2. Testar videos
echo 3. Configurar monitores
echo 4. Sair
echo.
set /p choice="Digite sua opcao (1-4): "

if "%choice%"=="1" goto verificar
if "%choice%"=="2" goto testar
if "%choice%"=="3" goto configurar
if "%choice%"=="4" goto sair
echo Opcao invalida!
goto menu

:verificar
echo.
echo [VERIFICANDO INSTALACAO...]
echo.

echo Verificando Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Python nao encontrado
) else (
    echo ✓ Python encontrado
)

echo.
echo Verificando VLC...
if not exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    echo ✗ VLC nao encontrado
) else (
    echo ✓ VLC encontrado
)

echo.
echo Verificando videos...
if not exist "Tela01.mp4" (
    echo ✗ Tela01.mp4 nao encontrado
) else (
    echo ✓ Tela01.mp4 encontrado
)

if not exist "Tela02.mp4" (
    echo ✗ Tela02.mp4 nao encontrado
) else (
    echo ✓ Tela02.mp4 encontrado
)

if not exist "Tela03.mp4" (
    echo ✗ Tela03.mp4 nao encontrado
) else (
    echo ✓ Tela03.mp4 encontrado
)

echo.
echo Verificacao concluida!
pause
goto menu

:testar
echo.
echo [TESTANDO VIDEOS...]
echo.
echo Iniciando teste de 10 segundos...
echo Pressione Ctrl+Q para sair antes
echo.

cd development
python video_sync.py
cd ..

echo.
echo Teste concluido!
pause
goto menu

:configurar
echo.
echo [CONFIGURACAO DE MONITORES]
echo.
echo O sistema foi configurado para:
echo - 3 monitores de 1920x1080
echo - Disposicao horizontal (lado a lado)
echo - Total: 5760x1080
echo.
echo Se seus monitores sao diferentes, entre em contato com o suporte tecnico.
echo.
pause
goto menu

:sair
echo.
echo Saindo...
exit /b 0
