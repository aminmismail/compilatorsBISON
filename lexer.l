DIG [0-9]
INTEGER ([-]?{DIG}+)
REAL ({DIG}+)\.({DIG}+)
CHARACTER (\'{LETRA}\')
LETRA [a-zA-Z]
ID {LETRA}({LETRA}|{DIG})*
STR (\".*\")
INCR "++"
SOMA "+"
SUB "-"
MULT "*"
DIV "/"
ATRIB "="
IGUAL "=="
COMP (<|>|<\=|>\=)
DIF "!="
AND "&&"
OR "||"
NOT "!"
A_CHAVES "{"
F_CHAVES "}"
A_COLCHETES "["
F_COLCHETES "]"
A_PARENTESES "("
F_PARENTESES ")"
DOIS_PONTOS ":"
PONTO_VIRG ";"
VIRG ","
PONTO "."
INCLUDE ("#include"[ ]*<.+\.h>)

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "hashtable.h"
	#include "parser.tab.h"
    int line = 1;
%}

%%
	/*REGRAS*/
	/*Nao usar [x|y], usar (x|y) ou [xy]*/
	
(string) {
	return STRING;
}

(while) {
	return WHILE;
}

(for) {
	return FOR;
}

(if) {
	return IF;
}

(else) {
	return ELSE;
}

(char) {
	return CHAR;
}

(int) {
	printf("int\n");
	return INT;
}

(float) {
	return FLOAT;
}

(double) {
	return DOUBLE;
}

(void) {
	return VOID;
}

(return) {
	return RETURN;
}

({LETRA}({LETRA}|{DIG})*) {
	printf("id encontrado\n");
	if(strlen(yytext) > 20) printf("ERRO: Tamanho maximo de ID (20) excedido!\n");
	else{
		printf("Token: ID \"%s\"\n",yytext);
		insert(yytext, strlen(yytext), 0, line);
		yylval.symtab_item = lookup(yytext);
		return ID;
	}
}

{STR} 			 	{ return STR; }
{INTEGER}		 	{ yylval.int_val = atoi(yytext); return INTEGER; }
{REAL}			 	{ yylval.float_val = atof(yytext); return REAL; }
{CHARACTER}			{ yylval.char_val = yytext[0]; printf("%c\n", yylval.char_val); return CHARACTER; }
{INCLUDE}		 	{ return INCLUDE; }
{DIG}            	{ return DIG; }
{A_CHAVES}       	{ return A_CHAVES; }
{A_COLCHETES}    	{ return A_COLCHETES; }
{A_PARENTESES}   	{ return A_PARENTESES; }
{F_CHAVES}       	{ return F_CHAVES; }
{F_COLCHETES}    	{ return F_COLCHETES; }
{F_PARENTESES}   	{ return F_PARENTESES; }
{DOIS_PONTOS}       { return DOIS_PONTOS;}
{PONTO_VIRG}        { return PONTO_VIRG;}
{VIRG}              { return VIRG; }
{PONTO}             { return PONTO; }
{IGUAL}             { return IGUAL; }
{ATRIB}             { return ATRIB; }
{INCR}				{ return INCR; }
{SOMA}              { return SOMA; }
{SUB}               { return SUB; }
{MULT}              { return MULT; }
{DIV}               { return DIV; }
{AND}               { return AND; }
{OR}                { return OR; }
{NOT}               { return NOT;}
{COMP}              { return COMP; }

"\n" {++line;}

[ \t\r]+ {;}

. { printf("Token [%s] nao identificado na linha: %d\n", yytext, line);}

%%
int yywrap(){
	return 1;
}