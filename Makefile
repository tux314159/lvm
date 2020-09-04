lvm : lvm.c

% : %.c
	$(CC) $(CFLAGS) -g -o $@ $^
