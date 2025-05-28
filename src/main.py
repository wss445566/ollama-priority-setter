import psutil
import time

def monitor_and_adjust(target_name='ollama.exe'):
    """
    監控所有程序，將名稱符合 target_name（忽略大小寫）的程序優先權設為閒置（IDLE），
    若優先權已是閒置則不做動作。
    """
    while True:
        for proc in psutil.process_iter(['name', 'nice']):
            try:
                if proc.info['name'] and proc.info['name'].lower() == target_name:
                    if proc.nice() != psutil.IDLE_PRIORITY_CLASS:
                        proc.nice(psutil.IDLE_PRIORITY_CLASS)
            except (psutil.NoSuchProcess, psutil.AccessDenied):
                # 程序不存在或無權限存取，忽略
                pass
        time.sleep(1)

if __name__ == "__main__":
    monitor_and_adjust()
