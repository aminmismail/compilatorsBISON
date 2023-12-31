
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     INCR = 259,
     DIG = 260,
     A_CHAVES = 261,
     A_COLCHETES = 262,
     A_PARENTESES = 263,
     F_CHAVES = 264,
     F_COLCHETES = 265,
     F_PARENTESES = 266,
     DOIS_PONTOS = 267,
     PONTO_VIRG = 268,
     VIRG = 269,
     PONTO = 270,
     IGUAL = 271,
     ATRIB = 272,
     SOMA = 273,
     SUB = 274,
     MULT = 275,
     DIV = 276,
     AND = 277,
     OR = 278,
     NOT = 279,
     COMP = 280,
     IF = 281,
     ELSE = 282,
     FOR = 283,
     WHILE = 284,
     CHAR = 285,
     INT = 286,
     DOUBLE = 287,
     FLOAT = 288,
     VOID = 289,
     RETURN = 290,
     INCLUDE = 291,
     STRING = 292,
     PRINT = 293,
     READ = 294,
     INTEGER = 295,
     REAL = 296,
     CHARACTER = 297,
     STR = 298
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 18 ".\\parser.y"

    struct var_name { 
			char name[100];
			struct node* nd;
			int type;
			list_t* symtab_item;
		} nd_obj;



/* Line 1676 of yacc.c  */
#line 106 "parser.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


