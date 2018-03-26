%{
#include <stdio.h>
#include <stdlib.h>
#include "tabelaHash.h"
#include<math.h>
int yylex(void);
void yyerror(char const *s);
int node = 0;
int contLinha = 1, contLinhaFunc;
int passada = 1,pFunc = 0;
extern FILE *yyin;
extern int aridade;
int escopo = 1; //escopo = 1 variaveis globais, escopo = 2 funções, escopo = 3 expressoes
string ultFunc;

%}

%union{
	int nNode;
	
	struct label_nNode{
		int nNode;
		char* label, *tipo;		
	}label_nNode;
}

%error-verbose
%token <nNode> ALGORITMO "algoritmo"
%token <nNode> INICIO "inicio"
%token <nNode> FIM "fim"
%token <label_nNode> PRIM_TYPE
%token <label_nNode> PRIM_TYPE_PL
%token <nNode> VARIAVEIS "variaveis"
%token <nNode> FIM_VARIAVEIS "fim_variaveis"
%token <nNode> ATRIBUICAO ":="
%token <nNode> MATRIZ "matriz"
%token <nNode> RETORNE "retorne"
%token <nNode> DE "de"
%token <nNode> OP_NAO "nao"
%token <nNode> OP_E "e"
%token <nNode> OP_OU "ou"
%token <nNode> IGUAL "="
%token <nNode> NAO_IGUAL "<>"
%token <nNode> MENOR_QUE "<"
%token <nNode> MAIOR_QUE ">"
%token <nNode> MENOR_IGUAL_QUE "<="
%token <nNode> MAIOR_IGUAL_QUE ">="
%token <nNode> FUNCAO "funcao"
%token <nNode> SE "se"
%token <nNode> FIM_SE "fim_se"
%token <nNode> ENTAO "entao"
%token <nNode> SENAO "senao"
%token <nNode> ENQUANTO "enquanto"
%token <nNode> FACA "faca"
%token <nNode> FIM_ENQUANTO "fim_enquanto"
%token <nNode> PARA "para"
%token <nNode> ATE "ate"
%token <nNode> FIM_PARA "fim_para"
%token <nNode> PASSO "passo"
%token <label_nNode> T_CARAC_LIT
%token <label_nNode> T_STRING_LIT
%token <label_nNode> T_IDENTIFICADOR
%token <label_nNode> T_INT_LIT
%token <label_nNode> T_REAL_LIT
%token <label_nNode> T_KW_VERDADEIRO
%token <label_nNode> T_KW_FALSO
%type <label_nNode> expr lvalue termo literal fcall
%type <nNode> declaracao_algoritmo stm_block algoritmo_goal var_decl var_decl_block vdb_B
%type <nNode> func_decls_A vb_B func_decls tp_matriz stmb_B stm_list stm_attr
%type <nNode> tp_mat_B stm_para stm_se stm_enquanto stm_ret lvalue_B
%type <nNode> fvar_decl fc_B fparams stm_rec passo passo_B fargs fparam
%type <nNode> '[' ']' '(' ')' ';' ':' ','
%type <nNode> '+' '-' '*' '/' '%'
%type <nNode> '|' '^' '&' '~'
%left "ou"
%left "e"
%left '|'
%left '^'
%left '&'
%left "=" "<>"
%left "<=" ">="
%left "<" ">" 
%left '+' '-'
%left  '*' '/' '%'
%%

//algoritmo: declaracao_algoritmo var_decl_block? stm_block func_decls*
algoritmo_goal: declaracao_algoritmo var_decl_block stm_block func_decls_A {
		
}

| declaracao_algoritmo var_decl_block stm_block { 
		
}
| declaracao_algoritmo stm_block {
		
}
| declaracao_algoritmo stm_block func_decls_A {
		
}

func_decls_A : func_decls_A func_decls {
	
}
| func_decls {

}

declaracao_algoritmo: "algoritmo" T_IDENTIFICADOR ';' {
						
}

