/*
 * lexer.l file
 * calculator
 * To generate the lexical analyzer run: flex lexer.l
 */
%{
#include "calc.h"
#include "parser.h"

int line = 1; /* Track what line we are on. Increment for each exp (bison).  */
int yy_interactive; /* interactive or not */
%}

%option outfile="lexer.c" header-file="lexer.h"
%option noyywrap 
%option bison-bridge

/* https://stackoverflow.com/
 *        /questions/12643009/regular-expression-for-floating-point-numbers */
FLOAT	[0-9]+([.][0-9]*)?|[.][0-9]+  
SYMBL	[A-Za-z][A-Za-z0-9]*

%%

%{
/* Overriding YY_INPUT to add a prompt for input that contains 
 *  the line #.  This was the flex generated definition for YY_INPUT.  
 *  Placed in this part of the flex definition so we can add an 
 *  fprintf(yyout,...) with the prompt for the interactive input. 
 *  This is based on a simpler override in the flex manual.  */
#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
  if ( YY_CURRENT_BUFFER_LVALUE->yy_is_interactive ) \
  { \
    yy_interactive = 1; /* Yes, interactive */ \
    fprintf(yyout, "%d> ", line); /* prompt here */ \
    int c = '*'; \
    size_t n; \
    for ( n = 0; n < max_size && (c = getc( yyin )) != EOF && c != '\n'; ++n ) \
      buf[n] = (char) c; \
      if ( c == '\n' ) \
        buf[n++] = (char) c; \
      if ( c == EOF && ferror( yyin ) ) \
        YY_FATAL_ERROR( "input in flex scanner failed" ); \
      if ( c == EOF )             /* finish nicely. */ \
        fprintf(yyout, "\n");     /* don't leave them hanging. */ \
    result = n; \
  } \
  else \
  { \
    yy_interactive = 0; /* Not interactive */ \
    errno=0; \
    while ( (result = (int) fread(buf, 1, max_size, yyin))==0 && ferror(yyin)) \
    { \
      if( errno != EINTR) \
      { \
        YY_FATAL_ERROR( "input in flex scanner failed" ); \
        break; \
      } \
      errno=0; \
      clearerr(yyin); \
    } \
  }\
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
	  *((symrec**) &yylval->VAR) = s; /* FCNT also symrec, so this works */
	  return s->type;
	}

(.|\n)	{ 
	  /* return the decimal representation of the character to parser */
	  int c = yytext[0] + '\0';
	  return c;
	}
%%

/* No code here */
