@echo off
title Verificador de Videos - Bijari 3 Outputs
echo ========================================
echo   VERIFICADOR DE VIDEOS
echo ========================================
echo.

echo Verificando se os videos existem...
echo.

if exist "Tela01.mp4" (
    echo ✓ Tela01.mp4 encontrado
) else (
    echo ✗ Tela01.mp4 NAO encontrado!
)

if exist "Tela02.mp4" (
    echo ✓ Tela02.mp4 encontrado
) else (
    echo ✗ Tela02.mp4 NAO encontrado!
)

if exist "Tela03.mp4" (
    echo ✓ Tela03.mp4 encontrado
) else (
    echo ✗ Tela03.mp4 NAO encontrado!
)

echo.
echo Verificando FFmpeg...
if exist "ffmpeg.exe" (
    echo ✓ ffmpeg.exe encontrado
    echo Testando FFmpeg...
    ffmpeg.exe -version | findstr "ffmpeg version"
) else (
    echo ✗ ffmpeg.exe NAO encontrado!
    echo Execute INSTALAR.bat e escolha opcao 1
)

echo.
echo Verificando VLC...
if exist "C:\Program Files\VideoLAN\VLC\vlc.exe" (
    echo ✓ VLC encontrado
) else (
    echo ✗ VLC NAO encontrado!
    echo Baixe em: https://www.videolan.org/vlc/
)

echo.
pause