//var_decl_block : "variaveis" var_decl ';' "fim_variaveis"
var_decl_block: "variaveis" vdb_B "fim_variaveis" { escopo = 1;
		
}
vdb_B: vdb_B var_decl ';' {
	
}
| var_decl ';' { 
		
}

//var_decl: T_IDENTIFICADOR "," T_IDENTIFICADOR ":" PRIM_TYPE | tp_matriz
var_decl: T_IDENTIFICADOR vb_B ':' PRIM_TYPE {
	
	if(escopo == 1 && passada == 1)
	{			
		addIden(contLinha,$1.label,"");
		if(!strcmp("inteiro",$4.label)) addVar("inteiro",escopo);
		if(!strcmp("real",$4.label)) addVar("real",escopo);
		if(!strcmp("caractere",$4.label)) addVar("caractere",escopo);
		if(!strcmp("literal",$4.label)) addVar("literal",escopo);
		if(!strcmp("logico",$4.label)) addVar("logico",escopo);
	}
	
	if(escopo == 2 && passada == 1)
	{
		addVirgFunc(contLinha,$1.label);
		if(!strcmp("inteiro",$4.label)) addVar("inteiro",escopo);
		if(!strcmp("real",$4.label)) addVar("real",escopo);
		if(!strcmp("caractere",$4.label)) addVar("caractere",escopo);
		if(!strcmp("literal",$4.label)) addVar("literal",escopo);
		if(!strcmp("logico",$4.label)) addVar("logico",escopo);
	}
		
		
}
var_decl: T_IDENTIFICADOR ':' PRIM_TYPE { 
	if(escopo == 1 && passada == 1)
	{
		if(!strcmp("inteiro",$3.label)) addIdentificador(contLinha,$1.label,$3.label);
		if(!strcmp("real",$3.label)) addIdentificador(contLinha,$1.label,$3.label);
		if(!strcmp("caractere",$3.label)) addIdentificador(contLinha,$1.label,$3.label);
		if(!strcmp("literal",$3.label)) addIdentificador(contLinha,$1.label,$3.label);
		if(!strcmp("logico",$3.label)) addIdentificador(contLinha,$1.label,$3.label);
	}	
	
	if(escopo == 2 && passada == 1)
	{	
		if(!strcmp("inteiro",$3.label)) addIden(contLinha,$1.label,$3.label);
		if(!strcmp("real",$3.label)) addIden(contLinha,$1.label,$3.label);
		if(!strcmp("caractere",$3.label)) addIden(contLinha,$1.label,$3.label);
		if(!strcmp("literal",$3.label)) addIden(contLinha,$1.label,$3.label);
		if(!strcmp("logico",$3.label)) addIden(contLinha,$1.label,$3.label);
	}
		
}

| T_IDENTIFICADOR vb_B ':' tp_matriz {
	
}
 
| T_IDENTIFICADOR ':' tp_matriz {

}

vb_B: vb_B ',' T_IDENTIFICADOR {
	if(passada == 1 && escopo == 1)
		addIden(contLinha,$3.label,"");
		
	if(passada == 1 && escopo == 2)
		addVirgFunc(contLinha,$3.label);

}

|',' T_IDENTIFICADOR { 
	if(passada == 1 && escopo == 1)
		addIden(contLinha,$2.label,"");
		
	if(passada == 1 && escopo == 2)
		addVirgFunc(contLinha,$2.label);
		
	
}

//tp_matriz: "matriz" ("[" T_INT_LIT "]")+ "de" PRIM_TYPE_PL
tp_matriz: "matriz" tp_mat_B "de" PRIM_TYPE_PL {
	
}

tp_mat_B: tp_mat_B '[' T_INT_LIT ']' {
	

}
| '[' T_INT_LIT ']' {
	
}

//stm_block : "inicio" (stm_list)* "fim"
stm_block : "inicio" "fim" {
					
}

| "inicio" stmb_B "fim" {
		
}

stmb_B: stmb_B stm_list {
		
}

| stm_list {
	
}

