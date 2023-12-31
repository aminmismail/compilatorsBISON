DIG [0-9]
INTEGER ([-]?{DIG}+)
REAL ({DIG}+)\.({DIG}+)
CHARACTER (\'.\')
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
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "while" ,line);
	return WHILE;
}

(for) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "for" ,line);
	return FOR;
}

(if) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "if" ,line);
	return IF;
}

(else) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "else" ,line);
	return ELSE;
}

(char) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "char", line);
	return CHAR;
}

(int) {
	strcpy(yylval.nd_obj.name,(yytext));
	//yylval.type = INT_TYPE;
	insert(yytext, strlen(yytext), 7, "int" ,line);
	return INT;
}

(float) {
	strcpy(yylval.nd_obj.name,(yytext));
	//yylval.type = REAL_TYPE;
	insert(yytext, strlen(yytext), 7, "float", line);
	return FLOAT;
}

(double) {
	strcpy(yylval.nd_obj.name,(yytext));
	//yylval.type = REAL_TYPE;
	insert(yytext, strlen(yytext), 7, "double", line);
	return DOUBLE;
}

(void) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "void" ,line);
	return VOID;
}

(print) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "print" ,line);
	return PRINT;
}

(read) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "read" ,line);
	return READ;
}


(return) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "return" ,line);
	return RETURN;
}

({LETRA}({LETRA}|{DIG})*) {
	//printf("id encontrado\n");
	if(strlen(yytext) > 20) printf("ERRO: Tamanho maximo de ID (20) excedido!\n");
	else{
		//printf("Token: ID \"%s\"\n",yytext);
		strcpy(yylval.nd_obj.name,(yytext));
		insert(yytext, strlen(yytext), 0, "ID", line);
		yylval.nd_obj.symtab_item = lookup(yytext);
		return ID;
	}
}

{STR} 			 	{	strcpy(yylval.nd_obj.name,(yytext));
						yylval.nd_obj.type = STR_TYPE;
						insert(yytext, strlen(yytext), 3, "STR", line);
						return STR; }
{INTEGER}		 	{ strcpy(yylval.nd_obj.name,(yytext));
					  insert(yytext, strlen(yytext), 1, "INTEGER",line);
					  yylval.nd_obj.type = INT_TYPE;
					  return INTEGER; }
{REAL}			 	{ strcpy(yylval.nd_obj.name,(yytext));
					  insert(yytext, strlen(yytext), 2, "REAL",line);
					  yylval.nd_obj.type = REAL_TYPE;
					  return REAL; }
{CHARACTER}			{ strcpy(yylval.nd_obj.name,(yytext)); insert(yytext, strlen(yytext), 1, "CHARACTER" ,line); return CHARACTER; }
{INCLUDE}		 	{ insert(yytext, strlen(yytext), 0, "HEADER" ,line); strcpy(yylval.nd_obj.name,(yytext)); return INCLUDE; }
{A_CHAVES}       	{ insert(yytext, strlen(yytext), 0, "A_CHAVES" ,line); return A_CHAVES; }
{A_COLCHETES}    	{ insert(yytext, strlen(yytext), 0, "A_COLCHETES" ,line); return A_COLCHETES; }
{A_PARENTESES}   	{ insert(yytext, strlen(yytext), 0, "A_PARENTESES" ,line); return A_PARENTESES; }
{F_CHAVES}       	{ insert(yytext, strlen(yytext), 0, "F_CHAVES" ,line); return F_CHAVES; }
{F_COLCHETES}    	{ insert(yytext, strlen(yytext), 0, "F_COLCHETES" ,line); return F_COLCHETES; }
{F_PARENTESES}   	{ insert(yytext, strlen(yytext), 0, "F_PARENTESES" ,line); return F_PARENTESES; }
{DOIS_PONTOS}       { insert(yytext, strlen(yytext), 0, "DOIS_PONTOS" ,line); return DOIS_PONTOS;}
{PONTO_VIRG}        { insert(yytext, strlen(yytext), 0, "PONTO_VIRG" ,line); return PONTO_VIRG;}
{VIRG}              { insert(yytext, strlen(yytext), 0, "VIRG" ,line); return VIRG; }
{PONTO}             { insert(yytext, strlen(yytext), 0, "PONTO" ,line); return PONTO; }
{IGUAL}             { insert(yytext, strlen(yytext), 0, "IGUAL" ,line); return IGUAL; }
{ATRIB}             { insert(yytext, strlen(yytext), 0, "ATRIB" ,line); return ATRIB; }
{INCR}				{ insert(yytext, strlen(yytext), 0, "INCR" ,line); return INCR; }
{SOMA}              { insert(yytext, strlen(yytext), 0, "SOMA" ,line); return SOMA; }
{SUB}               { insert(yytext, strlen(yytext), 0, "SUB" ,line); return SUB; }
{MULT}              { insert(yytext, strlen(yytext), 0, "MULT" ,line); return MULT; }
{DIV}               { insert(yytext, strlen(yytext), 0, "DIV" ,line); return DIV; }
{AND}               { insert(yytext, strlen(yytext), 0, "AND" ,line); return AND; }
{OR}                { insert(yytext, strlen(yytext), 0, "OR" ,line); return OR; }
{NOT}               { insert(yytext, strlen(yytext), 0, "NOT" ,line); return NOT;}
{COMP}              { insert(yytext, strlen(yytext), 0, "COMP" ,line); return COMP; }

"\n" {++line;}

[ \t\r]+

. { printf("Token [%s] nao identificado na linha: %d\n", yytext, line);}

%%
int yywrap(){
	return 1;
}
