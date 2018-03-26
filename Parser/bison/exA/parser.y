%{
#include<stdio.h>
int yylex(void);
void yyerror(char const *s);
#include<math.h>

%}
%define api.value.type {double} // Tipo da variavel yylval
%token NUMBER
%left '+' '-'
%left '*' '/'
%right '^'
%%
lines: %empty
| lines expr '\n'       { printf(">> %g\n", $2); } ;
expr: NUMBER
| expr '+' expr         { $$ = $1 + $3; }
| expr '-' expr         { $$ = $1 - $3; }
| expr '*' expr         { $$ = $1 * $3; }
| expr '/' expr         { $$ = $1 / $3; } 
| expr '^' expr         { $$ = pow($1, $3); }	// exponenciação
									 
%%
