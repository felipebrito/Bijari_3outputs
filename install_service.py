#!/usr/bin/env python3
"""
Instalador de Serviço Windows para Bijari 3 Outputs
Cria um serviço Windows que mantém a aplicação sempre rodando
"""

import os
import sys
import subprocess
import win32serviceutil
import win32service
import win32event
import servicemanager
import logging
from config import *

class BijariService(win32serviceutil.ServiceFramework):
    """Serviço Windows para Bijari 3 Outputs."""
    
    _svc_name_ = "Bijari3Outputs"
    _svc_display_name_ = "Bijari 3 Outputs Video Sync"
    _svc_description_ = "Sistema de sincronização de vídeos para múltiplos monitores"
    
    def __init__(self, args):
        win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        self.process = None
        
        # Configuração de logging
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('bijari_service.log'),
                logging.StreamHandler()
            ]
        )
    
    def SvcStop(self):
        """Para o serviço."""
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)
        
        if self.process:
            self.process.terminate()
            logging.info("Processo de vídeo terminado")
    
    def SvcDoRun(self):
        """Executa o serviço."""
        servicemanager.LogMsg(
            servicemanager.EVENTLOG_INFORMATION_TYPE,
            servicemanager.PYS_SERVICE_STARTED,
            (self._svc_name_, '')
        )
        
        logging.info("Serviço Bijari 3 Outputs iniciado")
        
        try:
            self.main_loop()
        except Exception as e:
            logging.error(f"Erro no serviço: {e}")
            servicemanager.LogErrorMsg(f"Erro no serviço: {e}")
    
    def main_loop(self):
        """Loop principal do serviço."""
        restart_count = 0
        max_restarts = 10
        restart_window = 3600  # 1 hora
        last_restart = 0
        
        while True:
            # Verifica se deve parar
            if win32event.WaitForSingleObject(self.hWaitStop, 5000) == win32event.WAIT_OBJECT_0:
                break
            
            # Verifica se o processo está rodando
            if not self.is_process_running():
                logging.warning("Processo de vídeo não está rodando!")
                
                current_time = time.time()
                if current_time - last_restart > restart_window:
                    restart_count = 0
                
                if restart_count < max_restarts:
                    self.start_video_process()
                    restart_count += 1
                    last_restart = current_time
                    logging.info(f"Processo reiniciado (tentativa {restart_count})")
                else:
                    logging.error("Limite de restarts atingido!")
                    time.sleep(60)
            else:
                if restart_count > 0:
                    logging.info("Sistema funcionando normalmente")
                    restart_count = 0
    
    def is_process_running(self):
        """Verifica se o processo está rodando."""
        try:
            result = subprocess.run(
                ['tasklist', '/FI', 'IMAGENAME eq python.exe', '/FI', 'WINDOWTITLE eq *video_sync*'],
                capture_output=True, text=True
            )
            return 'python.exe' in result.stdout
        except:
            return False
    
    def start_video_process(self):
        """Inicia o processo de vídeo."""
        try:
            if self.process:
                self.process.terminate()
            
            # Mata processos VLC existentes
            subprocess.run(['taskkill', '/F', '/IM', 'vlc.exe'], 
                         capture_output=True, text=True)
            
            # Inicia novo processo
            self.process = subprocess.Popen([
                sys.executable, 'video_sync.py'
            ], cwd=os.getcwd())
            
            logging.info(f"Processo iniciado com PID: {self.process.pid}")
            
        except Exception as e:
            logging.error(f"Erro ao iniciar processo: {e}")

def install_service():
    """Instala o serviço."""
    try:
        win32serviceutil.InstallService(
            BijariService._svc_name_,
            BijariService._svc_display_name_,
            description=BijariService._svc_description_,
            startType=win32service.SERVICE_AUTO_START
        )
        print("✓ Serviço instalado com sucesso!")
        print("  Nome: Bijari3Outputs")
        print("  Descrição: Bijari 3 Outputs Video Sync")
        print("  Tipo: Inicialização automática")
        return True
    except Exception as e:
        print(f"✗ Erro ao instalar serviço: {e}")
        return False

def uninstall_service():
    """Desinstala o serviço."""
    try:
        win32serviceutil.RemoveService(BijariService._svc_name_)
        print("✓ Serviço desinstalado com sucesso!")
        return True
    except Exception as e:
        print(f"✗ Erro ao desinstalar serviço: {e}")
        return False

def start_service():
    """Inicia o serviço."""
    try:
        win32serviceutil.StartService(BijariService._svc_name_)
        print("✓ Serviço iniciado com sucesso!")
        return True
    except Exception as e:
        print(f"✗ Erro ao iniciar serviço: {e}")
        return False

def stop_service():
    """Para o serviço."""
    try:
        win32serviceutil.StopService(BijariService._svc_name_)
        print("✓ Serviço parado com sucesso!")
        return True
    except Exception as e:
        print(f"✗ Erro ao parar serviço: {e}")
        return False

def main():
    """Função principal."""
    if len(sys.argv) == 1:
        print("=== Bijari 3 Outputs - Instalador de Serviço ===")
        print()
        print("Uso:")
        print("  python install_service.py install   - Instala o serviço")
        print("  python install_service.py remove    - Remove o serviço")
        print("  python install_service.py start     - Inicia o serviço")
        print("  python install_service.py stop      - Para o serviço")
        print("  python install_service.py restart   - Reinicia o serviço")
        print()
        print("IMPORTANTE: Execute como administrador!")
        return
    
    action = sys.argv[1].lower()
    
    if action == 'install':
        install_service()
    elif action == 'remove':
        uninstall_service()
    elif action == 'start':
        start_service()
    elif action == 'stop':
        stop_service()
    elif action == 'restart':
        stop_service()
        time.sleep(2)
        start_service()
    else:
        print("Ação inválida!")

if __name__ == '__main__':
    main()
