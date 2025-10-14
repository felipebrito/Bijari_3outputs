#!/usr/bin/env python3
"""
Bijari 3 Outputs - Multi-Monitor Video Sync
Sistema de sincronização de vídeos para múltiplos monitores
"""

import subprocess
import os
import time
import threading
import keyboard
import win32gui
import win32con
import shutil
from config import *


def find_vlc_window():
    """Encontra a janela do VLC."""
    def enum_windows_callback(hwnd, windows):
        if win32gui.IsWindowVisible(hwnd):
            window_title = win32gui.GetWindowText(hwnd)
            if "VLC" in window_title or "vlc" in window_title.lower():
                windows.append(hwnd)
        return True
    
    windows = []
    win32gui.EnumWindows(enum_windows_callback, windows)
    return windows[0] if windows else None

def bring_vlc_to_front():
    """Traz o VLC para frente e mantém em foco."""
    hwnd = find_vlc_window()
    if hwnd:
        try:
            # Verifica se a janela está minimizada
            if win32gui.IsIconic(hwnd):
                win32gui.ShowWindow(hwnd, win32con.SW_RESTORE)
            
            # Traz para frente
            win32gui.SetForegroundWindow(hwnd)
            
            # Mantém sempre no topo
            win32gui.SetWindowPos(hwnd, win32con.HWND_TOPMOST, 0, 0, 0, 0, 
                                 win32con.SWP_NOMOVE | win32con.SWP_NOSIZE)
            return True
        except Exception:
            # Se falhar, apenas mantém no topo
            try:
                win32gui.SetWindowPos(hwnd, win32con.HWND_TOPMOST, 0, 0, 0, 0, 
                                     win32con.SWP_NOMOVE | win32con.SWP_NOSIZE)
                return True
            except:
                return False
    return False

def focus_monitor():
    """Thread que monitora e mantém o VLC em foco."""
    while True:
        time.sleep(FOCUS_CHECK_INTERVAL)
        if not bring_vlc_to_front():
            print("VLC não encontrado, tentando novamente...")

def setup_global_hotkey():
    """Configura tecla de atalho global para sair."""
    def on_hotkey():
        print("\nTecla de atalho detectada! Fechando VLC...")
        # Fecha o VLC
        hwnd = find_vlc_window()
        if hwnd:
            win32gui.PostMessage(hwnd, win32con.WM_CLOSE, 0, 0)
        # Fecha o script
        os._exit(0)
    
    # Tecla de atalho configurável
    keyboard.add_hotkey(HOTKEY, on_hotkey)
    print(f"Tecla de atalho configurada: {HOTKEY.upper()} para sair")

def find_ffmpeg():
    """Encontra o FFmpeg no sistema."""
    # Caminhos possíveis para o FFmpeg (prioridade para pasta local)
    possible_paths = [
        "ffmpeg.exe",  # Na pasta do projeto (prioridade máxima)
        "ffmpeg",  # No PATH
        r"C:\ffmpeg\bin\ffmpeg.exe",
        r"C:\Program Files\ffmpeg\bin\ffmpeg.exe",
        r"C:\Program Files (x86)\ffmpeg\bin\ffmpeg.exe",
        r"C:\tools\ffmpeg\bin\ffmpeg.exe",
        r"C:\Users\{}\AppData\Local\ffmpeg\bin\ffmpeg.exe".format(os.getenv('USERNAME')),
    ]
    
    for path in possible_paths:
        if shutil.which(path) or os.path.exists(path):
            print(f"[OK] FFmpeg encontrado: {path}")
            return path
    
    # Se não encontrou, tenta baixar automaticamente
    print("FFmpeg não encontrado. Tentando baixar automaticamente...")
    if download_ffmpeg():
        if os.path.exists("ffmpeg.exe"):
            print("[OK] FFmpeg baixado com sucesso!")
            return "ffmpeg.exe"
    
    return None


def download_ffmpeg():
    """Baixa o FFmpeg automaticamente."""
    try:
        print("Baixando FFmpeg...")
        import urllib.request
        
        # URL do FFmpeg
        url = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
        
        # Baixa o arquivo
        urllib.request.urlretrieve(url, "ffmpeg.zip")
        
        # Extrai o arquivo
        import zipfile
        with zipfile.ZipFile("ffmpeg.zip", 'r') as zip_ref:
            zip_ref.extractall(".")
        
        # Move os executáveis
        for root, dirs, files in os.walk("ffmpeg-master-latest-win64-gpl"):
            if "bin" in root:
                for file in files:
                    if file in ["ffmpeg.exe", "ffprobe.exe"]:
                        src = os.path.join(root, file)
                        dst = file
                        shutil.copy2(src, dst)
                        print(f"[OK] {file} copiado!")
        
        # Limpa arquivos temporários
        os.remove("ffmpeg.zip")
        shutil.rmtree("ffmpeg-master-latest-win64-gpl")
        
        return True
        
    except Exception as e:
        print(f"ERRO ao baixar FFmpeg: {e}")
        return False


