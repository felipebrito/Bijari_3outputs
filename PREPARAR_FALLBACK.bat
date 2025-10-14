@echo off
title Preparar Video de Fallback - Bijari 3 Outputs
echo ========================================
echo   PREPARAR VIDEO DE FALLBACK
echo ========================================
echo.

if not exist "combined_video.mp4" (
    echo ✗ combined_video.mp4 nao encontrado!
    echo.
    echo Este script precisa do arquivo combined_video.mp4
    echo para criar o video de fallback.
    pause
    exit /b 1
)

echo Copiando combined_video.mp4 como video de fallback...
copy "combined_video.mp4" "combined_video_fallback.mp4" >nul

if exist "combined_video_fallback.mp4" (
    echo ✓ Video de fallback criado com sucesso!
    echo.
    echo Arquivo: combined_video_fallback.mp4
    echo Tamanho:
    dir "combined_video_fallback.mp4" | findstr "combined_video_fallback.mp4"
    echo.
    echo Este arquivo sera usado como fallback caso o FFmpeg
    echo nao consiga combinar os videos na maquina de destino.
    echo.
    echo PRÓXIMOS PASSOS:
    echo 1. Faça commit deste arquivo no Git
    echo 2. Na maquina de destino, o sistema usara este video
    echo    se nao conseguir combinar os videos localmente
) else (
    echo ✗ ERRO: Falha ao criar video de fallback!
)

echo.
pause
