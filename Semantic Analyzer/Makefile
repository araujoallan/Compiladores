all:	
	bison -Wall --defines=parser.h -o parser.c parser.y --report=state -W
	flex scanner.l
	gcc -Wall -o trab3 scanner.c parser.c tabelaHash.c -ly -lm