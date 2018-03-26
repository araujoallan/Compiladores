%{
#include<ctype.h>
#include<stdio.h>
int yylex(void);
void yyerror(char const *s);
%}
%token DIGIT
%left '+' '-'  /* Ops associativos a esquerda. */
%left '*' '/'  /* Mais para baixo, maior precedencia. */
%%
lines: %empty
| lines expr '\n'       { printf(">> %d\n", $2); } ;
expr: DIGIT
| expr '+' expr         { $$ = $1 + $3; }
| expr '-' expr         { $$ = $1 - $3; }
| expr '*' expr         { $$ = $1 * $3; }
| expr '/' expr         { $$ = $1 / $3; } ;
%%
int yylex(void) {
  int c = getchar();
  if (isdigit(c)) { yylval = c - '0'; return DIGIT; }
  return c;
}
