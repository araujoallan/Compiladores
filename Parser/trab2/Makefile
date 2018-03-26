all: compile

compile:
	 bison -Wall --defines=parser.h -o parser.c parser.y --report=state -W
	 flex scanner.l
	 gcc -Wall -o trab2 scanner.c parser.c -ly -lm
	 ./trab2 < arquivo_entrada > out.dot
	 dot -Tpdf out.dot -o tree.pdf
