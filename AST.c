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

void printtree(struct node* tree) {
	printf("\n\n Inorder traversal of the Parse Tree: \n\n");
	printInorder(tree);
	printf("\n\n");
}

void printInorder(struct node *tree) {
	int i;
	if (tree->left) {
		printInorder(tree->left);
	}
	printf("%s, ", tree->token);
	if (tree->right) {
		printInorder(tree->right);
	}
}

int getLevelCount(struct node* tree){
    if (tree == NULL)
    {
        return 0;
    }
    int leftMaxLevel = 1 + getLevelCount(tree->left);
    int rightMaxLevel = 1 + getLevelCount(tree->right);
    if (leftMaxLevel > rightMaxLevel)
    {
        return leftMaxLevel;
    }
    else
    {
        return rightMaxLevel;
    }
}

void printLevel(struct node *tree, int level)
{
    if (tree != NULL && level == 0)
    {
        printf("%s ", tree->token);
    }   
    else if (tree != NULL)
    {
        printLevel(tree->left, level - 1);
        printLevel(tree->right, level - 1);
    }
}

void printElements(struct node* tree)
{
    int i;
    int levelCount = getLevelCount(tree);
    for (i = 0; i < levelCount; i++){
        printLevel(tree, i);
		printf("\n");
    }
}

void print_tree_util(struct node *root, int space) {
    if(root == NULL)
        return;
    space += 7;
    print_tree_util(root->right, space);
    for (int i = 7; i < space; i++)
        printf(" ");
    printf("(%d) %s\n", space/7, root->token);
    print_tree_util(root->left, space);
}


