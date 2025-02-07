CC=cl
CFLAGS=/W3 /O2 /EHsc
LIBS=user32.lib kernel32.lib
SRC=src\main.c
OUT=ollama-priority-setter.exe

all: $(OUT)

$(OUT): $(SRC)
    $(CC) $(CFLAGS) $(SRC) $(LIBS) /Fe:$(OUT)

clean:
    del $(OUT)