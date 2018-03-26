%option outfile="scanner.c"
%option noyywrap
%option nounput
%option noinput
%{
#include <stdio.h>
#include "parser.h"
extern int node;
extern int contLinha,contLinhaFunc;
extern int escopo, pFunc;
extern char* ultFunc;
%}
digito [0-9]
naozero [1-9]
letra [a-zA-Z]

bloco_cod "inicio"|"fim"
bloco_if "se"|"fim_se"|"senao"|"entao"
bloco_while "faca"|"fim_enquanto"|"enquanto"
bloco_for "para"|"de"|"ate"|"fim_para"|"passo"
prim_type "inteiro"|"real"|"caractere"|"literal"|"logico"
prim_type_pl "inteiros"|"reais"|"caracteres"|"literais"|"logicos"
bloco_variaveis "variaveis"|"fim_variaveis"
identificador [a-zA-Z][0-9a-zA-Z"_"]*
decimal {digito}+
real {decimal}"."{decimal}
caractere \'([^\'\\]|\.)?\'
string \"([^\"\r\n]|\\.)*\"
logico ("verdadeiro"|"falso")
opAritmetico ("+"|"-"|"/"|"*"|"++")
opRelacional ("<"|">"|"="|"<="|">="|"<>")
opLogico ("e"|"ou")
atribuicao ":="
simboloEspecial ("("|")"|"["|"]"|","|";"|":")
commentLinha "//"[^\n]*
commentLinhas "/*"([^"*"]|"*"|[^"/"])*"*/"
hexDec 0[Xx][a-fA-F0-9]+
octDec 0[Cc][0-7]+
bin 0[Bb][0-1]*
matriz "matriz"
retorne "retorne"
nao "nao"
funcao "funcao"
inteiro {decimal}|{bin}|{octDec}|{hexDec}
%%
{opRelacional} { 
	yylval.nNode = node; node++;
	if(strcmp("=",yytext)==0) return IGUAL;
	if(strcmp("<>",yytext)==0) return NAO_IGUAL;
	if(strcmp("<",yytext)==0) return MENOR_QUE;
	if(strcmp(">",yytext)==0) return MAIOR_QUE;
	if(strcmp("<=",yytext)==0) return MENOR_IGUAL_QUE;
	if(strcmp(">=",yytext)==0) return MAIOR_IGUAL_QUE;
}
{bloco_cod} { 
	yylval.nNode = node; node++;
	if(!strcmp("inicio",yytext)) 
		return INICIO; 
	else
		return FIM;
}

{funcao} {
	pFunc = 1;
	escopo = 2;
	contLinhaFunc = contLinha;
	yylval.nNode = node; node++;
	return FUNCAO;
}
{opLogico} {
	yylval.nNode = node; node++;
	if(!strcmp("e",yytext)) 
		return OP_E;
	else 
		return OP_OU;
}
{opAritmetico} {
	yylval.nNode = node; node++;
	return yytext[0];
}
{matriz} {
	yylval.nNode = node; node++;
	return MATRIZ;
}
{nao} {
	yylval.nNode = node; node++;
	return OP_NAO;
}
{retorne} {
	yylval.nNode = node; node++;
	return RETORNE;
}
{bloco_variaveis} {
	
	
	yylval.nNode = node; node++;
	if(!strcmp("variaveis",yytext))
	{
		escopo = 1;
		return VARIAVEIS;
	}		
	else 
		return FIM_VARIAVEIS;
}
{prim_type} {
	yylval.label_nNode.nNode = node;node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext);
	return PRIM_TYPE;
}
{prim_type_pl} {
	yylval.label_nNode.nNode = node; node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext); 
	return PRIM_TYPE_PL;
}
{logico} {
	yylval.label_nNode.nNode = node; node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext);
	if(!strcmp("verdadeiro",yytext))
		return T_KW_VERDADEIRO;
	else
		return T_KW_FALSO;
}
"algoritmo" {
	yylval.nNode = node; node++;
	return ALGORITMO;
}

{simboloEspecial} {
	yylval.nNode = node; node++;
	return yytext[0];
} 
{atribuicao} {
	yylval.nNode = node; node++;
	return ATRIBUICAO;
}
{inteiro} {
	yylval.label_nNode.nNode = node; node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext);
	return T_INT_LIT;
}
{real} {
	yylval.label_nNode.nNode = node; node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext);
	return T_REAL_LIT;
}
{caractere} {
	yylval.label_nNode.nNode = node; node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext); 
	return T_CARAC_LIT;
}

{bloco_if} {
	yylval.nNode = node; node++;
	if(!strcmp("se",yytext)) return SE;
	if(!strcmp("faca",yytext)) return FACA; 
	if(!strcmp("fim_se",yytext))	return FIM_SE;
	if(!strcmp("entao",yytext))  return ENTAO;
	if(!strcmp("senao",yytext))  return SENAO;
}
{bloco_while} {
	yylval.nNode = node; node++;
	if(!strcmp("faca",yytext)) return FACA; 
	if(!strcmp("fim_enquanto",yytext))	return FIM_ENQUANTO;
	if(!strcmp("enquanto",yytext))  return ENQUANTO;
}
{bloco_for} {
	yylval.nNode = node; node++;
	if(!strcmp("para",yytext)) return PARA; 
	if(!strcmp("de",yytext))	return DE;
	if(!strcmp("ate",yytext))  return ATE;
	if(!strcmp("fim_para",yytext))  return FIM_PARA;
	if(!strcmp("passo",yytext))  return PASSO;
}
{string} {
	yylval.label_nNode.nNode = node; node++;
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext);
	return T_STRING_LIT;
}
{identificador} {
	if(pFunc == 1)
	{
		ultFunc = (char*) malloc(sizeof(char)*strlen(yytext)+1);
		strcpy(ultFunc,yytext);
		pFunc = 0;
	}
	
	yylval.label_nNode.nNode = node; node++; 
	yylval.label_nNode.label = malloc(strlen(yytext)+1);
	strcpy(yylval.label_nNode.label,yytext) ;
	return T_IDENTIFICADOR;
 }
"'".*"'" {} //Ignorar qualquer literal com aspas simples
{commentLinha} {}
{commentLinhas} {}

[\n] {contLinha++;}
[ \t\n] {}
%%

