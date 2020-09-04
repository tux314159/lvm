enum impl_instr {
	NOP = 0, /* no-op */

	/* Registers/stack */
	PUSH, /* push a constant */
	POP, /* pop from stack */
	POPS, /* pop from the stack into register no. (argument) */
	STORE, /* save to register no. (argument) */
	LOAD, /* push from register no. (argument) */

	/* Arithmetic */
	/* pop twice, do operation then push */
	ADD,
	SUB,
	MUL,
	DIV,
	REM, /* remainder */

	/* Bitwise operators */
	/* pop, do operation, then push */
	NOT,
	AND, /* pop twice */
	OR, /* pop twice */
	XOR, /* pop twice */
	LSHFT, /* pop once, shift popped by arg */
	RSHFT, /* pop once, shift popped by arg */

	/* Flow control */
	JMP, /* jump to line arg */
	IFEQ, /* pop twice, jump to line arg if equal */
	IFNEQ,
	IFZ, /* pop once, jump to line arg if zero */
	IFNZ,

	/* I/O */
	PRINT, /* print top of stack */
	POPP, /* print top of stack and pop */

	DONE
};
