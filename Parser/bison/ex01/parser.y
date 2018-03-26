%{
#include<ctype.h>
#include<stdio.h>
int yylex(void);
void yyerror(char const *s);
%}
%token DIGIT
%%
lines:
  %empty
| lines expr '\n'       { printf(">> %d\n", $2); } ;
expr:
  expr '+' expr         { $$ = $1 + $3; }
| expr '-' expr         { $$ = $1 - $3; }
| expr '*' expr         { $$ = $1 * $3; }
| expr '/' expr         { $$ = $1 / $3; }
| DIGIT;
%%
int yylex(void) {
  int c = getchar();
  if (isdigit(c)) { yylval = c - '0'; return DIGIT; }
  return c;
}
