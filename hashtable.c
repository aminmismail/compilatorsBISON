#include "hashtable.h"

/* current scope */
int cur_scope = 0;


void init_hash_table(){
	int i; 
	hash_table = malloc(SIZE * sizeof(list_t*));
	for(i = 0; i < SIZE; i++) hash_table[i] = NULL;
}

unsigned int hash(char *key){
	unsigned int hashval = 0;
	for(;*key!='\0';key++) hashval += *key;
	hashval += key[0] % 11 + (key[0] << 3) - key[0];
	return hashval % SIZE;
}

void insert(char *name, int len, int type, char* cat, int lineno){
	unsigned int hashval = hash(name);
	list_t *l = hash_table[hashval];
	
	while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
	
	/* variable not yet in table */
	if (l == NULL){
		l = (list_t*) malloc(sizeof(list_t));
		strncpy(l->st_name, name, len+1);
		strncpy(l->st_cat, cat, strlen(cat)+1);  
		/* add to hashtable */
		l->st_type = type;
		l->scope = cur_scope;
		l->lines = (RefList*) malloc(sizeof(RefList));
		l->lines->lineno = lineno;
		l->lines->next = NULL;
		l->next = hash_table[hashval];
		hash_table[hashval] = l; 
		fprintf(symtabLog, "Inserido '%s' pela primeira vez na linha: %d\n", name, lineno); // error checking
	}
	/* found in table, so just add line number */
	else{
		l->scope = cur_scope;
		RefList *t = l->lines;
		while (t->next != NULL) t = t->next;
		/* add linenumber to reference list */
		t->next = (RefList*) malloc(sizeof(RefList));
		t->next->lineno = lineno;
		t->next->next = NULL;
		fprintf(symtabLog, "Encontrado '%s' novamente na linha: %d\n", name, lineno);
	}
}

list_t *lookup(char *name){ /* return symbol if found or NULL if not found */
    unsigned int hashval = hash(name);
    list_t *l = hash_table[hashval];
    while ((l != NULL) && (strcmp(name,l->st_name) != 0)) l = l->next;
    return l; // NULL is not found
}

list_t *lookup_scope(char *name, int scope){ /* return symbol if found or NULL if not found */
    unsigned int hashval = hash(name);
    list_t *l = hash_table[hashval];
    while ((l != NULL) && (strcmp(name,l->st_name) != 0) && (scope != l->scope)) l = l->next;
    return l; // NULL is not found
}

void hide_scope(){ /* hide the current scope */
	if(cur_scope > 0) cur_scope--;
}
void incr_scope(){ /* go to next scope */
	cur_scope++;
}

/* print to stdout by default */ 
void symtab_dump(FILE * of){  
  int i;
  fprintf(of,"------------------------- -------------- ---------- ------------\n");
  fprintf(of,"Cadeia                    Token          Tipo       Linhas\n");
  fprintf(of,"------------------------- -------------- ---------- -------------\n");
  for (i=0; i < SIZE; ++i){ 
	if (hash_table[i] != NULL){ 
		list_t *l = hash_table[i];
		while (l != NULL){ 
			RefList *t = l->lines;

			//Printa a Cadeia
			fprintf(of,"%-25s ",l->st_name);

			//Printa a Categoria
			fprintf(of, "%-14s ", l->st_cat);

			//Printa o tipo
			if (l->st_type == INT_TYPE) fprintf(of,"%-10s","int");
			else if (l->st_type == REAL_TYPE) fprintf(of,"%-10s","real");
			else if (l->st_type == STR_TYPE) fprintf(of,"%-10s","string");
			else if (l->st_type == KEYWORD) fprintf(of, "%-10s", "Keyword");
			else fprintf(of,"%-10s","undef"); // if UNDEF or 0

			//Printa as linhas de referencia
			while (t != NULL){
				fprintf(of,"%4d ",t->lineno);
			t = t->next;
			}

			//Proximo elemento
			fprintf(of,"\n");
			l = l->next;
		}
    }
  }
}

void set_type(char *name, int st_type){
	/* lookup entry */
	list_t *l = lookup(name);

	/* set "main" type */
	l->st_type = st_type;

}

int get_type(char *name){
	/* lookup entry */
	list_t *l = lookup(name);

	/* if "simple" type */
	if(l->st_type == INT_TYPE || l->st_type == REAL_TYPE){
		return l->st_type;
	}
}