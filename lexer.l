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
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "While" ,line);
	return WHILE;
}

(for) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "For" ,line);
	return FOR;
}

(if) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "If" ,line);
	return IF;
}

(else) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "Else" ,line);
	return ELSE;
}

(char) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "Char", line);
	return CHAR;
}

(int) {
	strcpy(yylval.nd_obj.name,(yytext));
	//yylval.type = INT_TYPE;
	insert(yytext, strlen(yytext), 7, "Int" ,line);
	return INT;
}

(float) {
	strcpy(yylval.nd_obj.name,(yytext));
	//yylval.type = REAL_TYPE;
	insert(yytext, strlen(yytext), 7, "Float", line);
	return FLOAT;
}

(double) {
	strcpy(yylval.nd_obj.name,(yytext));
	//yylval.type = REAL_TYPE;
	insert(yytext, strlen(yytext), 7, "Double", line);
	return DOUBLE;
}

(void) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "Void" ,line);
	return VOID;
}

(return) {
	strcpy(yylval.nd_obj.name,(yytext));
	insert(yytext, strlen(yytext), 7, "Return" ,line);
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
						insert(yytext, strlen(yytext), 3, "StringVar", line);
						return STR; }
{INTEGER}		 	{ strcpy(yylval.nd_obj.name,(yytext));
					  insert(yytext, strlen(yytext), 1, "IntVar",line);
					  yylval.nd_obj.type = INT_TYPE;
					  return INTEGER; }
{REAL}			 	{ strcpy(yylval.nd_obj.name,(yytext));
					  insert(yytext, strlen(yytext), 2, "RealVar",line);
					  yylval.nd_obj.type = REAL_TYPE;
					  return REAL; }
{CHARACTER}			{ strcpy(yylval.nd_obj.name,(yytext)); insert(yytext, strlen(yytext), 1, "CharVar" ,line); return CHARACTER; }
{INCLUDE}		 	{ insert(yytext, strlen(yytext), 0, "Header" ,line); strcpy(yylval.nd_obj.name,(yytext)); return INCLUDE; }
{A_CHAVES}       	{ insert(yytext, strlen(yytext), 0, "Chaves" ,line); return A_CHAVES; }
{A_COLCHETES}    	{ insert(yytext, strlen(yytext), 0, "Colchetes" ,line); return A_COLCHETES; }
{A_PARENTESES}   	{ insert(yytext, strlen(yytext), 0, "Parenteses" ,line); return A_PARENTESES; }
{F_CHAVES}       	{ insert(yytext, strlen(yytext), 0, "Chaves" ,line); return F_CHAVES; }
{F_COLCHETES}    	{ insert(yytext, strlen(yytext), 0, "Colchetes" ,line); return F_COLCHETES; }
{F_PARENTESES}   	{ insert(yytext, strlen(yytext), 0, "Parenteses" ,line); return F_PARENTESES; }
{DOIS_PONTOS}       { insert(yytext, strlen(yytext), 0, "DoisPontos" ,line); return DOIS_PONTOS;}
{PONTO_VIRG}        { insert(yytext, strlen(yytext), 0, "PontoVirgula" ,line); return PONTO_VIRG;}
{VIRG}              { insert(yytext, strlen(yytext), 0, "Virgula" ,line); return VIRG; }
{PONTO}             { insert(yytext, strlen(yytext), 0, "Ponto" ,line); return PONTO; }
{IGUAL}             { insert(yytext, strlen(yytext), 0, "TokIgualdade" ,line); return IGUAL; }
{ATRIB}             { insert(yytext, strlen(yytext), 0, "TokAtribuicao" ,line); return ATRIB; }
{INCR}				{ insert(yytext, strlen(yytext), 0, "Incremento" ,line); return INCR; }
{SOMA}              { insert(yytext, strlen(yytext), 0, "Mais" ,line); return SOMA; }
{SUB}               { insert(yytext, strlen(yytext), 0, "Menos" ,line); return SUB; }
{MULT}              { insert(yytext, strlen(yytext), 0, "Multiplicacao" ,line); return MULT; }
{DIV}               { insert(yytext, strlen(yytext), 0, "Divisao" ,line); return DIV; }
{AND}               { insert(yytext, strlen(yytext), 0, "And" ,line); return AND; }
{OR}                { insert(yytext, strlen(yytext), 0, "Or" ,line); return OR; }
{NOT}               { insert(yytext, strlen(yytext), 0, "Not" ,line); return NOT;}
{COMP}              { insert(yytext, strlen(yytext), 0, "Comparador" ,line); return COMP; }

"\n" {++line;}

[ \t\r]+ {;}

. { printf("Token [%s] nao identificado na linha: %d\n", yytext, line);}

%%
int yywrap(){
	return 1;
}
