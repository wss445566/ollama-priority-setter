#include <windows.h>
#include <tlhelp32.h>

#define TARGET_PROCESS_NAME L"ollama.exe"
#define MUTEX_NAME L"MyUniqueMutexName_OnlyOneInstanceAllowed"

// 調整指定 PID 程序優先權為 IDLE，前提是優先權非 IDLE
void AdjustProcessPriorityIfNeeded(DWORD pid) {
    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_SET_INFORMATION, FALSE, pid);
    if (!hProcess) return;

    DWORD priority = GetPriorityClass(hProcess);
    if (priority != 0 && priority != IDLE_PRIORITY_CLASS) {
        SetPriorityClass(hProcess, IDLE_PRIORITY_CLASS);
    }

    CloseHandle(hProcess);
}

// 利用 Toolhelp API 掃描所有程序，針對目標程序調整優先權
void MonitorProcesses() {
    while (1) {
        HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (hSnapshot == INVALID_HANDLE_VALUE) {
            Sleep(1000);
            continue;
        }

        PROCESSENTRY32W pe;
        pe.dwSize = sizeof(pe);

        if (Process32FirstW(hSnapshot, &pe)) {
            do {
                // 利用 lstrcmpiW 進行忽略大小寫比較
                if (lstrcmpiW(pe.szExeFile, TARGET_PROCESS_NAME) == 0) {
                    AdjustProcessPriorityIfNeeded(pe.th32ProcessID);
                }
            } while (Process32NextW(hSnapshot, &pe));
        }

        CloseHandle(hSnapshot);
        Sleep(1000);
    }
}

int WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int) {
    // 建立命名互斥鎖確保單一實體，避免多開
    HANDLE hMutex = CreateMutexW(NULL, FALSE, MUTEX_NAME);
    if (hMutex == NULL) {
        return 1; // 建立失敗直接退出
    }
    if (GetLastError() == ERROR_ALREADY_EXISTS) {
        CloseHandle(hMutex);
        return 0; // 已有執行個體，直接退出
    }

    MonitorProcesses();

    CloseHandle(hMutex);
    return 0;
}
