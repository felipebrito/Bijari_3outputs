@echo off
title Teste FFmpeg Avancado - Bijari 3 Outputs
echo ========================================
echo   TESTE FFMPEG AVANCADO
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

echo Testando diferentes abordagens do FFmpeg...
echo.

echo [TESTE 1] Comando original (com rotacao):
echo ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v]transpose=1,scale=1920:1080[v0];[1:v]transpose=1,scale=1920:1080[v1];[2:v]transpose=1,scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset fast -crf 23 -y combined_video.mp4
echo.
ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v]transpose=1,scale=1920:1080[v0];[1:v]transpose=1,scale=1920:1080[v1];[2:v]transpose=1,scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset fast -crf 23 -y combined_video.mp4
if errorlevel 1 (
    echo ✗ TESTE 1 FALHOU
    echo.
    echo [TESTE 2] Sem rotacao (mais simples):
    echo ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v]scale=1920:1080[v0];[1:v]scale=1920:1080[v1];[2:v]scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset ultrafast -crf 28 -y combined_video.mp4
    echo.
    ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v]scale=1920:1080[v0];[1:v]scale=1920:1080[v1];[2:v]scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset ultrafast -crf 28 -y combined_video.mp4
    if errorlevel 1 (
        echo ✗ TESTE 2 FALHOU
        echo.
        echo [TESTE 3] Comando mais simples ainda:
        echo ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset ultrafast -y combined_video.mp4
        echo.
        ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex "[0:v][1:v][2:v]hstack=inputs=3[v]" -map "[v]" -c:v libx264 -preset ultrafast -y combined_video.mp4
        if errorlevel 1 (
            echo ✗ TODOS OS TESTES FALHARAM
            echo.
            echo Possivel problema com os videos ou FFmpeg
        ) else (
            echo ✓ TESTE 3 FUNCIONOU!
        )
    ) else (
        echo ✓ TESTE 2 FUNCIONOU!
    )
) else (
    echo ✓ TESTE 1 FUNCIONOU!
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
