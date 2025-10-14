#!/usr/bin/env python3
"""
Configurações do Bijari 3 Outputs
"""

# Caminhos
VLC_PATH = r"C:\Program Files\VideoLAN\VLC\vlc.exe"
FFMPEG_PATH = "ffmpeg"  # Deve estar no PATH

# Vídeos de entrada
INPUT_VIDEOS = ["Tela01.mp4", "Tela02.mp4", "Tela03.mp4"]
OUTPUT_VIDEO = "combined_video.mp4"

# Resoluções
VIDEO_WIDTH = 5760  # Largura total (3 monitores)
VIDEO_HEIGHT = 1080  # Altura padrão
INDIVIDUAL_WIDTH = 1920  # Largura de cada vídeo individual
INDIVIDUAL_HEIGHT = 1080  # Altura de cada vídeo individual

# Configurações do VLC
VLC_ARGS = [
    "--width", str(VIDEO_WIDTH),
    "--height", str(VIDEO_HEIGHT),
    "--video-x", "0",
    "--video-y", "0",
    "--no-video-deco",
    "--input-repeat=65535",  # Loop infinito
    "--no-video-title-show",
    "--no-osd",
    "--no-embedded-video",
    "--qt-start-minimized"
]

# Tecla de atalho
HOTKEY = "ctrl+q"

# Configurações de monitoramento
FOCUS_CHECK_INTERVAL = 1  # Segundos entre verificações de foco
VLC_STARTUP_DELAY = 3  # Segundos para aguardar VLC abrir
