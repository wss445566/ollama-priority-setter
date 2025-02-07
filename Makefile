CC=gcc
CFLAGS=-Wall -Wextra -O2
LIBS=-luser32 -lkernel32
SRC=src/main.c
OUT=ollama-priority-setter

all: $(OUT)

$(OUT): $(SRC)
    $(CC) $(CFLAGS) $(SRC) $(LIBS) -o $(OUT)

clean:
    rm -f $(OUT)