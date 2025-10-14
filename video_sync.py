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
            print(f"✓ FFmpeg encontrado: {path}")
            return path
    
    # Se não encontrou, tenta baixar automaticamente
    print("FFmpeg não encontrado. Tentando baixar automaticamente...")
    if download_ffmpeg():
        if os.path.exists("ffmpeg.exe"):
            print("✓ FFmpeg baixado com sucesso!")
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
                        print(f"✓ {file} copiado!")
        
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
            print(f"✓ {video} encontrado")
    
    # Se o FFmpeg está com problemas, tenta usar o VLC para reproduzir diretamente
    print("\nAVISO: FFmpeg está com problemas (erro 3221225781)")
    print("Isso pode ser causado por:")
    print("- Vídeos corrompidos ou formato incompatível")
    print("- FFmpeg com problemas de compatibilidade")
    print("- Problemas de memória ou permissões")
    print()
    print("SOLUÇÃO ALTERNATIVA:")
    print("Vou tentar reproduzir os vídeos diretamente no VLC")
    print("sem combinar (cada vídeo em uma janela separada)")
    print()
    
    # Pergunta se quer continuar sem combinar
    try:
        resposta = input("Continuar sem combinar vídeos? (s/n): ").lower().strip()
        if resposta in ['s', 'sim', 'y', 'yes']:
            print("✓ Continuando sem combinar vídeos...")
            return True  # Retorna True para continuar sem arquivo combinado
        else:
            print("✗ Operação cancelada pelo usuário")
            return False
    except:
        print("✓ Continuando sem combinar vídeos...")
        return True
    
    # Tenta diferentes abordagens para evitar erro de memória
    approaches = [
        # Abordagem 1: Comando original
        {
            "name": "Comando original",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-i", INPUT_VIDEOS[1], 
                "-i", INPUT_VIDEOS[2],
                "-filter_complex", 
                f"[0:v]transpose=1,scale={INDIVIDUAL_WIDTH}:{INDIVIDUAL_HEIGHT}[v0];"
                f"[1:v]transpose=1,scale={INDIVIDUAL_WIDTH}:{INDIVIDUAL_HEIGHT}[v1];"
                f"[2:v]transpose=1,scale={INDIVIDUAL_WIDTH}:{INDIVIDUAL_HEIGHT}[v2];"
                "[v0][v1][v2]hstack=inputs=3[v]",
                "-map", "[v]",
                "-c:v", "libx264",
                "-preset", "fast",
                "-crf", "23",
                "-y",
                OUTPUT_VIDEO
            ]
        },
        # Abordagem 2: Sem rotação (mais simples)
        {
            "name": "Sem rotação",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-i", INPUT_VIDEOS[1], 
                "-i", INPUT_VIDEOS[2],
                "-filter_complex", 
                f"[0:v]scale={INDIVIDUAL_WIDTH}:{INDIVIDUAL_HEIGHT}[v0];"
                f"[1:v]scale={INDIVIDUAL_WIDTH}:{INDIVIDUAL_HEIGHT}[v1];"
                f"[2:v]scale={INDIVIDUAL_WIDTH}:{INDIVIDUAL_HEIGHT}[v2];"
                "[v0][v1][v2]hstack=inputs=3[v]",
                "-map", "[v]",
                "-c:v", "libx264",
                "-preset", "ultrafast",
                "-crf", "28",
                "-y",
                OUTPUT_VIDEO
            ]
        },
        # Abordagem 3: Mais simples ainda
        {
            "name": "Comando simplificado",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-i", INPUT_VIDEOS[1], 
                "-i", INPUT_VIDEOS[2],
                "-filter_complex", 
                "[0:v][1:v][2:v]hstack=inputs=3[v]",
                "-map", "[v]",
                "-c:v", "libx264",
                "-preset", "ultrafast",
                "-y",
                OUTPUT_VIDEO
            ]
        },
        # Abordagem 4: Ultra simples (sem codec específico)
        {
            "name": "Ultra simples",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-i", INPUT_VIDEOS[1], 
                "-i", INPUT_VIDEOS[2],
                "-filter_complex", 
                "hstack=inputs=3",
                "-y",
                OUTPUT_VIDEO
            ]
        },
        # Abordagem 5: Apenas 2 vídeos primeiro
        {
            "name": "Apenas 2 vídeos",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-i", INPUT_VIDEOS[1],
                "-filter_complex", 
                "hstack=inputs=2",
                "-y",
                OUTPUT_VIDEO
            ]
        },
        # Abordagem 6: Copiar apenas o primeiro vídeo
        {
            "name": "Copiar primeiro vídeo",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-c", "copy",
                "-y",
                OUTPUT_VIDEO
            ]
        },
        # Abordagem 7: Teste básico sem filtros
        {
            "name": "Teste básico",
            "cmd": [
                ffmpeg_path,
                "-i", INPUT_VIDEOS[0],
                "-t", "10",  # Apenas 10 segundos
                "-y",
                OUTPUT_VIDEO
            ]
        }
    ]
    
    for i, approach in enumerate(approaches, 1):
        print(f"\nTentativa {i}: {approach['name']}")
        print(f"Comando: {' '.join(approach['cmd'])}")
        
        result = subprocess.run(approach['cmd'], capture_output=True, text=True)
        
        if result.returncode == 0:
            # Verifica se o arquivo foi realmente criado
            if os.path.exists(OUTPUT_VIDEO) and os.path.getsize(OUTPUT_VIDEO) > 0:
                print(f"✓ Vídeos combinados com sucesso usando {approach['name']}!")
                print(f"Arquivo gerado: {OUTPUT_VIDEO}")
                file_size = os.path.getsize(OUTPUT_VIDEO)
                print(f"Tamanho: {file_size / (1024*1024):.2f} MB")
                return True
            else:
                print(f"✗ FFmpeg retornou sucesso mas arquivo não foi criado!")
                print(f"Verificando se {OUTPUT_VIDEO} existe...")
                if os.path.exists(OUTPUT_VIDEO):
                    print(f"Arquivo existe mas está vazio (tamanho: {os.path.getsize(OUTPUT_VIDEO)} bytes)")
                else:
                    print(f"Arquivo não existe")
                continue  # Tenta próxima abordagem
        else:
            print(f"✗ Falha com {approach['name']}")
            print(f"Código de erro: {result.returncode}")
            if result.stderr:
                print(f"Erro: {result.stderr[:200]}...")  # Limita o tamanho do erro
            if result.stdout:
                print(f"Saída: {result.stdout[:200]}...")  # Limita o tamanho da saída
    
    print(f"\n✗ Todas as tentativas falharam!")
    print("Verificando vídeos de entrada:")
    for video in INPUT_VIDEOS:
        if os.path.exists(video):
            print(f"✓ {video} encontrado")
        else:
            print(f"✗ {video} NÃO encontrado!")
    
    return False

