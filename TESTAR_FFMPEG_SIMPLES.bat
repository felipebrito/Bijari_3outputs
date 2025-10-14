@echo off
title Teste FFmpeg Simples - Bijari 3 Outputs
echo ========================================
echo   TESTE FFMPEG SIMPLES
echo ========================================
echo.

if not exist "ffmpeg.exe" (
    echo ✗ ffmpeg.exe nao encontrado!
    pause
    exit /b 1
)

if not exist "Tela01.mp4" (
    echo ✗ Tela01.mp4 nao encontrado!
    pause
    exit /b 1
)

echo Testando FFmpeg com abordagem mais simples...
echo.

echo [TESTE] Comando simplificado (sem rotacao):
echo ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex hstack=inputs=3 -c:v libx264 -preset ultrafast -y combined_video.mp4
echo.

ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex hstack=inputs=3 -c:v libx264 -preset ultrafast -y combined_video.mp4

if errorlevel 1 (
    echo ✗ TESTE FALHOU
    echo.
    echo Tentando comando ainda mais simples...
    echo ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex hstack=inputs=3 -y combined_video.mp4
    echo.
    ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex hstack=inputs=3 -y combined_video.mp4
    if errorlevel 1 (
        echo ✗ TODOS OS TESTES FALHARAM
        echo Possivel problema com os videos ou FFmpeg
    ) else (
        echo ✓ TESTE SIMPLES FUNCIONOU!
    )
) else (
    echo ✓ TESTE FUNCIONOU!
)

echo.
if exist "combined_video.mp4" (
    echo ✓ Arquivo combined_video.mp4 criado!
    echo Tamanho: 
    dir combined_video.mp4 | findstr "combined_video.mp4"
) else (
    echo ✗ Arquivo combined_video.mp4 NAO foi criado
)

echo.
pause
