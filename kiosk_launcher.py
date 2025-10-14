#!/usr/bin/env python3
"""
Kiosk Launcher - Sistema de produção para Bijari 3 Outputs
Garante que a aplicação sempre esteja rodando, mesmo após falhas
"""

import subprocess
import time
import os
import sys
import psutil
import logging
import ctypes
from datetime import datetime
from config import *

# Configuração de logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('kiosk.log'),
        logging.StreamHandler()
    ]
)

class KioskManager:
    def __init__(self):
        self.process = None
        self.restart_count = 0
        self.max_restarts = 10  # Máximo de restarts por hora
        self.restart_window = 3600  # 1 hora em segundos
        self.last_restart_time = 0
        
    def is_video_sync_running(self):
        """Verifica se o video_sync.py está rodando."""
        for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
            try:
                if proc.info['cmdline'] and 'video_sync.py' in ' '.join(proc.info['cmdline']):
                    return True
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                continue
        return False
    
    def is_vlc_running(self):
        """Verifica se o VLC está rodando."""
        for proc in psutil.process_iter(['pid', 'name']):
            try:
                if proc.info['name'] and 'vlc.exe' in proc.info['name'].lower():
                    return True
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                continue
        return False
    
    def kill_video_processes(self):
        """Mata todos os processos relacionados ao vídeo."""
        try:
            # Mata processos do VLC
            for proc in psutil.process_iter(['pid', 'name']):
                if proc.info['name'] and 'vlc.exe' in proc.info['name'].lower():
                    proc.kill()
                    logging.info(f"VLC process {proc.info['pid']} killed")
            
            # Mata processos do video_sync.py
            for proc in psutil.process_iter(['pid', 'name', 'cmdline']):
                if proc.info['cmdline'] and 'video_sync.py' in ' '.join(proc.info['cmdline']):
                    proc.kill()
                    logging.info(f"Video sync process {proc.info['pid']} killed")
                    
            time.sleep(2)  # Aguarda os processos terminarem
        except Exception as e:
            logging.error(f"Erro ao matar processos: {e}")
    
    def start_video_sync(self):
        """Inicia o video_sync.py."""
        try:
            logging.info("Iniciando video_sync.py...")
            self.process = subprocess.Popen([sys.executable, 'video_sync.py'])
            self.restart_count += 1
            self.last_restart_time = time.time()
            logging.info(f"Video sync iniciado com PID: {self.process.pid}")
            return True
        except Exception as e:
            logging.error(f"Erro ao iniciar video_sync: {e}")
            return False
    
    def should_restart(self):
        """Verifica se deve reiniciar baseado no limite de restarts."""
        current_time = time.time()
        
        # Reset contador se passou da janela de tempo
        if current_time - self.last_restart_time > self.restart_window:
            self.restart_count = 0
        
        return self.restart_count < self.max_restarts
    
    def run_kiosk_mode(self):
        """Modo kiosk principal."""
        logging.info("=== INICIANDO MODO KIOSK ===")
        logging.info("Pressione Ctrl+C para sair do modo kiosk")
        
        try:
            while True:
                # Verifica se o video_sync está rodando
                if not self.is_video_sync_running():
                    logging.warning("Video sync não está rodando!")
                    
                    if self.should_restart():
                        # Mata processos antigos
                        self.kill_video_processes()
                        
                        # Inicia novo processo
                        if self.start_video_sync():
                            logging.info("Video sync reiniciado com sucesso!")
                        else:
                            logging.error("Falha ao reiniciar video_sync!")
                            time.sleep(10)
                    else:
                        logging.error("Limite de restarts atingido! Aguardando...")
                        time.sleep(60)
                
                # Verifica se o VLC está rodando (backup check)
                elif not self.is_vlc_running():
                    logging.warning("VLC não está rodando! Reiniciando...")
                    self.kill_video_processes()
                    time.sleep(5)
                    if self.should_restart():
                        self.start_video_sync()
                
                else:
                    # Tudo funcionando normalmente
                    if self.restart_count > 0:
                        logging.info("Sistema funcionando normalmente")
                        self.restart_count = 0  # Reset contador em caso de sucesso
                
                time.sleep(5)  # Verifica a cada 5 segundos
                
        except KeyboardInterrupt:
            logging.info("Modo kiosk interrompido pelo usuário")
            self.kill_video_processes()
        except Exception as e:
            logging.error(f"Erro no modo kiosk: {e}")
            self.kill_video_processes()

def main():
    """Função principal."""
    print("=== Bijari 3 Outputs - Kiosk Mode ===")
    print("Sistema de produção com reinicialização automática")
    print("Pressione Ctrl+C para sair")
    print()
    
    # Verifica se está rodando como administrador
    try:
        is_admin = os.getuid() == 0
    except AttributeError:
        is_admin = ctypes.windll.shell32.IsUserAnAdmin() != 0
    
    if not is_admin:
        print("⚠️  AVISO: Execute como administrador para melhor funcionamento")
        print()
    
    kiosk = KioskManager()
    kiosk.run_kiosk_mode()

if __name__ == "__main__":
    main()
