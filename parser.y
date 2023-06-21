%{
	#include "hashtable.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int line;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE*/
%union{
    char char_val;
	int int_val;
	float float_val;
	char* str_val;
	list_t* symtab_item;
}

/* token definition */
%token <symtab_item> ID
%token <int_val> INCR DIG A_CHAVES A_COLCHETES A_PARENTESES F_CHAVES F_COLCHETES F_PARENTESES DOIS_PONTOS PONTO_VIRG VIRG PONTO IGUAL ATRIB SOMA SUB 
%token <int_val> MULT DIV AND OR NOT COMP IF ELSE FOR WHILE CHAR INT DOUBLE FLOAT VOID RETURN INCLUDE STRING
%token <int_val> 	 INTEGER
%token <float_val>   REAL
%token <char_val> 	 CHARACTER
%token <str_val>     STR

%right ATRIB
%left COMP
%left AND OR
%left SOMA SUB
%left MULT DIV
%right NOT

%start programa

/* exp priorities and rules */

%%

programa: headers main ;

main: tipo ID A_PARENTESES F_PARENTESES A_CHAVES mainfun F_CHAVES ;

mainfun: defs decls RETURN ID PONTO_VIRG

headers: headers headers
	| INCLUDE;

defs: defs def
	| def;

def: tipo vars PONTO_VIRG ;

tipo: INT 
	| CHAR 
	| FLOAT 
	| DOUBLE 
	| VOID;

vars: var 
	| vars VIRG var;

var: ID;

decls: decls decl 
	| decl;

decl: if_decl
	| for_decl
	| while_decl
	| atribuicao
	| RETURN PONTO_VIRG
;

if_decl: IF A_PARENTESES exp F_PARENTESES corpo else_part ;

else_part: ELSE corpo 
	| /* vazio */ ; 

for_decl: FOR A_PARENTESES exp PONTO_VIRG exp PONTO_VIRG exp F_PARENTESES corpo ;

while_decl: WHILE A_PARENTESES exp F_PARENTESES corpo ;

corpo: decl PONTO_VIRG 
	| A_CHAVES decls F_CHAVES ;

exp:
    exp SOMA exp |
    exp MULT exp |
    exp DIV exp |
    exp INCR |
    INCR exp |
    exp OR exp |
    exp AND exp |
    NOT exp |
    exp IGUAL exp |
    exp COMP exp |
    A_PARENTESES exp F_PARENTESES |
    var |
	constval
;

constval:
	INTEGER |
	REAL |
	CHAR
;


atribuicao: var ATRIB exp PONTO_VIRG ; 

%%

void yyerror ()
{
  fprintf(stderr, "Erro de sintaxe na linha %d\n", line);
}

int main(int argc, char *argv[]) {
 init_hash_table();
 yyin = fopen(argv[1], "r");
 if(yyin != NULL){
 	yyparse();
 	fclose(yyin);
 	yyout = fopen("symtab_dump.txt", "w");
	symtab_dump(yyout);
 	fclose(yyout);
 }
 else printf("Execute com um arquivo! Exemplo: a.exe nomedoarquivo.txt\n");
 return 0;
}