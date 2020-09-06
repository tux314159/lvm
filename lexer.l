%{
#include "instructions.h"

enum yytokentype {
	INSTRUCTION = 258,
	ARG_NUM,
	ARG_CHAR,
	NO_INSTR,
	MAL_CHAR
};

union {
	enum impl_instr instr;
	short regno;
	long long arg_num;
	char arg_char;
} yylval;

%}

%option noyywrap

%%

^(?i:NOP)		{ yylval.instr = NOP; return INSTRUCTION; }

^(?i:PUSH)		{ yylval.instr = PUSH; return INSTRUCTION; }
^(?i:POP)		{ yylval.instr = POP; return INSTRUCTION; }
^(?i:POPS)		{ yylval.instr = POPS; return INSTRUCTION; }
^(?i:STORE)		{ yylval.instr = STORE; return INSTRUCTION; }
^(?i:LOAD)		{ yylval.instr = LOAD; return INSTRUCTION; }

^(?i:ADD)		{ yylval.instr = ADD; return INSTRUCTION; }
^(?i:SUB)		{ yylval.instr = SUB; return INSTRUCTION; }
^(?i:MUL)		{ yylval.instr = MUL; return INSTRUCTION; }
^(?i:DIV)		{ yylval.instr = DIV; return INSTRUCTION; }
^(?i:REM)		{ yylval.instr = REM; return INSTRUCTION; }

^(?i:NOT)		{ yylval.instr = NOT; return INSTRUCTION; }
^(?i:AND)		{ yylval.instr = AND; return INSTRUCTION; }
^(?i:OR)		{ yylval.instr = OR; return INSTRUCTION; }
^(?i:XOR)		{ yylval.instr = XOR; return INSTRUCTION; }
^(?i:LSHFT)		{ yylval.instr = LSHFT; return INSTRUCTION; }
^(?i:RSHFT)		{ yylval.instr = RSHFT; return INSTRUCTION; }

^(?i:JMP)		{ yylval.instr = JMP; return INSTRUCTION; }
^(?i:IFEQ)		{ yylval.instr = IFEQ; return INSTRUCTION; }
^(?i:IFNEQ)		{ yylval.instr = IFNEQ; return INSTRUCTION; }
^(?i:IFZ)		{ yylval.instr = IFZ; return INSTRUCTION; }
^(?i:IFNZ)		{ yylval.instr = IFNZ; return INSTRUCTION; }

^(?i:PRINT)		{ yylval.instr = PRINT; return INSTRUCTION; }
^(?i:PRINC)		{ yylval.instr = PRINC; return INSTRUCTION; }
^(?i:POPP)		{ yylval.instr = POPP; return INSTRUCTION; }
^(?i:POPPC)		{ yylval.instr = POPPC; return INSTRUCTION; }

^(?i:DONE)		{ yylval.instr = DONE; return INSTRUCTION; }

[0-9]+			{ yylval.arg_num = atoi(yytext); return ARG_NUM; }
\'.\'			{ yylval.arg_char = yytext[1]; return ARG_CHAR; }

[ \t]			{ }

\'.{2,}\'		{ return MAL_CHAR; }
\'\'			{ return MAL_CHAR; }

[a-zA-Z]*		{ return NO_INSTR; }

%%

int main(int argc, char **argv)
{
	int tok;
	while (tok = yylex()) {
		printf("%d", tok);
		switch (tok) {
		case INSTRUCTION:
			printf(" [instruction]");
			break;
		case ARG_NUM:
			printf(" [numerical argument: %lld]", yylval.arg_num);
			break;
		case ARG_CHAR:
			printf(" [character argument: %c]", yylval.arg_char);
			break;
		case NO_INSTR:
			printf(" [no such instruction]");
			break;
		case MAL_CHAR:
			printf(" [bad character]");
			break;

		default:
			break;
		}
		printf("\n");
	}
	return 0;
}
