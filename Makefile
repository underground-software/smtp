CC = clang
CFLAGS = -std=c2x -Weverything -Wno-unsafe-buffer-usage -Wno-c++98-compat -Wno-gnu-designator \
	-Wno-initializer-overrides -Wno-declaration-after-statement -Wno-four-char-constants \
	-Wno-pre-c2x-compat -D_GNU_SOURCE
#CFLAGS += -DDEBUG -Og -g

.PHONY: all clean

all: smtp

smtp: smtp.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	-rm smtp



