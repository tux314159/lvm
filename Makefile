CC = gcc
CFLAGS = -g -o $@

lvm : lvm.c

% : %.c
	$(CC) $(CFLAGS) $^
