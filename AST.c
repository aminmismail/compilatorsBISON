#include "AST.h"

struct node* mknode(struct node *left, struct node *right, char *token) {	
	struct node *newnode = (struct node *)malloc(sizeof(struct node));
	char *newstr = (char *)malloc(strlen(token)+1);
	strcpy(newstr, token);
	newnode->left = left;
	newnode->right = right;
	newnode->token = newstr;
	return(newnode);
}

struct node* mkerrnode(struct node *left, struct node *right) {	
	struct node *newnode = mknode(left,right,"_ERROR_");
	return(newnode);
}

void printAux(FILE* of, struct node* node, int n, int child){
    int i;
    for(i = 0; i < n; i++){
        if(i == n-1 && child == 0){
            fprintf(of, " \u251c", 192);
        }
        else if(i == n-1 && child == 1){
            fprintf(of, " \u2515", 195);
        }
        else{
            fprintf(of, " | ");
        }
    }

    fprintf(of,"%s\n", node->token);

    if(node->left != NULL)
        printAux(of, node->left, n+1, 0);
    if(node->right != NULL)
        printAux(of, node->right, n+1, 1);
}

void printTree(FILE* of, struct node* node){
    fprintf(of,"| | | ARVORE SINTATICA | | |\n");
    printAux(of, node, 0, 0);
}


