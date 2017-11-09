# calculator
calculator

A multi function calculator application based on bison and flex.

Started with example multi-function cacluator from the bison user manual and
re-wrote the lexer function using flex.  Extended math functions to most, but 
not all, of the C math library (math.h) along with ability to store values with
a variable name.  Added modulus and factorial functions.

A couple notes:
1. exponentiation is left associative (i.e. %left in bison grammar). This 
   is same as the Reduce computer algebra system and Matlab (and I'm pretty
   sure Fortran also, but I need to check).  Results in:
   2^2^2^2 = 256.
2. all internal values are stored in double precision variables and/or use
   double precision functions (i.e. abs() => fabs()).  
3. factorial operates on equivalent integer values by checking:
     fabs($1 - round($1)) < epsison 
   before proceeding.

Created the calculator application to look into how to interface an application
with IPyton.
