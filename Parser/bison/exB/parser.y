//EXERCICIO b 2A AULA DE LABORATORIO

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
%precedence UNIN
%right '^'
%%
lines: %empty
| lines expr '\n'       { printf(">> %g\n", $2); } ;
expr: NUMBER
| expr '+' expr         { $$ = $1 + $3; }
| expr '-' expr         { $$ = $1 - $3; }
| expr '*' expr         { $$ = $1 * $3; }
| expr '/' expr         { $$ = $1 / $3; } 
| '-'expr %prec UNIN	{ $$ = -$2; }									 
|expr '^' expr       	{ $$ = pow($1, $3); }	// exponenciação
%%
