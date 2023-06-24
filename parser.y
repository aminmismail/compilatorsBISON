%{
	#include "hashtable.h"
	#include "ast.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int line;
	extern int yylex();
	void yyerror();

	struct node* head;
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
%token <nd_obj> INTEGER
%token <nd_obj> REAL
%token <nd_obj> CHARACTER
%token <nd_obj> STR

%right ATRIB
%left COMP
%left AND OR
%left SOMA SUB
%left MULT DIV
%right NOT

%type <nd_obj> programa main retorno mainfun headers defs tipo var decls decl if_decl else_part for_decl while_decl corpo exp constval atribuicao def

%start programa

/* exp priorities and rules */

%%

programa: headers main {
	$$.nd = mknode($1.nd, $2.nd, "programa");
	head = $$.nd;
};

main: tipo var A_PARENTESES F_PARENTESES A_CHAVES mainfun retorno F_CHAVES {
	$$.nd = mknode($6.nd, $7.nd, $2.name);
}

retorno: RETURN exp PONTO_VIRG{
	$$.nd = mknode(NULL, $2.nd, "return");
}

mainfun: defs decls {
	$$.nd = mknode($1.nd, $2.nd, "mainfun");
}

headers: headers headers { $$.nd = mknode($1.nd, $2.nd, "headers"); }
	| INCLUDE { $$.nd = mknode(NULL, NULL, $1.name); };

defs: defs def 	{ $$.nd = mknode($1.nd, $2.nd, "defs"); }
	| def		{ $$.nd = mknode($1.nd, NULL, "def"); } 

def: tipo var PONTO_VIRG {
	if(lookup($2.name)->st_type != 0){
		printf("Erro: Redefinicao na linha %d\n", line);
	}
	set_type($2.name, $1.type);
	$$.nd = mknode($1.nd, $2.nd, "definicao");
} ;

tipo: INT 		{ $$.type = 1 ; $$.nd = mknode(NULL, NULL, "int"); } 
	| CHAR  	{ $$.type = 1 ; $$.nd = mknode(NULL, NULL, "char"); }
	| FLOAT 	{ $$.type = 2 ; $$.nd = mknode(NULL, NULL, "float"); }
	| DOUBLE 	{ $$.type = 2 ; $$.nd = mknode(NULL, NULL, "double"); }
	| STRING	{ $$.type = 3 ; $$.nd = mknode(NULL, NULL, "string"); };

var: ID { 
	$$.nd = mknode(NULL, NULL, $1.name);
};

decls: decls decl 	{ $$.nd = mknode($1.nd, $2.nd, "decls"); }
	| decl			{ $$.nd = mknode($1.nd, NULL, "decl"); }

decl: if_decl else_part	{ $$.nd = mknode($1.nd, $2.nd, "if_decl"); }
	| for_decl			{ $$.nd = mknode($1.nd, NULL, "for_decl"); }
	| while_decl		{ $$.nd = mknode($1.nd, NULL, "while_decl"); }
	| atribuicao		{ $$.nd = mknode($1.nd, NULL, "atrib_decl"); };
;

if_decl: IF A_PARENTESES exp F_PARENTESES corpo { $$.nd = mknode($3.nd, $5.nd, "if"); } ;

else_part: ELSE corpo 							{ $$.nd = mknode($1.nd, NULL, "else"); }
	| /* vazio */ 	 							{ $$.nd = NULL; } ;

for_decl: FOR A_PARENTESES atribuicao exp PONTO_VIRG exp F_PARENTESES corpo {
	struct node* conds = mknode($4.nd,$6.nd,"conds");
	struct node* inicio = mknode($3.nd, NULL, "inicio");
	struct node* fornode = mknode(inicio, conds, "forhead");
	$$.nd = mknode(fornode, $8.nd, "for");
} ;

while_decl: WHILE A_PARENTESES exp F_PARENTESES corpo {
	$$.nd = mknode($3.nd, $5.nd, "while");
} ;

corpo: decl  						{ $$.nd = mknode($1.nd, NULL, "corpo_decl_unic"); }
	| A_CHAVES decls F_CHAVES		{ $$.nd = mknode($2.nd, NULL, "corpo_mult_decls"); } ;

exp:
    exp SOMA exp {
		if(($1.type == 1 || 4) && ($3.type == 1 || $3.type == 4)){
			$$.type = 1;
			$$.nd = mknode($1.nd, $3.nd, "+");
		}
		else if(($1.type == 1 || $1.type == 2) && ($3.type == 1 || $3.type == 2)){
			$$.type = 2;
			$$.nd = mknode($1.nd, $3.nd, "+");
		}
		else{
			printf("Tipo incompativel em expressao na linha %d\n", line);
			$$.nd = mkerrnode($1.nd, $3.nd);
		}
	} |
    exp MULT exp 	{
		if(($1.type == 1 ) && $3.type == 1){
			$$.type = 1;
			$$.nd = mknode($1.nd, $3.nd, "*");
		}
		else if(($1.type == 1 || $1.type == 2) && ($3.type == 1 || $3.type == 2)){
			$$.type = 2;
			$$.nd = mknode($1.nd, $3.nd, "*");
		}
		else{
			printf("Tipo incompativel em expressao na linha %d\n", line);
			$$.nd = mkerrnode($1.nd, $3.nd);
		}
		$$.nd = mknode($1.nd, $3.nd, "*")
	} |
    exp DIV exp  	{$$.nd = mknode($1.nd, $3.nd, "/")}		|
    exp INCR 	 	{ $$.nd = mknode($1.nd, NULL, "++")}	|
    INCR exp     	{$$.nd = mknode(NULL, $1.nd, "++")}		|
    exp OR exp 	 	{$$.nd = mknode($1.nd, $3.nd, "||")}	|
    exp AND exp 	{$$.nd = mknode($1.nd, $3.nd, "&&")}	|
    NOT exp 		{$$.nd = mknode(NULL, $2.nd, "!")}		|
    exp IGUAL exp 	{$$.nd = mknode($1.nd, $3.nd, "==")}	|
    exp COMP exp 	{$$.nd = mknode($1.nd, $3.nd, "comp")}	|
    A_PARENTESES exp F_PARENTESES {$$.nd = mknode(NULL, $2.nd, "(exp)")}|
    var {
		$$.nd = mknode($1.nd, NULL, "var");
		$$.type = $1.type;
	} |
	constval {
		$$.nd = mknode($1.nd, NULL, "constval");
		$$.type = $1.type;
	}
;

constval:
	INTEGER {
		struct node* temp = mknode(NULL, NULL, $1.name);
		$$.nd = mknode(temp, NULL, "intconst");
		$$.type = 1;
	}
	| 
	REAL {
		struct node* temp = mknode(NULL, NULL, $1.name);
		$$.nd = mknode(temp, NULL, "realconst");
		$$.type = 2;
	}
	|
	CHAR {
		struct node* temp = mknode(NULL, NULL, $1.name);
		$$.nd = mknode(temp, NULL, "charconst");
		$$.type = 1;
	}
	| 
	STR{
		struct node* temp = mknode(NULL, NULL, $1.name);
		$$.nd = mknode(temp, NULL, "stringconst");
		$$.type = 3;
	}
;


atribuicao: var ATRIB exp PONTO_VIRG {
	$$.nd = mknode($1.nd, $3.nd, "=");
	if($1.type == 1){
		if($3.type == 1 || $3.type == 4) $$.type = 1;
		else printf("Tipos de valores incompatíveis na linha %d\n", line);
	} 
	
}

%%

void yyerror (){
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
 print_tree_util(head, 0);
 return 0;
}