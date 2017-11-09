%{
/*
 * Parser.y file
 * calculator
 * To generate the parser run: "bison parser.y"
 */
#include "calc.h"   /* Contains definition of 'symrec'. */
#include "parser.h"
#include "lexer.h"
#include <math.h>   /* isnan. */
#include <float.h>  /* DBL_EPSILON. */

void yyerror (char const *); 
%}

%output "parser.c"
%defines "parser.h"

/* Bison declarations.  */
%define api.pure 
%define api.value.type union /* Generate YYSTYPE from these types: */
%token <double> NUM          /* Simple double */
%token <symrec*> VAR FNCT    /* Symbol table pointer: variable and function */
%type <double> exp

%precedence '='
%left '-' '+'
%left '*' '/' '%'
%precedence NEG  /* negation--unary minus.. -2^3 = -8, like everyone else */
%left '^'        /* exponentiation.. 2^2^2^2 = 256, like reduce and Matlab */
%precedence FAC  /* factorial (unary) */
%left '!'        /* 3!! = 720, %left or %right same result, may not matter */

/* See section 8.4.1 Enabling Traces in Bison manual */
/* Generate the parser description file. */
%verbose
/* Enable run-time traces (yydebug). */
%define parse.trace

/* Formatting semantic values. */
%printer { fprintf (yyoutput, "%s", $$->name); } VAR;
%printer { fprintf (yyoutput, "%s()", $$->name); } FNCT;
%printer { fprintf (yyoutput, "%lg", $$); } <double>;

%% /* The grammar follows.  */

input:
  %empty
| input line
;

line:
  '\n'
| exp '\n'           { printf ("\t%.10g\n", $1);                     }
| error '\n'         { yyerrok;                                      }
;

exp:
  NUM                { $$ = $1;                                      }
| VAR                { 
                       if ( isnan( $1->value.var ) ) 
                       {
			 char *buf;
			 buf = malloc( sizeof( $1->name ) + \
			  sizeof( "not defined" ) + 1 );
			 sprintf( buf, "%s not defined", $1->name );
                         yyerror( buf );
                         YYERROR;
                       }
                       else 
                         $$ = $1->value.var;
                     }
| VAR '=' exp        { $$ = $3; $1->value.var = $3;                  }
| FNCT '(' exp ')'   { $$ = (*($1->value.fnctptr))($3);              }
| exp '+' exp        { $$ = $1 + $3;                                 }
| exp '-' exp        { $$ = $1 - $3;                                 }
| exp '*' exp        { $$ = $1 * $3;                                 }
| exp '/' exp        { 
                       if ($3) /* then not zero */
                         $$ = $1 / $3;
                       else
                       {
                         yyerror("division by zero");
                         YYERROR;
                       } 
                     }
| exp '%' exp        { 
                       if ($3) /* then not zero */
                         $$ = fmod( $1 , $3 );
                       else
                       {
                         yyerror("division by zero");
                         YYERROR;
                       } 
                     }
| '-' exp  %prec NEG { $$ = -$2;                                     }
| exp '^' exp        { $$ = pow ($1, $3);                            }
| exp '!'  %prec FAC {
                       if ( fabs( $1 - round($1) ) > DBL_EPSILON )
                       /* If the absolute difference of the value and its
                          rounded value is > roundoff, then it is not
                          an integer, it must be a floating point value 
                          DBL_EPSILON = ~2.22e-16 */
                       {
                         yyerror("factorial of float");
                         YYERROR;
                       } 
                       else if ( $1 < 0 ) 
                       {
                         yyerror("factorial of negative");
                         YYERROR;
                       }
                       else /* positive integer */
                       {
                         int result = 1;
                         for (int c=1; c<=round($1); c++)
                           result = result * c;
                         $$ = result;
                       }
                     }
| '(' exp ')'        { $$ = $2;                                      }
;
/* End of grammar. */

%%

void
yyerror ( char const *s )
{
  fprintf(stderr, "%s\n", s);
}
