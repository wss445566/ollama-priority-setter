# OllamaIdleAdjuster (使用 uv 管理環境)

本專案用於監控並將系統中 `ollama.exe` 程序優先權調整為閒置，降低系統資源佔用。

## Clone 後快速開始

1. 進入專案資料夾：`cd your-project-folder`
2. 執行程式：`uv run src/main.py`

## 重要說明

- 第一次執行時，uv 會自動建立虛擬環境並安裝依賴。
- 建議以管理員權限執行，確保可調整程序優先權。
- `.venv` 資料夾會被忽略，不會提交到版本庫。
