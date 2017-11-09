%{
/*
 * lexer.l file
 * calculator
 * To generate the lexical analyzer run: flex lexer.l
 */
#include "calc.h"
#include "parser.h"
%}

%option outfile="lexer.c" header-file="lexer.h"
%option noyywrap 
%option bison-bridge

/* 
 * https://stackoverflow.com/
 *        /questions/12643009/regular-expression-for-floating-point-numbers 
 */
FLOAT	[0-9]+([.][0-9]*)?|[.][0-9]+  
SYMBL	[A-Za-z][A-Za-z0-9]*

%%

%{
/* No code here */
%}

[ \t]+	/* eat up whitespace */

<<EOF>>	{ return 0; }

{FLOAT}	{
	  /* set yylval->NUM to the number,
	   * return NUM */
	  sscanf(yytext, "%lf", &yylval->NUM); 
	  return NUM; 
	}

{SYMBL}	{
	  /* add symbol to the symbol table, 
           * set yylval to pointer to symrec 
           * return VAR or FNCT as appropriate */
	  symrec *s;
	  s = getsym ( yytext );
	  if ( s == 0 ) 
	    s = putsym( yytext, VAR ); /* if adding to the table, it's a VAR */
	  *((symrec**) &yylval->VAR) = s; /* FCNT is also a symrec */
	  return s->type;
	}

(.|\n)	{ 
	  /* return the decimal representation of the character to parser */
	  int c = yytext[0] + '\0';
	  return c;
	}
%%

/* No code here */
