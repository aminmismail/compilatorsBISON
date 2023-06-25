#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct node { 
	struct node *left; 
	struct node *right; 
	char *token; 
};


struct node* mknode(struct node *left, struct node *right, char *token);
struct node* mkerrnode(struct node *left, struct node *right);
void printTree(FILE* of, struct node* node);