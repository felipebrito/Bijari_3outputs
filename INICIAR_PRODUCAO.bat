@echo off
title Bijari 3 Outputs - Modo Producao
echo ========================================
echo   Bijari 3 Outputs - MODO PRODUCAO
echo ========================================
echo.
echo Sistema de producao com reinicializacao automatica
echo Pressione Ctrl+C para sair
echo.

python video_sync.py
if errorlevel 1 (
    echo.
    echo ERRO: Falha ao executar video_sync.py
    echo.
    echo SOLUCOES:
    echo 1. Verifique se Python esta instalado
    echo 2. Execute INSTALAR.bat primeiro
    echo 3. Verifique se os videos existem
    echo 4. Execute CONFIGURAR.bat para diagnosticar
    echo.
) else (
    echo.
    echo Sistema executado com sucesso!
    echo.
)

pause
