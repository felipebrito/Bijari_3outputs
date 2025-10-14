# Teste FFmpeg Avançado - PowerShell
# Execute como: powershell -ExecutionPolicy Bypass -File testar_ffmpeg_ps.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TESTE FFMPEG AVANCADO (PowerShell)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path "ffmpeg.exe")) {
    Write-Host "✗ ffmpeg.exe não encontrado!" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

if (-not (Test-Path "Tela01.mp4")) {
    Write-Host "✗ Tela01.mp4 não encontrado!" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Testando diferentes abordagens do FFmpeg..." -ForegroundColor Yellow
Write-Host ""

# Teste 1: Comando original
Write-Host "[TESTE 1] Comando original (com rotação):" -ForegroundColor Green
$cmd1 = @(
    "ffmpeg.exe",
    "-i", "Tela01.mp4",
    "-i", "Tela02.mp4", 
    "-i", "Tela03.mp4",
    "-filter_complex", "[0:v]transpose=1,scale=1920:1080[v0];[1:v]transpose=1,scale=1920:1080[v1];[2:v]transpose=1,scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]",
    "-map", "[v]",
    "-c:v", "libx264",
    "-preset", "fast",
    "-crf", "23",
    "-y",
    "combined_video.mp4"
)

Write-Host "Comando: $($cmd1 -join ' ')" -ForegroundColor Gray
Write-Host ""

try {
    $result1 = & $cmd1[0] $cmd1[1..($cmd1.Length-1)] 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ TESTE 1 FUNCIONOU!" -ForegroundColor Green
        Write-Host ""
        if (Test-Path "combined_video.mp4") {
            $size = (Get-Item "combined_video.mp4").Length
            Write-Host "✓ Arquivo combined_video.mp4 criado! Tamanho: $([math]::Round($size/1MB, 2)) MB" -ForegroundColor Green
        }
    } else {
        Write-Host "✗ TESTE 1 FALHOU" -ForegroundColor Red
        Write-Host ""
        
        # Teste 2: Sem rotação
        Write-Host "[TESTE 2] Sem rotação (mais simples):" -ForegroundColor Green
        $cmd2 = @(
            "ffmpeg.exe",
            "-i", "Tela01.mp4",
            "-i", "Tela02.mp4", 
            "-i", "Tela03.mp4",
            "-filter_complex", "[0:v]scale=1920:1080[v0];[1:v]scale=1920:1080[v1];[2:v]scale=1920:1080[v2];[v0][v1][v2]hstack=inputs=3[v]",
            "-map", "[v]",
            "-c:v", "libx264",
            "-preset", "ultrafast",
            "-crf", "28",
            "-y",
            "combined_video.mp4"
        )
        
        Write-Host "Comando: $($cmd2 -join ' ')" -ForegroundColor Gray
        Write-Host ""
        
        try {
            $result2 = & $cmd2[0] $cmd2[1..($cmd2.Length-1)] 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ TESTE 2 FUNCIONOU!" -ForegroundColor Green
                Write-Host ""
                if (Test-Path "combined_video.mp4") {
                    $size = (Get-Item "combined_video.mp4").Length
                    Write-Host "✓ Arquivo combined_video.mp4 criado! Tamanho: $([math]::Round($size/1MB, 2)) MB" -ForegroundColor Green
                }
            } else {
                Write-Host "✗ TESTE 2 FALHOU" -ForegroundColor Red
                Write-Host ""
                
                # Teste 3: Mais simples ainda
                Write-Host "[TESTE 3] Comando mais simples ainda:" -ForegroundColor Green
                $cmd3 = @(
                    "ffmpeg.exe",
                    "-i", "Tela01.mp4",
                    "-i", "Tela02.mp4", 
                    "-i", "Tela03.mp4",
                    "-filter_complex", "[0:v][1:v][2:v]hstack=inputs=3[v]",
                    "-map", "[v]",
                    "-c:v", "libx264",
                    "-preset", "ultrafast",
                    "-y",
                    "combined_video.mp4"
                )
                
                Write-Host "Comando: $($cmd3 -join ' ')" -ForegroundColor Gray
                Write-Host ""
                
                try {
                    $result3 = & $cmd3[0] $cmd3[1..($cmd3.Length-1)] 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "✓ TESTE 3 FUNCIONOU!" -ForegroundColor Green
                        Write-Host ""
                        if (Test-Path "combined_video.mp4") {
                            $size = (Get-Item "combined_video.mp4").Length
                            Write-Host "✓ Arquivo combined_video.mp4 criado! Tamanho: $([math]::Round($size/1MB, 2)) MB" -ForegroundColor Green
                        }
                    } else {
                        Write-Host "✗ TODOS OS TESTES FALHARAM" -ForegroundColor Red
                        Write-Host "Possível problema com os vídeos ou FFmpeg" -ForegroundColor Yellow
                    }
                } catch {
                    Write-Host "✗ ERRO no TESTE 3: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        } catch {
            Write-Host "✗ ERRO no TESTE 2: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "✗ ERRO no TESTE 1: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
if (Test-Path "combined_video.mp4") {
    Write-Host "✓ Arquivo combined_video.mp4 criado!" -ForegroundColor Green
    $file = Get-Item "combined_video.mp4"
    Write-Host "Tamanho: $([math]::Round($file.Length/1MB, 2)) MB" -ForegroundColor Green
    Write-Host "Data: $($file.LastWriteTime)" -ForegroundColor Green
} else {
    Write-Host "✗ Arquivo combined_video.mp4 NÃO foi criado" -ForegroundColor Red
}

Write-Host ""
Read-Host "Pressione Enter para sair"