stm_list: stm_attr {
	
}

| fcall ';' {
	
}

| stm_ret {
	
}

| stm_se {
	
}

| stm_enquanto {
	
}

| stm_para {
	
}

//stm_ret: "retorne" expr? ";"
stm_ret: "retorne" ';' {
	
}

| "retorne" expr ';' {

}

stm_attr: lvalue ":=" expr ';' {
	if(passada == 2)
	{	
		if(strcmp($1.tipo,$3.tipo))
		{
			//printf("%s := %s\n",$1.tipo,$3.tipo);
			if(strcmp($1.tipo,"inteiro") && strcmp($3.tipo,"real") ){}
			else
			{		
				if(strcmp("tipoLeia",$3.tipo))
				{
					printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",contLinha);
					exit(1);
				}
			}
				
			
		}
	}
	
}

//lvalue: T_IDENTIFICADOR '('"["expr"]"')''*'
lvalue: T_IDENTIFICADOR {	

	if(escopo == 1 && passada == 2)
	{		
		$$.label = $1.label;
		Identificador *new = procurarHashIden($1.label);
		
		if(new == NULL)
		{
			printf("Erro semantico na linha %d: variavel '%s' nao foi declarada.\n",contLinha,$$.label);
			exit(1);
		}
		else
		{
			$$.tipo = new->tipo;		
			
		}
	}
	
	
	if(escopo == 2 && passada == 2)
	{		
		$$.label = $1.label;
		Funcao *new = procurarHashFunc(ultFunc);	
		
		string aux1 = procurarDecl(new->params,$1.label) ;
		string aux2 = procurarDecl(new->vars,$1.label) ;
		
		if(aux1 == NULL && aux2 == NULL)
		{
			printf("Erro semantico na linha %d: variavel '%s' nao foi declarada.\n",contLinha,$1.label);
			exit(1);
		}
		else
		{			
			if(aux1 != NULL)
				$$.tipo = aux1;
			else
				$$.tipo = aux2;
		}
		
		
	
	}
	
}

| T_IDENTIFICADOR lvalue_B {

}

lvalue_B: lvalue_B '['expr']' {
	
}

| '['expr']' {
	
}

//precisa aninhar o bloco SE
//stm_se: "se" expr "entao" stm_list '('"senao" stm_list')''?' "fim_se"
stm_se: "se" expr "entao" stm_rec "fim_se" {
	
}

| "se" expr "entao" "fim_se" {
	
}

| "se" expr "entao" stm_rec "senao" stm_rec "fim_se" {
	
}

| "se" expr "entao" "senao" stm_rec "fim_se" {
	
}

| "se" expr "entao" stm_rec "senao" "fim_se" {
	
}

| "se" expr "entao" "senao" "fim_se" {
		
}

//precisa aninhar o bloco ENQUANTO
stm_enquanto: "enquanto" expr "faca" stm_rec "fim_enquanto" {
	
}

| "enquanto" expr "faca" "fim_enquanto" {
	 
}

//stm_para: "para" lvalue "de" expr "ate" passo'?' "faca" stm_list "fim_para"
stm_para: "para" lvalue "de" expr "ate" expr "faca" "fim_para" {
	 
}

| "para" lvalue "de" expr "ate" expr passo "faca" "fim_para" {
	
}	

| "para" lvalue "de" expr "ate" expr "faca" stm_rec "fim_para" {
 
}

| "para" lvalue "de" expr "ate" expr passo "faca" stm_rec "fim_para" {
  
}

//passo: "passo" '('"+"|"-"')''?' T_INT_LIT
passo: "passo" passo_B {
	 
}

passo_B: '+' T_INT_LIT {
	
}

| '-' T_INT_LIT {
	
}

| T_INT_LIT {
 
}

expr: expr "ou" expr {
	 
}

| expr "e" expr {
	
}

| expr '|' expr {

}

| expr '^' expr {
}

| expr '&' expr {
}

| expr "=" expr {
	
}

