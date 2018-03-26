%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput
%{
#include "parser.h"
%}
number [0-9]+\.?|[0-9]*\.[0-9]+
%%
[ ]      ; // skip blanks
{number} { sscanf(yytext, "%lf", &yylval); return NUMBER; }
\n|.     { return yytext[0]; }
