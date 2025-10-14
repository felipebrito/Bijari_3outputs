@echo off
title Baixador FFmpeg Direto - Bijari 3 Outputs
echo ========================================
echo   BAIXADOR FFMPEG DIRETO
echo ========================================
echo.
echo Este script baixa o FFmpeg diretamente do GitHub!
echo.

if exist "ffmpeg.exe" (
    echo ✓ FFmpeg ja esta na pasta do projeto!
    echo Nao precisa baixar novamente.
    echo.
    pause
    exit /b 0
)

echo Baixando FFmpeg diretamente do GitHub...
echo (Isso pode demorar alguns minutos...)
echo.

powershell -ExecutionPolicy Bypass -Command "try { Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile 'ffmpeg.zip' -UseBasicParsing; Write-Host 'Download concluido!' } catch { Write-Host 'ERRO: Falha no download!' }"
if errorlevel 1 (
    echo ERRO: Falha ao baixar FFmpeg!
    echo.
    echo SOLUCAO MANUAL:
    echo 1. Baixe manualmente: https://github.com/BtbN/FFmpeg-Builds/releases
    echo 2. Extraia ffmpeg.exe para esta pasta
    echo.
    pause
    exit /b 1
)

echo Extraindo arquivos...
powershell -ExecutionPolicy Bypass -Command "try { Expand-Archive -Path 'ffmpeg.zip' -DestinationPath '.' -Force; Write-Host 'Extracao concluida!' } catch { Write-Host 'ERRO: Falha na extracao!' }"
if errorlevel 1 (
    echo ERRO: Falha ao extrair arquivos!
    pause
    exit /b 1
)

echo Movendo executaveis...
for /d %%i in (ffmpeg-master-latest-win64-gpl\*) do (
    if exist "%%i\bin\ffmpeg.exe" (
        copy "%%i\bin\ffmpeg.exe" "." >nul 2>&1
        echo ✓ ffmpeg.exe copiado!
    )
    if exist "%%i\bin\ffprobe.exe" (
        copy "%%i\bin\ffprobe.exe" "." >nul 2>&1
        echo ✓ ffprobe.exe copiado!
    )
)

echo Limpando arquivos temporarios...
del "ffmpeg.zip" >nul 2>&1
rmdir /s /q "ffmpeg-master-latest-win64-gpl" >nul 2>&1

echo.
echo ✓ FFmpeg baixado e instalado na pasta do projeto!
echo Agora voce pode usar o sistema normalmente.
echo.
pause
