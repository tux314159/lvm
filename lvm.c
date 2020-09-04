#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "instructions.h"

#define MAX_STACK_SZ 10000
#define REGNO 10
#define MAX_PROG_LEN 10000

#define CHECK_STACK_U \
	if (stackptr == 0) {\
		fprintf(stderr, "STACK UNDERFLOW: ABORT\n"); \
		exit(1); \
	}

#define CHECK_STACK_O \
	if (stackptr >= MAX_STACK_SZ) { \
		fprintf(stderr, "STACK OVERFLOW: ABORT\n"); \
		exit(1); \
	}

#define CHECK_STACK_B CHECK_STACK_O CHECK_STACK_U

#define CHECK_REG(x) \
	if (x > REGNO) { \
		fprintf(stderr, "INVALID REGISTER: ABORT\n"); \
		exit(1); \
	}

struct instruction_s {
	enum impl_instr instr;
	long long arg1;
	long long arg2;
};

int main(void)
{
	long long plen;

	struct instruction_s pinstrs[MAX_PROG_LEN+5];
	long long reg[REGNO];
	long long vm_stack[MAX_STACK_SZ+5];
	size_t stackptr = 0;

	memset(pinstrs, 0, MAX_PROG_LEN * sizeof(struct instruction_s));
	memset(reg, 0, REGNO * sizeof(long long));
	memset(vm_stack, 0, MAX_STACK_SZ * sizeof(long long));

	/* Read input */
	scanf("%lld", &plen);
	for (int i = 0; i < plen; ++i) {
		scanf("%d", &pinstrs[i].instr);
		switch (pinstrs[i].instr) {
		case PUSH:
		case POPS:
		case STORE:
		case LOAD:
		case LSHFT:
		case RSHFT:
		case IFEQ:
		case IFNEQ:
		case IFZ:
		case IFNZ:
			scanf("%lld", &pinstrs[i].arg1);
			pinstrs[i].arg2 = 0;
			break;

		default:
			pinstrs[i].arg1 = 0;
			pinstrs[i].arg2 = 0;
			break;
		}
	}

	for (struct instruction_s *cinstr = pinstrs; cinstr < pinstrs+plen; cinstr++) {
		long long t = 0;
		long long t2 = 0;
		switch (cinstr->instr) {
		case NOP:
			break;

		/* Registers/stack */
		case PUSH:
			CHECK_STACK_O;
			vm_stack[stackptr++] = cinstr->arg1;
			break;
		case POP:
			CHECK_STACK_U;
			stackptr--;
			break;
		case POPS:
			CHECK_STACK_U;
			CHECK_REG(cinstr->arg1);
			reg[cinstr->arg1] = vm_stack[--stackptr];
			break;
		case STORE:
			CHECK_STACK_U;
			CHECK_REG(cinstr->arg1);
			reg[cinstr->arg1] = vm_stack[stackptr-1];
			break;
		case LOAD:
			CHECK_STACK_O;
			CHECK_REG(cinstr->arg1);
			vm_stack[stackptr++] = reg[cinstr->arg1];
			break;

		/* Arithmetic */
		case ADD:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = vm_stack[--stackptr] + t;
			vm_stack[stackptr++] = t2;
			break;
		case SUB:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = vm_stack[--stackptr] - t;
			vm_stack[stackptr++] = t2;
			break;
		case MUL:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 =  vm_stack[--stackptr] * t;
			vm_stack[stackptr++] = t2;
			break;
		case DIV:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = vm_stack[--stackptr] / t;
			vm_stack[stackptr++] = t2;
			break;
		case REM:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = t % vm_stack[--stackptr];
			vm_stack[stackptr++] = t2;
			break;

		/* Bitwise operators */
		case NOT:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			vm_stack[stackptr++] = ~t;
			break;
		case AND:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = t & vm_stack[--stackptr];
			vm_stack[stackptr++] = t2;
			break;
		case OR:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = t | vm_stack[--stackptr];
			vm_stack[stackptr++] = t2;
			break;
		case XOR:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = t ^ vm_stack[--stackptr];
			vm_stack[stackptr++] = t2;
			break;
		case LSHFT:
			CHECK_STACK_U;
			t = vm_stack[--stackptr] << cinstr->arg1;
			vm_stack[stackptr++] = t;
			break;
		case RSHFT:
			CHECK_STACK_U;
			t = vm_stack[--stackptr] >> cinstr->arg1;
			vm_stack[stackptr++] = t;
			break;

		/* Flow control */
		case IFEQ:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = vm_stack[--stackptr];
			if (t == t2)
				cinstr = pinstrs + cinstr->arg1 - 1;
			break;
		case IFNEQ:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			CHECK_STACK_U;
			t2 = vm_stack[--stackptr];
			if (t != t2)
				cinstr = pinstrs + cinstr->arg1 - 1;
			break;
		case IFZ:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			if (t == 0)
				cinstr = pinstrs + cinstr->arg1 - 1;
			break;
		case IFNZ:
			CHECK_STACK_U;
			t = vm_stack[--stackptr];
			if (t != 0)
				cinstr = pinstrs + cinstr->arg1 - 1;
			break;

		/* I/O */
		case PRINT:
			CHECK_STACK_U;
			printf("%lld\n", vm_stack[stackptr-1]);
			break;
		case POPP:
			CHECK_STACK_U;
			printf("%lld\n", vm_stack[--stackptr]);
			break;

		case DONE:
			exit(0);
			break;
		}
	}
}
