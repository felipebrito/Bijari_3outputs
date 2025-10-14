@echo off
title Instalador FFmpeg - Bijari 3 Outputs
echo ========================================
echo   INSTALADOR FFMPEG AUTOMATICO
echo ========================================
echo.
echo Este script vai instalar o FFmpeg automaticamente!
echo.

:menu
echo Escolha o metodo de instalacao:
echo.
echo 1. Via Chocolatey (Recomendado - Mais facil)
echo 2. Download direto (Manual)
echo 3. Verificar se ja esta instalado
echo 4. Sair
echo.
set /p choice="Digite sua opcao (1-4): "

if "%choice%"=="1" goto chocolatey
if "%choice%"=="2" goto download
if "%choice%"=="3" goto verificar
if "%choice%"=="4" goto sair
echo Opcao invalida!
goto menu

:chocolatey
echo.
echo [INSTALANDO VIA CHOCOLATEY...]
echo.

echo Verificando se Chocolatey esta instalado...
where choco >nul 2>&1
if errorlevel 1 (
    echo Chocolatey nao encontrado! Instalando...
    echo.
    echo Abrindo PowerShell para instalar Chocolatey...
    echo (Siga as instrucoes na janela que abrir)
    echo.
    powershell -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')); pause"
    if errorlevel 1 (
        echo ERRO: Falha ao instalar Chocolatey!
        echo.
        echo SOLUCAO MANUAL:
        echo 1. Abra PowerShell como Administrador
        echo 2. Execute: Set-ExecutionPolicy Bypass -Scope Process -Force
        echo 3. Execute: iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        echo.
        pause
        goto menu
    )
    echo ✓ Chocolatey instalado!
) else (
    echo ✓ Chocolatey ja esta instalado!
)

echo.
echo Instalando FFmpeg via Chocolatey...
powershell -Command "choco install ffmpeg -y"
if errorlevel 1 (
    echo ERRO: Falha ao instalar FFmpeg via Chocolatey!
    echo.
    echo SOLUCAO MANUAL:
    echo 1. Abra PowerShell como Administrador
    echo 2. Execute: choco install ffmpeg -y
    echo.
    pause
    goto menu
) else (
    echo ✓ FFmpeg instalado com sucesso!
)

echo.
echo Verificando instalacao...
ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo AVISO: FFmpeg instalado mas nao encontrado no PATH atual
    echo Reinicie o terminal e tente novamente
) else (
    echo ✓ FFmpeg funcionando perfeitamente!
)
echo.
pause
goto menu

:download
echo.
echo [DOWNLOAD DIRETO DO FFMPEG...]
echo.

echo Criando pasta C:\ffmpeg...
if not exist "C:\ffmpeg" mkdir "C:\ffmpeg"
if not exist "C:\ffmpeg\bin" mkdir "C:\ffmpeg\bin"

echo.
echo Baixando FFmpeg...
echo (Isso pode demorar alguns minutos...)
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile 'C:\ffmpeg\ffmpeg.zip'"
if errorlevel 1 (
    echo ERRO: Falha ao baixar FFmpeg!
    echo.
    echo SOLUCAO MANUAL:
    echo 1. Baixe manualmente: https://github.com/BtbN/FFmpeg-Builds/releases
    echo 2. Extraia para C:\ffmpeg\
    echo 3. Adicione C:\ffmpeg\bin\ ao PATH
    echo.
    pause
    goto menu
)

echo Extraindo arquivos...
powershell -Command "Expand-Archive -Path 'C:\ffmpeg\ffmpeg.zip' -DestinationPath 'C:\ffmpeg\' -Force"
if errorlevel 1 (
    echo ERRO: Falha ao extrair arquivos!
    pause
    goto menu
)

echo Movendo executaveis...
for /d %%i in (C:\ffmpeg\ffmpeg-master-latest-win64-gpl\*) do (
    copy "%%i\bin\*.exe" "C:\ffmpeg\bin\" >nul 2>&1
)

echo Limpando arquivos temporarios...
del "C:\ffmpeg\ffmpeg.zip" >nul 2>&1
rmdir /s /q "C:\ffmpeg\ffmpeg-master-latest-win64-gpl" >nul 2>&1

echo.
echo Adicionando ao PATH do sistema...
powershell -Command "[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';C:\ffmpeg\bin', 'Machine')"
if errorlevel 1 (
    echo AVISO: Falha ao adicionar ao PATH automaticamente
    echo.
    echo SOLUCAO MANUAL:
    echo 1. Abra "Configuracoes do Sistema" - "Variaveis de Ambiente"
    echo 2. Adicione C:\ffmpeg\bin\ ao PATH do sistema
    echo 3. Reinicie o terminal
    echo.
) else (
    echo ✓ FFmpeg adicionado ao PATH!
)

echo.
echo ✓ FFmpeg instalado em C:\ffmpeg\bin\
echo Reinicie o terminal para usar o FFmpeg
echo.
pause
goto menu

:verificar
echo.
echo [VERIFICANDO INSTALACAO DO FFMPEG...]
echo.

ffmpeg -version >nul 2>&1
if errorlevel 1 (
    echo ✗ FFmpeg nao encontrado no PATH
    echo.
    echo Verificando instalacoes locais...
    if exist "C:\ffmpeg\bin\ffmpeg.exe" (
        echo ✓ FFmpeg encontrado em C:\ffmpeg\bin\ffmpeg.exe
        echo (Mas nao esta no PATH)
    ) else (
        echo ✗ FFmpeg nao encontrado em C:\ffmpeg\bin\
    )
    if exist "ffmpeg.exe" (
        echo ✓ ffmpeg.exe encontrado na pasta atual
    ) else (
        echo ✗ ffmpeg.exe nao encontrado na pasta atual
    )
) else (
    echo ✓ FFmpeg encontrado e funcionando!
    ffmpeg -version | findstr "ffmpeg version"
)
echo.
pause
goto menu

:sair
echo.
echo Saindo...
exit /b 0
