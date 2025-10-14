@echo off
title Copiador FFmpeg - Bijari 3 Outputs
echo ========================================
echo   COPIADOR FFMPEG PARA PASTA DO PROJETO
echo ========================================
echo.
echo Este script vai encontrar e copiar o FFmpeg para esta pasta!
echo.

if exist "ffmpeg.exe" (
    echo ✓ FFmpeg ja esta na pasta do projeto!
    echo Nao precisa copiar novamente.
    echo.
    pause
    exit /b 0
)

echo Procurando FFmpeg instalado pelo Chocolatey...

:: Caminhos possíveis onde o Chocolatey instala o FFmpeg
set "FFMPEG_FOUND="

:: Verifica caminhos comuns do Chocolatey
if exist "C:\ProgramData\chocolatey\lib\ffmpeg\tools\ffmpeg\bin\ffmpeg.exe" (
    set "FFMPEG_PATH=C:\ProgramData\chocolatey\lib\ffmpeg\tools\ffmpeg\bin"
    set "FFMPEG_FOUND=1"
    echo ✓ FFmpeg encontrado em: %FFMPEG_PATH%
)

if exist "C:\tools\ffmpeg\bin\ffmpeg.exe" (
    set "FFMPEG_PATH=C:\tools\ffmpeg\bin"
    set "FFMPEG_FOUND=1"
    echo ✓ FFmpeg encontrado em: %FFMPEG_PATH%
)

if exist "C:\Program Files\ffmpeg\bin\ffmpeg.exe" (
    set "FFMPEG_PATH=C:\Program Files\ffmpeg\bin"
    set "FFMPEG_FOUND=1"
    echo ✓ FFmpeg encontrado em: %FFMPEG_PATH%
)

if exist "C:\ffmpeg\bin\ffmpeg.exe" (
    set "FFMPEG_PATH=C:\ffmpeg\bin"
    set "FFMPEG_FOUND=1"
    echo ✓ FFmpeg encontrado em: %FFMPEG_PATH%
)

:: Se não encontrou nos caminhos fixos, tenta usar o comando where
if not defined FFMPEG_FOUND (
    echo Procurando FFmpeg no PATH do sistema...
    where ffmpeg >nul 2>&1
    if not errorlevel 1 (
        for /f "tokens=*" %%i in ('where ffmpeg') do (
            set "FFMPEG_FULL_PATH=%%i"
            goto :found_in_path
        )
    )
)

:found_in_path
if defined FFMPEG_FULL_PATH (
    echo ✓ FFmpeg encontrado no PATH: %FFMPEG_FULL_PATH%
    set "FFMPEG_FOUND=1"
)

if not defined FFMPEG_FOUND (
    echo ✗ FFmpeg nao encontrado!
    echo.
    echo SOLUCOES:
    echo 1. Execute: choco install ffmpeg -y
    echo 2. Reinicie o terminal
    echo 3. Execute este script novamente
    echo.
    pause
    exit /b 1
)

echo.
echo Copiando FFmpeg para a pasta do projeto...

if defined FFMPEG_PATH (
    :: Copia da pasta encontrada
    copy "%FFMPEG_PATH%\ffmpeg.exe" "." >nul 2>&1
    if exist "%FFMPEG_PATH%\ffprobe.exe" (
        copy "%FFMPEG_PATH%\ffprobe.exe" "." >nul 2>&1
        echo ✓ ffprobe.exe copiado!
    )
    echo ✓ ffmpeg.exe copiado de %FFMPEG_PATH%!
) else if defined FFMPEG_FULL_PATH (
    :: Copia do arquivo encontrado no PATH
    copy "%FFMPEG_FULL_PATH%" "ffmpeg.exe" >nul 2>&1
    echo ✓ ffmpeg.exe copiado de %FFMPEG_FULL_PATH%!
    
    :: Tenta copiar ffprobe também
    for /f "tokens=*" %%i in ('where ffprobe 2^>nul') do (
        copy "%%i" "ffprobe.exe" >nul 2>&1
        echo ✓ ffprobe.exe copiado!
    )
)

echo.
echo ✓ FFmpeg copiado com sucesso para a pasta do projeto!
echo Agora voce pode usar o sistema normalmente.
echo.
pause
