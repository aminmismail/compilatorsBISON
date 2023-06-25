#include <stdlib.h>
#include <stdio.h>
#include <string.h>
FILE *symtabLog;

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
#define KEYWORD 7

/* Forma de passagem do parametro */
#define BY_VALUE 1
#define BY_REFER 2

/* Lista encadeada de referencias para cada variavel */
typedef struct RefList{ 
    int lineno;
    struct RefList *next;
    int type;
}RefList;

// Struct para no da lista
typedef struct list_t{
    char st_name[MAXTOKENLEN];
    char st_cat[MAXTOKENLEN];
    int st_size;
    int scope;
    RefList *lines;
    int st_ival; double st_fval; char *st_sval;    // Valores
    // Tipo
    int st_type;
    // pointer to next item in the list
    struct list_t *next;
}list_t;

/* the hash table */
static list_t **hash_table;

// Function Declarations
void init_hash_table(); // initialize hash table
unsigned int hash(char *key); // hash function 
void insert(char *name, int len, int type, char* cat, int lineno); // insert entry
list_t *lookup(char *name); // search for entry
list_t *lookup_scope(char *name, int scope); // search for entry in scope
void hide_scope(); // hide the current scope
void incr_scope(); // go to next scope
void symtab_dump(FILE *of); // dump file
void set_type(char *name, int st_type); // Define o tipo de um simbolo na tabela 
int get_type(char *name); // Retorna o tipo de um simbolo
