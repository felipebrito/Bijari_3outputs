# Guia de Produção - Bijari 3 Outputs

Este guia explica como configurar o sistema para ambiente de produção com máxima estabilidade e reinicialização automática.

## 🎯 Opções de Kiosk Mode

### 1. **Modo Simples (Recomendado para testes)**
```bash
# Executa o kiosk launcher Python
python kiosk_launcher.py

# Ou usa o script batch
start_kiosk.bat

# Ou usa o PowerShell
.\start_kiosk.ps1
```

### 2. **Modo PowerShell (Recomendado para produção)**
```powershell
# Executa como administrador
.\start_kiosk.ps1 -RunAsAdmin

# Executa silencioso (sem interface)
.\start_kiosk.ps1 -Silent
```

### 3. **Serviço Windows (Máxima robustez)**
```bash
# Instala o serviço (execute como administrador)
python install_service.py install

# Inicia o serviço
python install_service.py start

# Para o serviço
python install_service.py stop

# Remove o serviço
python install_service.py remove
```

## 🛡️ Características de Proteção

### **Reinicialização Automática**
- ✅ Detecta quando a aplicação para
- ✅ Reinicia automaticamente em caso de falha
- ✅ Limite de 10 restarts por hora (evita loops infinitos)
- ✅ Logs detalhados de todas as operações

### **Monitoramento de Processos**
- ✅ Verifica se `video_sync.py` está rodando
- ✅ Verifica se `vlc.exe` está rodando
- ✅ Mata processos órfãos antes de reiniciar

### **Logs e Debugging**
- ✅ Logs em arquivo (`kiosk.log` ou `bijari_service.log`)
- ✅ Timestamps de todas as operações
- ✅ Níveis de log (INFO, WARNING, ERROR)

## 🚀 Configuração para Produção

### **1. Preparação do Sistema**

```bash
# 1. Instale as dependências
pip install -r requirements.txt

# 2. Configure os monitores
# - 3 monitores em 1920x1080
# - Disposição horizontal (lado a lado)
# - Resolução total: 5760x1080

# 3. Prepare os vídeos
# - Tela01.mp4, Tela02.mp4, Tela03.mp4
# - Resolução: 1080x1920 (portrait)
```

### **2. Configuração do Kiosk Mode**

#### **Opção A: PowerShell (Recomendado)**
```powershell
# Crie um atalho para:
.\start_kiosk.ps1 -RunAsAdmin

# Configure para iniciar com Windows:
# 1. Win+R → shell:startup
# 2. Cole o atalho na pasta
```

#### **Opção B: Serviço Windows (Máxima robustez)**
```bash
# Instale o serviço
python install_service.py install

# Configure para iniciar automaticamente
# (já configurado como SERVICE_AUTO_START)
```

### **3. Configurações de Segurança**

#### **Desabilitar Ctrl+Alt+Del**
```powershell
# Desabilita o GINA (tela de login)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableCAD /t REG_DWORD /d 1 /f
```

#### **Desabilitar Task Manager**
```powershell
# Desabilita o Gerenciador de Tarefas
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f
```

#### **Modo Kiosk do Windows**
```powershell
# Configura o modo kiosk do Windows
# (Requer Windows 10/11 Pro ou Enterprise)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0
```

## 📊 Monitoramento

### **Logs do Sistema**
- `kiosk.log` - Logs do kiosk launcher
- `bijari_service.log` - Logs do serviço Windows
- `video_sync.py` - Logs da aplicação principal

### **Verificação de Status**
```bash
# Verifica se está rodando
tasklist | findstr python
tasklist | findstr vlc

# Verifica logs
type kiosk.log | findstr ERROR
type bijari_service.log | findstr ERROR
```

### **Reinicialização Manual**
```bash
# Para o sistema
taskkill /F /IM python.exe
taskkill /F /IM vlc.exe

# Reinicia
python kiosk_launcher.py
```

## 🔧 Solução de Problemas

### **Problema: Aplicação não reinicia**
- ✅ Verifique se está rodando como administrador
- ✅ Verifique os logs para erros
- ✅ Verifique se o limite de restarts não foi atingido

### **Problema: VLC não abre**
- ✅ Verifique se o VLC está instalado
- ✅ Verifique se o caminho está correto no `config.py`
- ✅ Execute manualmente: `python video_sync.py`

### **Problema: Vídeos não sincronizados**
- ✅ Delete `combined_video.mp4` e execute novamente
- ✅ Verifique se os vídeos de entrada existem
- ✅ Verifique se o FFmpeg está instalado

### **Problema: Tecla de atalho não funciona**
- ✅ Execute como administrador
- ✅ Verifique se não há conflitos com outros programas
- ✅ Teste com `Ctrl+Q` em vez de outras combinações

## 📋 Checklist de Produção

### **Antes de Deploy**
- [ ] Sistema testado em ambiente similar
- [ ] Vídeos preparados e testados
- [ ] Monitores configurados corretamente
- [ ] Dependências instaladas
- [ ] Logs configurados

### **Durante o Deploy**
- [ ] Backup do sistema atual
- [ ] Teste de reinicialização
- [ ] Verificação de logs
- [ ] Teste de tecla de atalho
- [ ] Verificação de performance

### **Após o Deploy**
- [ ] Monitoramento por 24h
- [ ] Verificação de logs
- [ ] Teste de reinicialização
- [ ] Documentação de problemas

## 🚨 Recuperação de Emergência

### **Sistema Travado**
1. Pressione `Ctrl+Alt+Del`
2. Abra o Gerenciador de Tarefas
3. Mate os processos `python.exe` e `vlc.exe`
4. Reinicie o sistema

### **Aplicação Não Inicia**
1. Verifique os logs
2. Execute manualmente: `python video_sync.py`
3. Verifique as dependências
4. Reinstale se necessário

### **Vídeos Não Aparecem**
1. Verifique se os monitores estão configurados
2. Teste com um vídeo simples
3. Verifique o VLC
4. Reinicie o sistema

---

**💡 Dica:** Para máxima estabilidade, use o **Serviço Windows** em produção e mantenha logs de monitoramento ativos.
