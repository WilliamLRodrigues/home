#SingleInstance force
#Persistent

SetTimer, CloseApplications, 1000  ; Verifica a cada 1 segundo

CloseApplications:
    ; Verifica se o Gerenciador de Tarefas está aberto e fecha
    IfWinExist, ahk_class TaskManagerWindow
    {
        WinClose  ; Fecha o Gerenciador de Tarefas
    }

    ; Verifica se o Microsoft Teams está aberto e fecha
    IfWinExist, ahk_class TeamsWindowClass
    {
        WinClose  ; Fecha o Microsoft Teams
    }

    ; Verifica se o Cisco AnyConnect VPN está aberto e fecha
    IfWinExist, ahk_class Cisco AnyConnect Secure Mobility Client
    {
        WinClose  ; Fecha o Cisco AnyConnect VPN
    }
return

; --- MOVE O MOUSE 1 PIXEL A CADA 3 MINUTOS ---
SetTimer, MoveMouseOnePixel, 180000  ; Define um timer para mover o mouse a cada 3 Minutos

MoveMouseOnePixel:
    MouseMove, 1, 0, 0, R  ; Move o mouse 1 pixel para a direita (movimento relativo)
    Sleep, 50
    MouseMove, -1, 0, 0, R  ; Move o mouse 1 pixel para a esquerda (volta à posição original)
return

; --- REUTILIZAÇÃO DAS TECLAS WINDOWS PARA ABRIR O ARQUIVO INDEX.HTML ---
LWin::
RWin::
    Run, C:\Toten\index.html  ; Abre o arquivo HTML local
return

; --- BLOQUEIO PERMANENTE DA TECLA TAB ---
Tab::Return  ; Desativa a tecla TAB permanentemente

; --- BLOQUEIO DO ATALHO ALT + TAB ---
!Tab::Return  ; Desativa Alt + Tab

; --- BLOQUEIO TEMPORÁRIO DA TECLA F5 E SIMULA F4 100 MILISEGUNDOS DEPOIS ---
F5::
    if (blockF5Active and !blockF5)  ; Verifica se o bloqueio está ativo e se F5 não está bloqueada
    {
        Send {F5}  ; F5 é pressionada normalmente
        blockF5 := true               ; Ativa o bloqueio de F5
        SetTimer, SimulateF4, -100    ; Simula F4 após 100 milissegundos
        SetTimer, ReactivateF5, -13000  ; Mantém F5 bloqueada por 13 segundos
        KeyPressCount := 0  ; Redefine o contador de teclas pressionadas
        InputMonitor()  ; Monitora as teclas após F4
        return
    }
    else if (blockF5)  ; Se F5 estiver bloqueada, ignora o pressionamento
    {
        return
    }
return

SimulateF4:
    Send {F4}  ; Simula o pressionamento de F4
return

ReactivateF5:
    blockF5 := false  ; Desbloqueia F5 após 13 segundos
return

; --- ATALHOS PARA ATIVAR/DESATIVAR BLOQUEIO DE F5 ---
^+h::  ; Ctrl + Shift + H: Ativa o bloqueio temporário de F5
    blockF5Active := true
    MsgBox, Bloqueio temporário de F5 ativado.
return

^+s::  ; Ctrl + Shift + S: Desativa o bloqueio temporário de F5
    blockF5Active := false
    blockF5 := false  ; Garante que a tecla F5 volte a funcionar
    MsgBox, Bloqueio temporário de F5 desativado.
return

; --- MONITOR DE TECLAS APÓS F4 (TOCA ÁUDIO NA SEXTA TECLA) ---
InputMonitor() {
    global KeyPressCount
    Input, KeyPressed, L1 M  ; Aguarda por uma tecla pressionada
    KeyPressCount++  ; Incrementa o contador de teclas pressionadas
    if (KeyPressCount = 6)  ; Verifica se é a sexta tecla pressionada
    {
        SoundPlay, C:\Toten\bemvindo.mp3  ; Toca o arquivo de áudio
        KeyPressCount := 0  ; Redefine o contador para o próximo ciclo
    }
    InputMonitor()  ; Continua monitorando as teclas
}

; --- ENCERRAR O PROCESSO EXPLORER PARA OCULTAR A BARRA DE TAREFAS ---
HideTaskbar:
    Run, taskkill /f /im explorer.exe
return

ShowTaskbar:
    Run, explorer.exe
return

; Atalho para ocultar a barra de tarefas (Ctrl + Alt + H)
^!h::
    GoSub, HideTaskbar
return

; Atalho para restaurar a barra de tarefas (Ctrl + Alt + S)
^!s::
    GoSub, ShowTaskbar
return

; Inicialmente, desativa o bloqueio de F5 e oculta a barra de tarefas
blockF5Active := false
GoSub, HideTaskbar
