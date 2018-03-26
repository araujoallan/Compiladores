%{
#include<ctype.h>
#include<stdio.h>
int yylex(void);
void yyerror(char const *s);
%}
%token DIGIT
%%
lines: %empty
| lines expr '\n'       { printf(">> %d\n", $2); } ;
expr: factor            /* Default: $$ = $1; */
| expr '+' factor       { $$ = $1 + $3; }
| expr '-' factor       { $$ = $1 - $3; } ;
factor: term
| factor '*' term       { $$ = $1 * $3; }
| factor '/' term       { $$ = $1 / $3; } ;
term: DIGIT ;
%%
int yylex(void) {
  int c = getchar();
  if (isdigit(c)) { yylval = c - '0'; return DIGIT; }
  return c;
}
