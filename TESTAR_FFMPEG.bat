@echo off
title Teste FFmpeg - Bijari 3 Outputs
echo ========================================
echo   TESTE DO FFMPEG
echo ========================================
echo.

if not exist "ffmpeg.exe" (
    echo ✗ ffmpeg.exe nao encontrado!
    echo Execute INSTALAR.bat e escolha opcao 1
    pause
    exit /b 1
)

echo Testando FFmpeg...
echo.

echo [1] Verificando versao do FFmpeg:
ffmpeg.exe -version
echo.

echo [2] Testando comando de combinacao (sem executar):
echo Comando que sera executado:
echo ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v]transpose=1,scale=1920:1080[v0];[1:v]transpose=1,scale=1920:1080[v1];[2:v]transpose=1,scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset fast -crf 23 -y combined_video.mp4
echo.

echo [3] Verificando se os videos de entrada existem:
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
echo [4] Testando FFmpeg com um video individual:
if exist "Tela01.mp4" (
    echo Testando com Tela01.mp4...
    ffmpeg.exe -i Tela01.mp4 -t 5 -f null - 2>&1 | findstr "error\|Error\|ERROR"
    if errorlevel 1 (
        echo ✓ Tela01.mp4 e valido
    ) else (
        echo ✗ Tela01.mp4 tem problemas
    )
) else (
    echo ✗ Nao foi possivel testar - Tela01.mp4 nao encontrado
)

echo.
pause
