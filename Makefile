# Makefile for calculator

FILES	= lexer.c parser.c calc.c main.c
CC	= gcc
CFLAGS	= -lm
BFLAGS  = 

calc:       $(FILES)
	$(CC) $(CFLAGS) $(FILES) -o calc

lexer.c:    lexer.l 
	flex lexer.l

parser.c:   parser.y lexer.c
	bison $(BFLAGS) parser.y

clean:
	rm -f *.o *~ lexer.c lexer.h parser.c parser.h calc
