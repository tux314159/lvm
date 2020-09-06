%{
#include "instructions.h"

enum yytokentype {
	INSTRUCTION = 258,
	ARG_NUM,
	ARG_CHAR,
	NO_INSTR,
	MAL_CHAR,
	BAD_SYN
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

^(?i:NOP)[ \t\n]	{ yylval.instr = NOP; return INSTRUCTION; }

^(?i:PUSH)[ \t\n]	{ yylval.instr = PUSH; return INSTRUCTION; }
^(?i:POP)[ \t\n]	{ yylval.instr = POP; return INSTRUCTION; }
^(?i:POPS)[ \t\n]	{ yylval.instr = POPS; return INSTRUCTION; }
^(?i:STORE)[ \t\n]	{ yylval.instr = STORE; return INSTRUCTION; }
^(?i:LOAD)[ \t\n]	{ yylval.instr = LOAD; return INSTRUCTION; }

^(?i:ADD)[ \t\n]	{ yylval.instr = ADD; return INSTRUCTION; }
^(?i:SUB)[ \t\n]	{ yylval.instr = SUB; return INSTRUCTION; }
^(?i:MUL)[ \t\n]	{ yylval.instr = MUL; return INSTRUCTION; }
^(?i:DIV)[ \t\n]	{ yylval.instr = DIV; return INSTRUCTION; }
^(?i:REM)[ \t\n]	{ yylval.instr = REM; return INSTRUCTION; }

^(?i:NOT)[ \t\n]	{ yylval.instr = NOT; return INSTRUCTION; }
^(?i:AND)[ \t\n]	{ yylval.instr = AND; return INSTRUCTION; }
^(?i:OR)[ \t\n]		{ yylval.instr = OR; return INSTRUCTION; }
^(?i:XOR)[ \t\n]	{ yylval.instr = XOR; return INSTRUCTION; }
^(?i:LSHFT)[ \t\n]	{ yylval.instr = LSHFT; return INSTRUCTION; }
^(?i:RSHFT)[ \t\n]	{ yylval.instr = RSHFT; return INSTRUCTION; }

^(?i:JMP)[ \t\n]	{ yylval.instr = JMP; return INSTRUCTION; }
^(?i:IFEQ)[ \t\n]	{ yylval.instr = IFEQ; return INSTRUCTION; }
^(?i:IFNEQ)[ \t\n]	{ yylval.instr = IFNEQ; return INSTRUCTION; }
^(?i:IFZ)[ \t\n]	{ yylval.instr = IFZ; return INSTRUCTION; }
^(?i:IFNZ)[ \t\n]	{ yylval.instr = IFNZ; return INSTRUCTION; }

^(?i:PRINT)[ \t\n]	{ yylval.instr = PRINT; return INSTRUCTION; }
^(?i:PRINC)[ \t\n]	{ yylval.instr = PRINC; return INSTRUCTION; }
^(?i:POPP)[ \t\n]	{ yylval.instr = POPP; return INSTRUCTION; }
^(?i:POPPC)[ \t\n]	{ yylval.instr = POPPC; return INSTRUCTION; }

^(?i:DONE)[ \t\n]	{ yylval.instr = DONE; return INSTRUCTION; }

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

		case MAL_CHAR:
			printf(" [bad character]");
			break;
		case BAD_SYN:
			printf(" [bad syntax]");
			break;
		default:
			break;
		}
		printf("\n");
	}
	return 0;
}
