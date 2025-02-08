.386
.model flat, stdcall
option casemap :none

include windows.inc
include kernel32.inc
include user32.inc
include psapi.inc
include shell32.inc
include gdi32.inc

includelib kernel32.lib
includelib user32.lib
includelib psapi.lib
includelib shell32.lib
includelib gdi32.lib

.data
    CLASS_NAME db "OllamaPrioritySetterClass", 0
    WINDOW_NAME db "ollama priority setter", 0
    nid NOTIFYICONDATA <>
    msg MSG <>
    hwnd dd ?

.code
WinMain proc
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ; Initialize window class
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WindowProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov wc.hInstance, hInstance
    mov wc.hIcon, NULL
    mov wc.hCursor, NULL
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, offset CLASS_NAME
    invoke RegisterClass, addr wc

    ; Create window
    invoke CreateWindowEx, WS_EX_TOOLWINDOW, addr CLASS_NAME, addr WINDOW_NAME, WS_POPUP, 0, 0, 0, 0, NULL, NULL, hInstance, NULL
    mov hwnd, eax

    ; Show window
    invoke ShowWindow, hwnd, SW_HIDE

    ; Message loop
message_loop:
    invoke GetMessage, addr msg, NULL, 0, 0
    cmp eax, 0
    je exit
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
    jmp message_loop

exit:
    invoke PostQuitMessage, 0
    ret
WinMain endp

WindowProc proc hwnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_CREATE
        ; Set timer
        invoke SetTimer, hwnd, ID_TIMER, 1000, NULL

        ; Initialize NOTIFYICONDATA
        mov nid.cbSize, sizeof NOTIFYICONDATA
        mov nid.hWnd, hwnd
        mov nid.uID, ID_TRAY_APP_ICON
        mov nid.uFlags, NIF_ICON or NIF_MESSAGE or NIF_TIP
        mov nid.uCallbackMessage, WM_TRAYICON
        invoke LoadIcon, NULL, IDI_APPLICATION
        mov nid.hIcon, eax
        invoke lstrcpy, addr nid.szTip, addr WINDOW_NAME
        invoke Shell_NotifyIcon, NIM_ADD, addr nid

        ; Set process priority
        invoke GetCurrentProcess
        invoke SetPriorityClass, eax, ABOVE_NORMAL_PRIORITY_CLASS

    .elseif uMsg == WM_TIMER
        ; Check process priority
        invoke SetProcessPriorityToIdle, addr processName

    .elseif uMsg == WM_TRAYICON
        ; Handle tray icon events
        .if lParam == WM_RBUTTONUP
            invoke GetCursorPos, addr pt
            invoke CreatePopupMenu
            invoke InsertMenu, eax, 0, MF_BYPOSITION or MF_STRING, ID_TRAY_EXIT, addr exitText
            invoke SetForegroundWindow, hwnd
            invoke TrackPopupMenu, eax, TPM_BOTTOMALIGN or TPM_LEFTALIGN, pt.x, pt.y, 0, hwnd, NULL
            invoke DestroyMenu, eax
        .endif

    .elseif uMsg == WM_COMMAND
        ; Handle commands
        .if wParam == ID_TRAY_EXIT
            invoke PostQuitMessage, 0
        .endif

    .elseif uMsg == WM_DESTROY
        ; Clean up
        invoke KillTimer, hwnd, ID_TIMER
        invoke Shell_NotifyIcon, NIM_DELETE, addr nid
        invoke PostQuitMessage, 0
        xor eax, eax
        ret

    .else
        invoke DefWindowProc, hwnd, uMsg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
WindowProc endp

SetProcessPriorityToIdle proc processName:LPSTR
    ; Function to set process priority to idle
    invoke CreateToolhelp32Snapshot, TH32CS_SNAPPROCESS, 0
    cmp eax, INVALID_HANDLE_VALUE
    je exit
    mov ebx, eax
    mov pe.dwSize, sizeof PROCESSENTRY32
    invoke Process32First, ebx, addr pe
    test eax, eax
    jz close_handle

process_loop:
    invoke lstrcmpi, addr pe.szExeFile, processName
    test eax, eax
    jnz next_process
    invoke OpenProcess, PROCESS_QUERY_INFORMATION or PROCESS_SET_INFORMATION, FALSE, pe.th32ProcessID
    test eax, eax
    jz next_process
    mov esi, eax
    invoke GetPriorityClass, esi
    cmp eax, IDLE_PRIORITY_CLASS
    je close_process
    invoke SetPriorityClass, esi, IDLE_PRIORITY_CLASS

close_process:
    invoke CloseHandle, esi

next_process:
    invoke Process32Next, ebx, addr pe
    test eax, eax
    jnz process_loop

close_handle:
    invoke CloseHandle, ebx

exit:
    ret
SetProcessPriorityToIdle endp

end WinMain