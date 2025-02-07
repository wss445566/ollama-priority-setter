CC=g++
CFLAGS=-Wall -O2
LIBS=-lkernel32 -luser32 -lpsapi
SRC=src/main.c
OUT=ollama-priority-setter.exe

all: $(OUT)

$(OUT): $(SRC)
    $(CC) $(CFLAGS) $(SRC) $(LIBS) -o $(OUT)

clean:
    del $(OUT)