| expr "<>" expr {
	
}

| expr ">" expr {
	
}

| expr ">=" expr {
	
}

| expr "<" expr {
	
}

| expr "<=" expr {
	
}	

| expr '+' expr {

	if(passada == 2)
	{
		if(strcmp($1.tipo,"inteiro") && strcmp($1.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis\n",contLinha);
			exit(1);
		}
		
		if(strcmp($3.tipo,"inteiro") && strcmp($3.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",contLinha);
			exit(1);
		}
		
		if(!strcmp($1.tipo,"inteiro"))			
			$$ = $3;
		else		
			$$ = $1;
			
		
	}
	
}

| expr '-' expr {

	if(passada == 2)
	{
		if(strcmp($1.tipo,"inteiro") && strcmp($1.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis\n",contLinha);
			exit(1);
		}
		
		if(strcmp($3.tipo,"inteiro") && strcmp($3.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",contLinha);
			exit(1);
		}
		
		if(!strcmp($1.tipo,"inteiro"))			
			$$ = $3;
		else		
			$$ = $1;
	}
	
}

| expr '/' expr	{
	if(passada == 2)
	{
		if(strcmp($1.tipo,"inteiro") && strcmp($1.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis\n",contLinha);
			exit(1);
		}
		
		if(strcmp($3.tipo,"inteiro") && strcmp($3.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",contLinha);
			exit(1);
		}
		
		if(!strcmp($1.tipo,"inteiro"))			
			$$ = $3;
		else		
			$$ = $1;
	}

}
	
| expr '*' expr	{
	if(passada == 2)
	{
		if(strcmp($1.tipo,"inteiro") && strcmp($1.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis\n",contLinha);
			exit(1);
		}
		
		if(strcmp($3.tipo,"inteiro") && strcmp($3.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",contLinha);
			exit(1);
		}
		
		if(!strcmp($1.tipo,"inteiro"))			
			$$ = $3;
		else		
			$$ = $1;
	}
	
}	

| expr '%' expr	{

	if(passada == 2)
	{
		if(strcmp($1.tipo,"inteiro") && strcmp($1.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis\n",contLinha);
			exit(1);
		}
		
		if(strcmp($3.tipo,"inteiro") && strcmp($3.tipo,"real"))
		{
			printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",contLinha);
			exit(1);
		}
		
		if(!strcmp($1.tipo,"inteiro"))			
			$$ = $3;
		else		
			$$ = $1;
	}
	

}

| '+' termo {
	
}

| '-' termo {
	
}

| '~' termo {
	
}

| "nao" termo {
	
}

| termo	{ $$ = $1;

}

termo: fcall { 
	
}
| lvalue { 
	$$ = $1;
	
}

| literal { 
	$$ = $1;
	
}

| '(' expr ')' {
	$$ = $2;
	
}

fcall: T_IDENTIFICADOR fc_B {
	if(passada == 2)
	{
		Funcao *aux = procurarHashFunc($1.label);		
		
		if(strcmp("leia",$1.label))
		{
			if(aux == NULL)
			{
				printf("Erro semantico na linha %d: funcao '%s' nao foi declarada.\n",contLinha,$1.label);
				exit(1);
			}
			else
				$$.tipo = aux->tipoRetorno;
		}
		else
		{
			$$.tipo = "tipoLeia";
		}
		
		
		checarAridade($1.label,contLinha);
		
	}
	
	
}

fc_B: '(' fargs ')' {
	
	
}

| '(' ')' {
	
}

//fargs: expr '('"," expr')''*'
fargs: expr {
	if(passada == 2)
	{
		addArgs(contLinha,$1.label,$1.tipo);
	}
	
}

| fargs ',' expr {
	if(passada == 2)
	{
		addArgs(contLinha,$3.label,$3.tipo);
	}
	
}

| ',' expr {
	if(passada == 2)
	{
		addArgs(contLinha,$2.label,$2.tipo);
	}
	
}

literal: T_STRING_LIT {
	$$.tipo = (string) malloc(sizeof(char)*strlen($1.label)+1);
	strcpy($$.tipo,"literal");
	$$.label = $1.label;
	
}

| T_INT_LIT {	
	$$.tipo = (string) malloc(sizeof(char)*strlen($1.label)+1);
	strcpy($$.tipo,"inteiro");
	$$.label = $1.label;	
	

}

| T_REAL_LIT {
	$$.tipo = (string) malloc(sizeof(char)*strlen($1.label)+1);
	strcpy($$.tipo,"real");
	$$.label = $1.label;

}

| T_CARAC_LIT {
	$$.tipo = (string) malloc(sizeof(char)*strlen($1.label)+1);
	strcpy($$.tipo,"caractere");
	$$.label = $1.label;
}

| T_KW_VERDADEIRO {
	$$.tipo = (string) malloc(sizeof(char)*strlen($1.label)+1);
	strcpy($$.tipo,"logico");
	$$.label = $1.label;
	
}

| T_KW_FALSO {
	$$.tipo = (string) malloc(sizeof(char)*strlen($1.label)+1);
	strcpy($$.tipo,"logico");
	$$.label = $1.label;
	
}
	
//func_decls: "funcao" T_IDENTIFICADOR "(" fparams'?' ")" '('":" PRIM_TYPE')''?' fvar_decl stm_block


func_decls: "funcao" T_IDENTIFICADOR '(' ')' fvar_decl stm_block { 
	if(passada == 1)
		addFuncao($2.label,"",contLinhaFunc);
	
}

| "funcao" T_IDENTIFICADOR '(' ')' stm_block { 
	if(passada == 1)
		addFuncao($2.label,"",contLinhaFunc);
	
}

| "funcao" T_IDENTIFICADOR '(' fparams')' ':' PRIM_TYPE fvar_decl stm_block { 
	if(passada == 1)
		addFuncao($2.label,$7.label,contLinhaFunc);
	
	
}
| "funcao" T_IDENTIFICADOR '(' fparams')' ':' PRIM_TYPE stm_block { 
	if(passada == 1)
		addFuncao($2.label,$7.label,contLinhaFunc);
	
}

| "funcao" T_IDENTIFICADOR '(' fparams')' fvar_decl stm_block { 
	if(passada == 1)
		addFuncao($2.label,"",contLinhaFunc);

}

| "funcao" T_IDENTIFICADOR '(' fparams')' stm_block { 
	if(passada == 1)
		addFuncao($2.label,"",contLinhaFunc);
	
}

| "funcao" T_IDENTIFICADOR '(' ')' ':' PRIM_TYPE fvar_decl stm_block { 
	if(passada == 1)
		addFuncao($2.label,$6.label,contLinhaFunc);
}

| "funcao" T_IDENTIFICADOR '(' ')' ':' PRIM_TYPE stm_block { 
	if(passada == 1)
		addFuncao($2.label,$6.label,contLinhaFunc);
	
}

stm_rec: stm_list {
	
}

| stm_rec stm_list {
	
}	

fvar_decl: var_decl ';' {
	
	
}

| fvar_decl var_decl ';' {
	
}

//fparams: fparam '('"," fparam')''*'
fparams: fparam {
	
}

| fparams ',' fparam {
	
}

fparam: T_IDENTIFICADOR ':' tp_matriz {
	
}
| T_IDENTIFICADOR ':' PRIM_TYPE {
	if(passada == 1)
		addParams(contLinha,$1.label,$3.label);
	
	
}
%%
int main(int argc, char **args ) 
{	
	zerarHash();
	addFuncao("imprima","",0);
	aridade = 0;
	addFuncao("leia","",-1);
	yyin = fopen(args[1],"r");
	yyparse();
	fclose(yyin);	
	
	contLinha = 1;
	
	escopo = 1;
	passada = 2;
	yyin = fopen(args[1],"r");
	yyparse();
	fclose(yyin);
	
	
	
	//imprimir();

	return 0;
}



