DIGITO [0-9]
LETRA [a-zA-Z]
IDENTIFICADOR (LETRA)([LETRA]|[DIGITO])*
STRING (\".*\")
SOMA "+"
SUB "-"
MULT "*"
DIV "/"
ATRIB "="
IGUAL "=="
COMPARADOR (<|>|<\=|>\=)
DIF "!="
AND "&&"
OR "||"
NOT "!"
ABRE_CHAVES "{"
FECHA_CHAVES "}"
ABRE_COLCHETES "["
FECHA_COLCHETES "]"
ABRE_PARENTESES "("
FECHA_PARENTESES ")"
DOIS_PONTOS ":"
PONTO_VIRG ";"
VIRG ","
PONTO "."

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "hashtable.h"
    int line = 1;
%}

%%
	/*REGRAS*/
	/*Nao usar [x|y], usar (x|y) ou [xy]*/

{STRING} { return STRING; }

(while) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

(for) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

(if) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

(else) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

(char|int|float|double|void) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

(return) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

(signed|unsigned|short|long) {
	printf("Token: Palavra reservada -> %s\n",yytext);
	insert(yytext, strlen(yytext), 0, line);
}

{LETRA}({LETRA}|{DIGITO})* {
	if(strlen(yytext) > 20) printf("ERRO: Tamanho maximo de identificador (20) excedido!\n");
	else{
		printf("Token: Identificador \"%s\"\n",yytext);
		insert(yytext, strlen(yytext), 0, line);
		return ID;
	}
}

{DIGITO}            { return DIGITO; }
{ABRE_CHAVES}       { return ABRE_CHAVES; }
{ABRE_COLCHETES}    { return ABRE_COLCHETES; }
{ABRE_PARENTESES}   { return ABRE_PARENTESES; }
{FECHA_CHAVES}      { return FECHA_CHAVES; }
{FECHA_COLCHETES}   { return FECHA_COLCHETES; }
{FECHA_PARENTESES}  { return FECHA_PARENTESES; }
{DOIS_PONTOS}       { return DOIS_PONTOS;}
{PONTO_VIRG}        { return PONTO_VIRG;}
{VIRG}              { return VIRG;}
{PONTO}             { return PONTO;}
{IGUAL}             { return IGUAL;}
{ATRIB}             { return ATRIB;}
{SOMA}              { return SOMA;}
{SUB}               { return SUB;}
{MULT}              { return MULT;}
{DIV}               { return DIV;}
{AND}               { return AND;}
{OR}                { return OR;}
{NOT}               { return NOT;}
{COMPARADOR}             { return COMPARADOR; }

"\n" {++line;}

[ \t\r\f]+

. { printf("Token [%s] nao identificado na linha: %d\n", yytext, line);}

%%
int yywrap(){
	return 1;
}

int main(int argc, char *argv[]) {
 init_hash_table();
 yyin = fopen(argv[1], "r");
 if(yyin != NULL){
 	yylex();
 	fclose(yyin);
 	yyout = fopen("symtab_dump.txt", "w");
	symtab_dump(yyout);
 	fclose(yyout);
 }
 else printf("Execute com um arquivo! Exemplo: a.exe nomedoarquivo.txt\n");
 return 0;
}