@echo off
title Instalador FFmpeg Simples - Bijari 3 Outputs
echo ========================================
echo   INSTALADOR FFMPEG SIMPLES
echo ========================================
echo.
echo Este script vai instalar o FFmpeg de forma simples!
echo.

:menu
echo Escolha o metodo de instalacao:
echo.
echo 1. Via Chocolatey (Recomendado)
echo 2. Download direto para pasta do projeto
echo 3. Verificar se ja esta instalado
echo 4. Sair
echo.
set /p choice="Digite sua opcao (1-4): "

if "%choice%"=="1" goto chocolatey
if "%choice%"=="2" goto download_simples
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
    echo Chocolatey nao encontrado!
    echo.
    echo INSTRUCOES MANUAIS:
    echo 1. Abra PowerShell como Administrador
    echo 2. Execute: Set-ExecutionPolicy Bypass -Scope Process -Force
    echo 3. Execute: iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    echo 4. Execute: choco install ffmpeg -y
    echo.
    echo Ou use a opcao 2 para download direto
    echo.
    pause
    goto menu
) else (
    echo ✓ Chocolatey encontrado!
    echo.
    echo Instalando FFmpeg...
    choco install ffmpeg -y
    if errorlevel 1 (
        echo ERRO: Falha ao instalar FFmpeg!
        echo Tente a opcao 2 (Download direto)
        pause
        goto menu
    ) else (
        echo ✓ FFmpeg instalado com sucesso!
    )
)
echo.
pause
goto menu

:download_simples
echo.
echo [DOWNLOAD DIRETO PARA PASTA DO PROJETO...]
echo.

echo Baixando FFmpeg para a pasta atual...
echo (Isso pode demorar alguns minutos...)
echo.

powershell -Command "try { Invoke-WebRequest -Uri 'https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip' -OutFile 'ffmpeg.zip' -UseBasicParsing; Write-Host 'Download concluido!' } catch { Write-Host 'ERRO: Falha no download!' }"
if errorlevel 1 (
    echo ERRO: Falha ao baixar FFmpeg!
    echo.
    echo SOLUCAO MANUAL:
    echo 1. Baixe manualmente: https://github.com/BtbN/FFmpeg-Builds/releases
    echo 2. Extraia ffmpeg.exe para esta pasta
    echo.
    pause
    goto menu
)

echo Extraindo arquivos...
powershell -Command "try { Expand-Archive -Path 'ffmpeg.zip' -DestinationPath '.' -Force; Write-Host 'Extracao concluida!' } catch { Write-Host 'ERRO: Falha na extracao!' }"
if errorlevel 1 (
    echo ERRO: Falha ao extrair arquivos!
    pause
    goto menu
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
echo ✓ FFmpeg instalado na pasta atual!
echo Agora voce pode usar o sistema normalmente.
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
    if exist "ffmpeg.exe" (
        echo ✓ ffmpeg.exe encontrado na pasta atual
        echo (Sistema funcionara normalmente)
    ) else (
        echo ✗ ffmpeg.exe nao encontrado na pasta atual
        echo.
        echo SOLUCAO:
        echo Execute a opcao 2 para baixar ffmpeg.exe
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
