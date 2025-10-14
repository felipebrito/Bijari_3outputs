# Bijari 3 Outputs - Kiosk Mode PowerShell Launcher
# Sistema de produção com reinicialização automática

param(
    [switch]$RunAsAdmin,
    [switch]$Silent
)

# Configurações
$Title = "Bijari 3 Outputs - Kiosk Mode"
$LogFile = "kiosk.log"
$MaxRestarts = 10
$RestartWindow = 3600  # 1 hora

# Função para logging
function Write-Log {
    param($Message, $Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "$Timestamp - $Level - $Message"
    Write-Host $LogEntry
    Add-Content -Path $LogFile -Value $LogEntry
}

# Função para verificar se está rodando como admin
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Função para verificar se o processo está rodando
function Test-ProcessRunning {
    param($ProcessName)
    return (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue) -ne $null
}

# Função para matar processos
function Stop-VideoProcesses {
    Write-Log "Parando processos de vídeo..."
    
    # Para VLC
    Get-Process -Name "vlc" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    
    # Para video_sync.py
    Get-Process -Name "python" -ErrorAction SilentlyContinue | Where-Object {
        $_.CommandLine -like "*video_sync.py*"
    } | Stop-Process -Force
    
    Start-Sleep -Seconds 2
    Write-Log "Processos parados"
}

# Função para iniciar video_sync
function Start-VideoSync {
    Write-Log "Iniciando video_sync.py..."
    
    try {
        $process = Start-Process -FilePath "python" -ArgumentList "video_sync.py" -PassThru -WindowStyle Hidden
        Write-Log "Video sync iniciado com PID: $($process.Id)"
        return $true
    }
    catch {
        Write-Log "Erro ao iniciar video_sync: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Função principal do kiosk
function Start-KioskMode {
    $RestartCount = 0
    $LastRestartTime = 0
    
    Write-Log "=== INICIANDO MODO KIOSK ==="
    Write-Log "Pressione Ctrl+C para sair do modo kiosk"
    
    try {
        while ($true) {
            $VideoSyncRunning = Test-ProcessRunning "python"
            $VlcRunning = Test-ProcessRunning "vlc"
            
            if (-not $VideoSyncRunning) {
                Write-Log "Video sync não está rodando!" "WARNING"
                
                $CurrentTime = Get-Date -AsUTC
                $TimeSinceLastRestart = $CurrentTime - [DateTime]::FromFileTime($LastRestartTime)
                
                if ($TimeSinceLastRestart.TotalSeconds -gt $RestartWindow) {
                    $RestartCount = 0
                }
                
                if ($RestartCount -lt $MaxRestarts) {
                    Stop-VideoProcesses
                    if (Start-VideoSync) {
                        Write-Log "Video sync reiniciado com sucesso!"
                        $RestartCount++
                        $LastRestartTime = $CurrentTime.ToFileTime()
                    } else {
                        Write-Log "Falha ao reiniciar video_sync!" "ERROR"
                        Start-Sleep -Seconds 10
                    }
                } else {
                    Write-Log "Limite de restarts atingido! Aguardando..." "ERROR"
                    Start-Sleep -Seconds 60
                }
            }
            elseif (-not $VlcRunning) {
                Write-Log "VLC não está rodando! Reiniciando..." "WARNING"
                Stop-VideoProcesses
                Start-Sleep -Seconds 5
                if ($RestartCount -lt $MaxRestarts) {
                    Start-VideoSync
                }
            }
            else {
                # Tudo funcionando normalmente
                if ($RestartCount -gt 0) {
                    Write-Log "Sistema funcionando normalmente"
                    $RestartCount = 0
                }
            }
            
            Start-Sleep -Seconds 5
        }
    }
    catch [System.Management.Automation.CommandNotFoundException] {
        Write-Log "Comando interrompido pelo usuário" "INFO"
        Stop-VideoProcesses
    }
    catch {
        Write-Log "Erro no modo kiosk: $($_.Exception.Message)" "ERROR"
        Stop-VideoProcesses
    }
}

# Main
if (-not $Silent) {
    Write-Host "========================================"
    Write-Host "  Bijari 3 Outputs - Kiosk Mode"
    Write-Host "========================================"
    Write-Host ""
    Write-Host "Sistema de produção com reinicialização automática"
    Write-Host "Pressione Ctrl+C para sair"
    Write-Host ""
}

# Verifica se está rodando como admin
if (-not (Test-Administrator)) {
    if ($RunAsAdmin) {
        Write-Log "Reiniciando como administrador..." "INFO"
        Start-Process PowerShell -ArgumentList "-File `"$PSCommandPath`" -RunAsAdmin" -Verb RunAs
        exit
    } else {
        Write-Log "AVISO: Execute como administrador para melhor funcionamento" "WARNING"
    }
}

# Verifica se Python está instalado
try {
    $pythonVersion = python --version 2>&1
    Write-Log "Python encontrado: $pythonVersion"
} catch {
    Write-Log "ERRO: Python não encontrado! Instale o Python 3.8+" "ERROR"
    if (-not $Silent) { pause }
    exit 1
}

# Instala dependências
Write-Log "Verificando dependências..."
try {
    pip install psutil > $null 2>&1
    Write-Log "Dependências verificadas"
} catch {
    Write-Log "Erro ao verificar dependências: $($_.Exception.Message)" "WARNING"
}

# Inicia o kiosk mode
Start-KioskMode

if (-not $Silent) { pause }
