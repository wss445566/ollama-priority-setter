CC=gcc
CFLAGS=-mwindows -Wall
SRC=src/main.c
OUT=process_monitor.exe

all: $(OUT)

$(OUT): $(SRC)
	$(CC) $(CFLAGS) -o $(OUT) $(SRC)

clean:
	del $(OUT)