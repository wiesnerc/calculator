/* calculator */

#include "calc.h"   /* Contains definition of 'symrec'. */
#include "parser.h"
#include "lexer.h"
#include <math.h>   /* INFINITY */
#include <float.h>   /* DBL_EPSILON */

struct init_cnsts const math_cnsts[] =
{
  { "pi", 3.1415926535897 },
  { "e",  2.7182818284590 },
  { "Inf",  INFINITY },
  { "epsilon",  DBL_EPSILON },
  { 0, 0 }
};

struct init_fncts const arith_fncts[] =
{
  { "abs",   fabs  },
  { "cos",   cos   },
  { "sin",   sin   },
  { "tan",   tan   },
  { "acos",  acos  },
  { "asin",  asin  },
  { "atan",  atan  },
  { "sqrt",  sqrt  },
  { "exp",   exp   },
  { "exp2",  exp2  },
  { "expm1", expm1 },
  { "ln",    log   },
  { "log",   log10 },
  { "log2",  log2  },
  { "ln1p",  log1p },
  { "trunc", trunc },
  { "ceil",  ceil  },
  { "floor", floor },
  { "round", round },
  { 0, 0 }
};

/* The symbol table: a chain of 'struct symrec'. */
symrec *sym_table;

/* Put arithmetic functions in the table. */
static 
void 
init_table (void)
{
  int i;

  /* Initialize the functions */
  for (i=0; arith_fncts[i].fname != 0; i++)
  {
    symrec *ptr = putsym (arith_fncts[i].fname, FNCT);
    ptr->value.fnctptr = arith_fncts[i].fnct;
  }

  /* Initialize the mathematical constants */
  for (i=0; math_cnsts[i].cname != 0; i++)
  {
    symrec *ptr = putsym (math_cnsts[i].cname, VAR);
    ptr->value.var = math_cnsts[i].value;
  }
}

int
main (int argc, char const* argv[])
{
  /* Enable parse traces on option -p */
  for (int i=1; i<argc; ++i)
    if (!strcmp(argv[i], "-p"))
      yydebug = 1;

  init_table ();

  //yy_scan_string("3*pi/2\n");
  return yyparse ();
}
