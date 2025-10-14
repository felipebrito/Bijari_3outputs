# Bijari 3 Outputs - Multi-Monitor Video Sync

Sistema de sincronização de vídeos para múltiplos monitores com controle de foco automático e tecla de atalho global.

## 🎯 Funcionalidades

- **Sincronização perfeita**: Combina 3 vídeos em um único arquivo para sincronização automática
- **Multi-monitor**: Cobre automaticamente 3 monitores (5760x1080)
- **Loop imperceptível**: Reprodução contínua sem tela preta
- **Foco automático**: Mantém o VLC sempre em foco, mesmo ao clicar em outras janelas
- **Tecla de atalho global**: `Ctrl+Q` para sair de qualquer lugar
- **Sem bordas**: Interface limpa sem decorações de janela

## 📋 Pré-requisitos

- Windows 10/11
- Python 3.8+
- VLC Media Player
- FFmpeg (para combinação de vídeos)

## 🚀 Instalação

1. **Clone o repositório:**
```bash
git clone https://github.com/felipebrito/Bijari_3outputs.git
cd Bijari_3outputs
```

2. **Instale as dependências Python:**
```bash
pip install keyboard pywin32
```

3. **Instale o VLC Media Player:**
   - Baixe em: https://www.videolan.org/vlc/
   - Instale no caminho padrão: `C:\Program Files\VideoLAN\VLC\vlc.exe`

4. **Instale o FFmpeg:**
   - Baixe em: https://ffmpeg.org/download.html
   - Adicione ao PATH do sistema

## 📁 Estrutura do Projeto

```
Bijari_3outputs/
├── video_sync.py          # Script principal
├── Tela01.mp4            # Vídeo para monitor 1 (1080x1920)
├── Tela02.mp4            # Vídeo para monitor 2 (1080x1920)
├── Tela03.mp4            # Vídeo para monitor 3 (1080x1920)
├── combined_video.mp4    # Vídeo combinado (5760x1080) - gerado automaticamente
└── README.md             # Esta documentação
```

## 🎬 Como Usar

1. **Prepare os vídeos:**
   - Coloque `Tela01.mp4`, `Tela02.mp4` e `Tela03.mp4` na pasta do projeto
   - Vídeos devem ter resolução 1080x1920 (portrait/vertical)
   - O sistema automaticamente gira os vídeos para 1920x1080 (landscape/horizontal) e combina

2. **Execute o sistema:**
```bash
python video_sync.py
```

3. **O sistema irá:**
   - Girar cada vídeo de 1080x1920 (portrait) para 1920x1080 (landscape)
   - Combinar os 3 vídeos girados em um único arquivo (5760x1080)
   - Abrir o VLC em modo borderless cobrindo todos os 3 monitores
   - Manter o vídeo sempre em foco automaticamente
   - Reproduzir em loop contínuo

4. **Para sair:**
   - Pressione `Ctrl+Q` de qualquer lugar (funciona globalmente)

## ⚙️ Configuração

### Resolução dos Monitores
O sistema foi otimizado para:
- **Monitor 1**: 1920x1080
- **Monitor 2**: 1920x1080  
- **Monitor 3**: 1920x1080
- **Total**: 5760x1080 (3 monitores lado a lado)

### Personalização
Para alterar as resoluções, edite o arquivo `config.py`:

```python
# Resoluções dos monitores individuais
INDIVIDUAL_WIDTH = 1920  # Largura de cada vídeo após rotação
INDIVIDUAL_HEIGHT = 1080  # Altura de cada vídeo após rotação

# Resolução total (3 monitores lado a lado)
VIDEO_WIDTH = 5760  # Largura total
VIDEO_HEIGHT = 1080  # Altura total
```

## 🔧 Solução de Problemas

### VLC não abre
- Verifique se o VLC está instalado em `C:\Program Files\VideoLAN\VLC\vlc.exe`
- Execute como administrador se necessário

### Vídeos não sincronizados
- O sistema combina os vídeos automaticamente para sincronização perfeita
- Se houver problemas, delete `combined_video.mp4` e execute novamente

### Tecla de atalho não funciona
- Execute o script como administrador
- Verifique se não há conflitos com outros programas

### Vídeo não cobre todos os monitores
- Verifique se os monitores estão configurados horizontalmente
- Ajuste as resoluções no código se necessário

## 📊 Especificações Técnicas

- **Formato de entrada**: MP4 (1080x1920 portrait)
- **Processamento**: Rotação 90° para 1920x1080 (landscape)
- **Formato de saída**: MP4 (5760x1080 - 3 monitores lado a lado)
- **Codec**: H.264
- **FPS**: Mantém o FPS original dos vídeos
- **Loop**: Infinito com `--input-repeat=65535`

## 🛠️ Desenvolvimento

### Estrutura do Código

```python
# Funções principais:
- main()                    # Função principal
- combine_videos()          # Combina os 3 vídeos com FFmpeg
- find_vlc_window()         # Encontra a janela do VLC
- bring_vlc_to_front()      # Mantém VLC em foco
- focus_monitor()           # Thread de monitoramento
- setup_global_hotkey()     # Configura tecla de atalho
```

### Dependências
- `keyboard`: Captura de teclas globais
- `pywin32`: Controle de janelas Windows
- `subprocess`: Execução de comandos
- `threading`: Monitoramento em background

## 📝 Changelog

### v1.0.0
- Sistema inicial com VLC borderless
- Combinação automática de vídeos
- Loop imperceptível
- Foco automático
- Tecla de atalho global

## 📄 Licença

Este projeto é de código aberto. Use livremente para fins comerciais e não comerciais.

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para:
- Reportar bugs
- Sugerir melhorias
- Enviar pull requests

## 📞 Suporte

Para suporte ou dúvidas:
- Abra uma issue no GitHub
- Entre em contato via email

---

**Desenvolvido com ❤️ para sincronização perfeita de vídeos multi-monitor**
