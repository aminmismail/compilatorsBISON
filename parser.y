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
    struct var_name { 
			char name[100]; 
			struct node* nd;
			int type;
			list_t* symtab_item;
		} nd_obj;
}

/* token definition */
%token <nd_obj> ID
%token <nd_obj> INCR DIG A_CHAVES A_COLCHETES A_PARENTESES F_CHAVES F_COLCHETES F_PARENTESES DOIS_PONTOS PONTO_VIRG VIRG PONTO IGUAL ATRIB SOMA SUB 
%token <nd_obj> MULT DIV AND OR NOT COMP IF ELSE FOR WHILE CHAR INT DOUBLE FLOAT VOID RETURN INCLUDE STRING
%token <nd_obj> 	 INTEGER
%token <nd_obj>   REAL
%token <nd_obj> 	 CHARACTER
%token <nd_obj>     STR

%right ATRIB
%left COMP
%left AND OR
%left SOMA SUB
%left MULT DIV
%right NOT

%type <nd_obj> var tipo 

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

def: tipo var {
	if(lookup($2.name)->st_type != 0){
		printf("Erro: Redefinicao na linha %d\n", line);
	}
	set_type($2.name, $1.type);
} PONTO_VIRG ;

tipo: INT 		{ $$.type = 1 ; } 
	| CHAR  	{ $$.type = 1 ; }
	| FLOAT 	{ $$.type = 2 ; }
	| DOUBLE 	{ $$.type = 2 ; }
	| STRING	{ $$.type = 3 ; }
	| VOID;

var: ID { strcpy($$.name, $1.name);};

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
	CHAR | 
	STR
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