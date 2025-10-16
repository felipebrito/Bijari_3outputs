@echo off
title Corrigir Problema do psutil - Versao 4K
echo ========================================
echo   Corrigir Problema do psutil - 4K
echo ========================================
echo.
echo Este script vai tentar corrigir o problema do psutil
echo que precisa de compilacao no Windows para a versao 4K.
echo.

echo [1/3] Tentando instalar psutil com pre-compiled wheel...
pip install --only-binary=all psutil
if errorlevel 1 (
    echo.
    echo [2/3] Tentando instalar versao mais recente...
    pip install --upgrade psutil
    if errorlevel 1 (
        echo.
        echo [3/3] Tentando instalar sem dependencias de compilacao...
        pip install --no-deps psutil
        if errorlevel 1 (
            echo.
            echo ERRO: Nao foi possivel instalar psutil automaticamente!
            echo.
            echo SOLUCOES MANUAIS:
            echo.
            echo OPCAO 1 - Microsoft C++ Build Tools:
            echo 1. Baixe: https://visualstudio.microsoft.com/visual-cpp-build-tools/
            echo 2. Instale marcando "C++ build tools"
            echo 3. Execute: pip install psutil
            echo.
            echo OPCAO 2 - Anaconda/Miniconda:
            echo 1. Baixe: https://www.anaconda.com/products/distribution
            echo 2. Instale Anaconda
            echo 3. Execute: conda install psutil
            echo.
            echo OPCAO 3 - Usar versao mais antiga:
            echo 1. Execute: pip install psutil==5.8.0
            echo.
            pause
            exit /b 1
        )
    )
)

echo.
echo ✓ psutil instalado com sucesso!
echo.
echo Agora instalando outras dependencias...
pip install keyboard pywin32
if errorlevel 1 (
    echo ERRO: Falha ao instalar outras dependencias!
    pause
    exit /b 1
)

echo.
echo ✓ Todas as dependencias instaladas com sucesso!
echo.
echo Agora voce pode executar o sistema 4K normalmente.
echo Execute "INICIAR_PRODUCAO_4K.bat" para usar o sistema 4K.
echo.
pause