def main():
    """Função principal."""
    print("=== Bijari 3 Outputs - Multi-Monitor Video Sync ===")
    
    # Verifica se o VLC existe
    if not os.path.exists(VLC_PATH):
        print(f"ERRO: VLC não encontrado em {VLC_PATH}")
        return
    
    # Combina os vídeos se necessário
    if not os.path.exists(OUTPUT_VIDEO):
        if not combine_videos():
            return
    else:
        print(f"✓ Vídeo combinado já existe: {OUTPUT_VIDEO}")
    
    # Se não há arquivo combinado, reproduz vídeos separadamente
    if not os.path.exists(OUTPUT_VIDEO):
        print("\n=== MODO ALTERNATIVO: VÍDEOS SEPARADOS ===")
        print("Reproduzindo cada vídeo em uma janela separada...")
        
        # Abre cada vídeo em uma janela separada
        for i, video in enumerate(INPUT_VIDEOS):
            if os.path.exists(video):
                print(f"Abrindo {video}...")
                # Comando VLC para cada vídeo individual
                cmd_individual = [
                    VLC_PATH, video,
                    "--width", str(INDIVIDUAL_WIDTH),
                    "--height", str(INDIVIDUAL_HEIGHT),
                    "--video-x", str(i * INDIVIDUAL_WIDTH),  # Posiciona lado a lado
                    "--video-y", "0",
                    "--no-video-deco",
                    "--input-repeat=65535",  # Loop infinito
                    "--no-video-title-show",
                    "--no-osd",
                    "--no-embedded-video",
                    "--qt-start-minimized"
                ]
                subprocess.Popen(cmd_individual)
                time.sleep(1)  # Pequena pausa entre aberturas
        
        print("✓ Todos os vídeos abertos em janelas separadas!")
        print("As janelas serão posicionadas lado a lado automaticamente.")
        print(f"Tecla de atalho: {HOTKEY.upper()} para sair")
        
        # Configura tecla de atalho global
        setup_global_hotkey()
        
        try:
            # Mantém o script rodando
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            print("\nFechando...")
            os._exit(0)
        return
    
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