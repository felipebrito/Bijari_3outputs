@echo off
title Bijari 3 Outputs - Kiosk Mode
echo ========================================
echo   Bijari 3 Outputs - Kiosk Mode
echo ========================================
echo.
echo Iniciando sistema de producao...
echo Pressione Ctrl+C para sair
echo.

REM Verifica se Python está instalado
python --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Python nao encontrado!
    echo Instale o Python 3.8+ e tente novamente
    pause
    exit /b 1
)

REM Instala dependências se necessário
echo Verificando dependencias...
pip install psutil >nul 2>&1

REM Inicia o kiosk mode
echo Iniciando modo kiosk...
python kiosk_launcher.py

pause
