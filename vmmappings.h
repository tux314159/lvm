#define NOP	0

/* Registers/stack */
#define PUSH	1
#define POP	2
#define POPS	3
#define STORE	4
#define LOAD	5

/* Arithmetic */
#define ADD	6
#define SUB	7
#define MUL 	8
#define DIV 	9
#define REM 	10

/* Bitwise operators */
#define NOT 	11
#define AND 	12
#define OR 	13
#define XOR 	14
#define LSHFT 	15
#define RSHFT	16

/* Flow control */
#define JMP 	17
#define IFEQ 	18
#define IFNEQ 	19
#define IFZ 	20
#define IFNZ 	21

/* I/O */
#define PRINT 	22
#define PRINC 	23
#define POPP 	24
#define POPPC 	25

#define DONE 	26
