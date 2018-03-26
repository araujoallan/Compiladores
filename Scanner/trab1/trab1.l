%{
#include <stdio.h>
%}
digito [0-9]
naozero [1-9]
letra [a-zA-Z]

palavraReservada "fim_variaveis"|"entao"|"senao"|"algoritmo"|"variaveis"|"inteiro"|"real"|"verdadeiro"|"falso"|"e"|"ou"|"nao"|"caractere"|"literal"|"logico"|"inicio"|"fim"|"se"|"fim_se"|"enquanto"|"faca"|"fim_enquanto"|"para"|"de"|"ate"|"fim_para"|"matriz"|"inteiros"|"reais"|"caracteres"|"literais"|"logicos"|"funcao"|"retorne"|"passo"
identificador [a-zA-Z][0-9a-zA-Z"_"]*
decimal {digito}+
inteiro [+-]?{decimal}
real [+-]?{decimal}"."{decimal}
caractere \'([^\'\\]|\.)?\'
string \"([^\"\CFLF]|\\.)*\"
logico ("verdadeiro"|"falso")
opAritmetico ("+"|"-"|"/"|"*"|"++")
opRelacional ("<"|">"|"="|"<="|">="|"<>")
opLogico ("e"|"ou"|"nao")
atribuicao ":="
simboloEspecial ("("|")"|"["|"]"|","|";"|":")
commentLinha "//"[^\n]*
commentLinhas "/*"([^"*"]|"*"|[^"/"])*"*/"
hexDec 0[Xx][a-fA-F0-9]+
octDec 0[Cc][0-7]+
bin 0[Bb][0-1]*
desconhecido [^ \t\n]

%%
{opLogico} {printf("%s -> OPERADOR_LOGICO\n", yytext);}
{logico} {printf("%s -> LOGICO\n", yytext);}
{palavraReservada} {printf("%s -> PALAVRA_RESERVADA\n", yytext);}
{inteiro} {printf("%s -> INTEIRO\n", yytext);}
{identificador} {printf("%s -> IDENTIFICADOR\n", yytext);}
{real} {printf("%s -> REAL\n", yytext);}
{caractere} {printf("%s -> CARACTERE\n", yytext);}
"'".*"'" {} //Ignorar qualquer literal com aspas simples
{string} {printf("%s -> LITERAL\n", yytext);}
{atribuicao} {printf("%s -> ATRIBUICAO\n", yytext);}
{opAritmetico} {printf("%s -> OPERADOR_ARITMETICO\n", yytext);}
{opRelacional} {printf("%s -> OPERADOR_RELACIONAL\n", yytext);}
{simboloEspecial} {printf("%s -> SIMBOLO_ESPECIAL\n", yytext);} 
{hexDec} {printf("%s -> INTEIRO\n", yytext);}
{octDec} {printf("%s -> INTEIRO\n", yytext);}
{bin} {printf("%s -> INTEIRO\n", yytext);}
{commentLinha} {}
{commentLinhas} {}

{desconhecido} {printf("%s -> DESCONHECIDO\n", yytext);}
[ \t\n] {}
%%
int main()  { yylex(); return 0; }
/* Definindo esta funcao nao precisa compilar com -lfl */
int yywrap() { return 1; }

