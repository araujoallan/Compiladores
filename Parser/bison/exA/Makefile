all: compile

compile:
	 bison -Wall --defines=parser.h -o parser.c parser.y
	 flex scanner.l
	 gcc -Wall -o parser scanner.c parser.c -ly -lm
	 ./parser
