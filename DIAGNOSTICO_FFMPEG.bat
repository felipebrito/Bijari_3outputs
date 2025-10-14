@echo off
title Diagnostico FFmpeg - Bijari 3 Outputs
echo ========================================
echo   DIAGNOSTICO FFMPEG
echo ========================================
echo.

if not exist "ffmpeg.exe" (
    echo ✗ ffmpeg.exe nao encontrado!
    pause
    exit /b 1
)

echo [1] Testando FFmpeg com arquivo de saida diferente...
echo.
ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex hstack=inputs=3 -c:v libx264 -preset ultrafast -y teste_output.mp4

if errorlevel 1 (
    echo ✗ Falha com teste_output.mp4
) else (
    echo ✓ Sucesso com teste_output.mp4
    if exist "teste_output.mp4" (
        echo ✓ Arquivo teste_output.mp4 criado!
        dir teste_output.mp4 | findstr "teste_output.mp4"
    ) else (
        echo ✗ Arquivo teste_output.mp4 NAO foi criado
    )
)

echo.
echo [2] Testando com apenas 2 videos...
echo.
ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -filter_complex hstack=inputs=2 -c:v libx264 -preset ultrafast -y teste_2videos.mp4

if errorlevel 1 (
    echo ✗ Falha com 2 videos
) else (
    echo ✓ Sucesso com 2 videos
    if exist "teste_2videos.mp4" (
        echo ✓ Arquivo teste_2videos.mp4 criado!
        dir teste_2videos.mp4 | findstr "teste_2videos.mp4"
    ) else (
        echo ✗ Arquivo teste_2videos.mp4 NAO foi criado
    )
)

echo.
echo [3] Testando com apenas 1 video (copiando)...
echo.
ffmpeg.exe -i Tela01.mp4 -c copy -y teste_copia.mp4

if errorlevel 1 (
    echo ✗ Falha ao copiar video
) else (
    echo ✓ Sucesso ao copiar video
    if exist "teste_copia.mp4" (
        echo ✓ Arquivo teste_copia.mp4 criado!
        dir teste_copia.mp4 | findstr "teste_copia.mp4"
    ) else (
        echo ✗ Arquivo teste_copia.mp4 NAO foi criado
    )
)

echo.
echo [4] Verificando permissoes da pasta...
echo.
echo Pasta atual: %CD%
echo Permissoes:
dir . | findstr "combined_video.mp4"
dir . | findstr "teste_"

echo.
echo [5] Testando com caminho absoluto...
echo.
set "output_path=%CD%\combined_video_abs.mp4"
echo Caminho absoluto: %output_path%
ffmpeg.exe -i Tela01.mp4 -i Tela02.mp4 -i Tela03.mp4 -filter_complex hstack=inputs=3 -c:v libx264 -preset ultrafast -y "%output_path%"

if errorlevel 1 (
    echo ✗ Falha com caminho absoluto
) else (
    echo ✓ Sucesso com caminho absoluto
    if exist "%output_path%" (
        echo ✓ Arquivo criado com caminho absoluto!
        dir "%output_path%" | findstr "combined_video_abs.mp4"
    ) else (
        echo ✗ Arquivo NAO foi criado com caminho absoluto
    )
)

echo.
echo [6] Limpando arquivos de teste...
del teste_output.mp4 >nul 2>&1
del teste_2videos.mp4 >nul 2>&1
del teste_copia.mp4 >nul 2>&1
del combined_video_abs.mp4 >nul 2>&1
echo Arquivos de teste removidos.

echo.
pause
