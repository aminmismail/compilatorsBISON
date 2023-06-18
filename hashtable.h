#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Tamanho maximo da tabela */
#define SIZE 211

/* Tamanho maximo dos identificadores */
#define MAXTOKENLEN 40

/* Tipos */
#define UNDEF 0
#define INT_TYPE 1
#define REAL_TYPE 2
#define STR_TYPE 3
#define LOGIC_TYPE 4
#define ARRAY_TYPE 5
#define FUNCTION_TYPE 6

/* Forma de passagem do parametro */
#define BY_VALUE 1
#define BY_REFER 2


/* Struct do parametro */
typedef struct Param{
	int par_type;
	char param_name[MAXTOKENLEN];
	// Valor
	int ival; double fval; char *st_sval;
	int passing; // value or reference
}Param;

/* Lista encadeada de referencias para cada variavel */
typedef struct RefList{ 
    int lineno;
    struct RefList *next;
    int type;
}RefList;

// Struct para no da lista
typedef struct list_t{
    char st_name[MAXTOKENLEN];
    int st_size;
    int scope;
    RefList *lines;
    int st_ival; double st_fval; char *st_sval;    // Valores
    // Tipo
    int st_type;
    // Tipo para arrays e funcoes
    int inf_type; 
    int *i_vals; double *f_vals; char **s_vals;
    int array_size;
    // Parametros da funcao
    Param *parameters;
    int num_of_pars;
    // pointer to next item in the list
    struct list_t *next;
}list_t;

/* the hash table */
static list_t **hash_table;

// Function Declarations
void init_hash_table(); // initialize hash table
unsigned int hash(char *key); // hash function 
void insert(char *name, int len, int type, int lineno); // insert entry
list_t *lookup(char *name); // search for entry
list_t *lookup_scope(char *name, int scope); // search for entry in scope
void hide_scope(); // hide the current scope
void incr_scope(); // go to next scope
void symtab_dump(FILE *of); // dump file