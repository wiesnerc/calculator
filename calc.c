/* calculator  */

#include "calc.h"   /* Contains definition of 'symrec'. */
#include <stdlib.h> /* malloc. */
#include <string.h> /* strlen. */
#include <math.h>   /* NAN */

symrec * 
putsym (char const *sym_name, int sym_type)
{
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name, sym_name);
  ptr->type = sym_type;
  ptr->value.var = NAN; /* Set value to NaN even if fnct. */
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec * 
getsym (char const *sym_name)
{
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name, sym_name) == 0)
      return ptr;
  return 0;
}