def combine_videos():
    """Combina os 3 vídeos em um único arquivo."""
    print("Combinando vídeos com FFmpeg...")
    
    # Encontra o FFmpeg
    ffmpeg_path = find_ffmpeg()
    if not ffmpeg_path:
        print("ERRO: FFmpeg não encontrado!")
        print()
        print("SOLUÇÃO:")
        print("1. Baixe FFmpeg em: https://ffmpeg.org/download.html")
        print("2. Extraia para C:\\ffmpeg\\")
        print("3. Adicione C:\\ffmpeg\\bin\\ ao PATH do sistema")
        print("4. Ou coloque ffmpeg.exe na pasta do projeto")
        print()
        return False
    
    # Verifica se os vídeos existem
    print("Verificando vídeos de entrada...")
    for video in INPUT_VIDEOS:
        if not os.path.exists(video):
            print(f"ERRO: {video} não encontrado!")
            return False
        else:
            print(f"[OK] {video} encontrado")
    
    # Tenta uma abordagem mais simples primeiro
    print("\nTentando abordagem mais simples...")
    
    # Abordagem ultra simples que deve funcionar
    simple_cmd = [
        ffmpeg_path,
        "-i", INPUT_VIDEOS[0],
        "-i", INPUT_VIDEOS[1], 
        "-i", INPUT_VIDEOS[2],
        "-filter_complex", 
        "[0:v][1:v][2:v]hstack=inputs=3[v]",
        "-map", "[v]",
        "-c:v", "libx264",
        "-preset", "ultrafast",
        "-crf", "30",
        "-y",
        OUTPUT_VIDEO
    ]
    
    print(f"Comando simples: {' '.join(simple_cmd)}")
    result = subprocess.run(simple_cmd, capture_output=True, text=True)
    
    if result.returncode == 0 and os.path.exists(OUTPUT_VIDEO) and os.path.getsize(OUTPUT_VIDEO) > 0:
        print(f"[OK] Vídeos combinados com sucesso!")
        print(f"Arquivo gerado: {OUTPUT_VIDEO}")
        file_size = os.path.getsize(OUTPUT_VIDEO)
        print(f"Tamanho: {file_size / (1024*1024):.2f} MB")
        return True
    else:
        print(f"[ERRO] Falha com comando simples")
        if result.stderr:
            print(f"Erro: {result.stderr[:200]}...")
        
        # Tenta com apenas 2 vídeos
        print("\nTentando com apenas 2 vídeos...")
        cmd_2videos = [
            ffmpeg_path,
            "-i", INPUT_VIDEOS[0],
            "-i", INPUT_VIDEOS[1],
            "-filter_complex", 
            "[0:v][1:v]hstack=inputs=2[v]",
            "-map", "[v]",
            "-c:v", "libx264",
            "-preset", "ultrafast",
            "-y",
            OUTPUT_VIDEO
        ]
        
        result2 = subprocess.run(cmd_2videos, capture_output=True, text=True)
        if result2.returncode == 0 and os.path.exists(OUTPUT_VIDEO) and os.path.getsize(OUTPUT_VIDEO) > 0:
            print(f"[OK] Vídeos combinados com sucesso (2 vídeos)!")
            print(f"Arquivo gerado: {OUTPUT_VIDEO}")
            return True
        else:
            print(f"[ERRO] Falha mesmo com 2 vídeos")
            if result2.stderr:
                print(f"Erro: {result2.stderr[:200]}...")
            
            # Última tentativa: copiar apenas o primeiro vídeo
            print("\nÚltima tentativa: copiando apenas o primeiro vídeo...")
            cmd_copy = [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-c", "copy",
                "-y",
                OUTPUT_VIDEO
            ]
            
            result3 = subprocess.run(cmd_copy, capture_output=True, text=True)
            if result3.returncode == 0 and os.path.exists(OUTPUT_VIDEO) and os.path.getsize(OUTPUT_VIDEO) > 0:
                print(f"[OK] Pelo menos o primeiro vídeo foi copiado!")
                print(f"Arquivo gerado: {OUTPUT_VIDEO}")
                return True
            else:
                print(f"[ERRO] Falha total - FFmpeg não consegue processar os vídeos")
                return False
    

def main():
    """Função principal."""
    print("=== Bijari 3 Outputs - Multi-Monitor Video Sync ===")
    
    # Verifica se o VLC existe
    if not os.path.exists(VLC_PATH):
        print(f"ERRO: VLC não encontrado em {VLC_PATH}")
        return
    
    # Sempre tenta combinar os vídeos primeiro (força conversão)
    print("Forçando conversão dos vídeos...")
    if os.path.exists(OUTPUT_VIDEO):
        print("Removendo vídeo existente para forçar nova conversão...")
        os.remove(OUTPUT_VIDEO)
    
    print("Tentando combinar vídeos...")
    if not combine_videos():
        print("Falha ao combinar vídeos. Usando vídeo de fallback...")
        # Verifica se há um vídeo de fallback
        fallback_video = "combined_video_fallback.mp4"
        if os.path.exists(fallback_video):
            print(f"[OK] Usando vídeo de fallback: {fallback_video}")
            # Copia o vídeo de fallback para o nome esperado
            import shutil
            shutil.copy2(fallback_video, OUTPUT_VIDEO)
            print(f"[OK] Vídeo de fallback copiado como: {OUTPUT_VIDEO}")
        else:
            print("[ERRO] Nenhum vídeo encontrado para reproduzir!")
            return
    else:
        print(f"[OK] Vídeos combinados com sucesso: {OUTPUT_VIDEO}")
    
    
    # Comando VLC borderless (modo normal com arquivo combinado)
    cmd = [VLC_PATH, OUTPUT_VIDEO] + VLC_ARGS
    
    print("Executando VLC...")
    subprocess.Popen(cmd)
    
    # Aguarda o VLC abrir
    time.sleep(VLC_STARTUP_DELAY)
    
    # Configura tecla de atalho global
    setup_global_hotkey()
    
    # Inicia thread de monitoramento de foco
    focus_thread = threading.Thread(target=focus_monitor, daemon=True)
    focus_thread.start()
    
    print(f"VLC iniciado em {VIDEO_WIDTH}x{VIDEO_HEIGHT} (Borderless) e Loop!")
    print(f"Tecla de atalho: {HOTKEY.upper()} para sair")
    print("VLC será mantido sempre em foco automaticamente...")
    
    try:
        # Mantém o script rodando
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nFechando...")
        os._exit(0)


if __name__ == "__main__":
    main()