#!/usr/bin/env python3
"""
Configurações do Bijari 4K - Matriz 2x2
Sistema de sincronização de vídeos em matriz 2x2 para saída 4K
"""

# Caminhos
VLC_PATH = r"C:\Program Files\VideoLAN\VLC\vlc.exe"
FFMPEG_PATH = "ffmpeg"  # Deve estar no PATH

# Vídeos de entrada (Tela01, Tela02, Tela03, Tela03 repetido)
INPUT_VIDEOS = ["Tela01.mp4", "Tela02.mp4", "Tela03.mp4", "Tela03.mp4"]
OUTPUT_VIDEO = "combined_video_4k.mp4"

# Resoluções para matriz 2x2 4K
# Resolução final: 3840x2160 (4K padrão - 2x2 de vídeos 1920x1080)
FINAL_WIDTH = 3840   # Largura total da saída 4K
FINAL_HEIGHT = 2160  # Altura total da saída 4K

# Resolução de cada vídeo individual na matriz (Full HD após rotação)
INDIVIDUAL_WIDTH = 1920   # Largura de cada vídeo individual (após rotação 90°)
INDIVIDUAL_HEIGHT = 1080  # Altura de cada vídeo individual (após rotação 90°)

# Configurações do VLC para 4K
VLC_ARGS = [
    "--width", str(FINAL_WIDTH),
    "--height", str(FINAL_HEIGHT),
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

# Configurações específicas da matriz 2x2
MATRIX_LAYOUT = {
    "rows": 2,
    "cols": 2,
    "total_videos": 4,
    "layout": [
        [0, 1],  # Primeira linha: Tela01, Tela02
        [2, 3]   # Segunda linha: Tela03, Tela03 (repetido)
    ]
}
