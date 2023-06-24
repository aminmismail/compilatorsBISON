#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct node { 
	struct node *left; 
	struct node *right; 
	char *token; 
};


struct node* mknode(struct node *left, struct node *right, char *token);
void printtree(struct node* tree);
void printInorder(struct node *tree);
void printElements(struct node* tree);
void print_tree_util(struct node *root, int space);