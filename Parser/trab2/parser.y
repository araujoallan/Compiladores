%{
#include<stdio.h>
int yylex(void);
void yyerror(char const *s);
#include<math.h>
int node = 0;
%}

%union{
	int nNode;
	
	struct label_nNode{
		int nNode;
		char* label;
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
%type <nNode> declaracao_algoritmo stm_block algoritmo_goal var_decl var_decl_block vdb_B
%type <nNode> func_decls_A vb_B func_decls tp_matriz stmb_B stm_list lvalue stm_attr expr
%type <nNode> termo literal tp_mat_B fcall stm_para stm_se stm_enquanto stm_ret lvalue_B
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
algoritmo_goal: declaracao_algoritmo var_decl_block stm_block func_decls_A{
		$$ = node; node++;
		printf("node%d[label=\"algoritmo_goal\"];\n",$$);
		printf("node%d -> node%d;\n",$$,$1);
		printf("node%d -> node%d;\n",$$,$2);
		printf("node%d -> node%d;\n",$$,$3);
		printf("node%d -> node%d;\n",$$,$4);
		printf("}");
}

| declaracao_algoritmo var_decl_block stm_block{
		$$ = node; node++;
		printf("node%d[label=\"algoritmo_goal\"];\n",$$);
		printf("node%d -> node%d;\n",$$,$1);
		printf("node%d -> node%d;\n",$$,$2);
		printf("node%d -> node%d;\n",$$,$3);
		printf("}");
}
| declaracao_algoritmo stm_block{
		$$ = node; node++;
		printf("node%d[label=\"algoritmo_goal\"];\n",$$);
		printf("node%d -> node%d;\n",$$,$1);
		printf("node%d -> node%d;\n",$$,$2);
		printf("}");
	
}
| declaracao_algoritmo stm_block func_decls_A{
		$$ = node; node++;
		printf("node%d[label=\"algoritmo_goal\"];\n",$$);
		printf("node%d -> node%d;\n",$$,$1);
		printf("node%d -> node%d;\n",$$,$2);
		printf("node%d -> node%d;\n",$$,$3);
		printf("}");
		
}

func_decls_A : func_decls_A func_decls{
	$$ = node; node++;	
	printf("node%d[label=\"func_decls_A\"];\n",$$);
	printf("node%d[label=\"func_decls_A\"];\n",$1);	
	printf("node%d -> node%d;\n",$$,$1);
	printf("node%d[label=\"func_decls\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	
}
| func_decls {
	$$ = node; node++;
	printf("node%d[label=\"func_decls_A\"];\n",$$);
	printf("node%d -> node%d;\n",$$,$1);
	
}


declaracao_algoritmo: "algoritmo" T_IDENTIFICADOR ';' {
	$$ = node; node++;
	printf("digraph {\n");
	printf("graph [ordering=\"out\"];\n");
	printf("node%d[label=\"declaracao_algoritmo\"];\n",$$);
	printf("node%d[label=\"algoritmo\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	printf("node%d[label=\";\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);										
}


//var_decl_block : "variaveis" var_decl ';' "fim_variaveis"
var_decl_block: "variaveis" vdb_B "fim_variaveis"{
	$$ = node; node++;
	printf("node%d[label=\"var_decl_block\"];\n",$$);
	printf("node%d[label=\"variaveis\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	printf("node%d[label=\"vdb_B\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);	
	printf("node%d[label=\"fim_variaveis\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
}
vdb_B: vdb_B var_decl ';'{
	$$ = node; node++;
	printf("node%d[label=\"vdb_B\"];\n",$$);
	printf("node%d[label=\"vdb_B\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	printf("node%d[label=\"var_decl\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);	
	printf("node%d[label=\";\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| var_decl ';'{
	$$ = node; node++;
	printf("node%d[label=\"vdb_B\"];\n",$$);
	printf("node%d[label=\"var_decl\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	printf("node%d[label=\";\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);	
}

//var_decl: T_IDENTIFICADOR "," T_IDENTIFICADOR ":" PRIM_TYPE | tp_matriz
var_decl: T_IDENTIFICADOR vb_B ':' PRIM_TYPE{
			$$ = node; node++;
			printf("node%d[label=\"var_decl\"];\n",$$);
			printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
			printf("node%d -> node%d;\n",$$,$1.nNode);	
			printf("node%d[label=\"vb_B\"];\n",$2);
			printf("node%d -> node%d;\n",$$,$2);
			printf("node%d[label=\":\"];\n",$3);
			printf("node%d -> node%d;\n",$$,$3);
			printf("node%d[label=\"%s\"];\n",$4.nNode,$4.label);
			printf("node%d -> node%d;\n",$$,$4.nNode);
			
}
var_decl: T_IDENTIFICADOR ':' PRIM_TYPE{
	$$ = node; node++;
	printf("node%d[label=\"var_decl\"];\n",$$);
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
	printf("node%d[label=\":\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	printf("node%d[label=\"%s\"];\n",$3.nNode,$3.label);
	printf("node%d -> node%d;\n",$$,$3.nNode);
}

| T_IDENTIFICADOR vb_B ':' tp_matriz{
	$$ = node; node++;
	printf("node%d[label=\"var_decl\"];\n",$$);
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
	printf("node%d[label=\"vb_B\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	printf("node%d[label=\":\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	printf("node%d[label=\"tp_matriz\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
}
| T_IDENTIFICADOR ':' tp_matriz{
$$ = node; node++;
	printf("node%d[label=\"var_decl\"];\n",$$);
	
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);	
	
	
	printf("node%d[label=\":\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"tp_matriz\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
vb_B: vb_B ',' T_IDENTIFICADOR{
	$$ = node; node++;
	printf("node%d[label=\"vb_B\"];\n",$$);
	
	printf("node%d[label=\"vb_B\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\",\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"%s\"];\n",$3.nNode,$3.label);
	printf("node%d -> node%d;\n",$$,$3.nNode);
}
|',' T_IDENTIFICADOR{
	$$ = node; node++;
	printf("node%d[label=\"vb_B\"];\n",$$);
	
	printf("node%d[label=\",\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
}

//tp_matriz: "matriz" ("[" T_INT_LIT "]")+ "de" PRIM_TYPE_PL
tp_matriz: "matriz" tp_mat_B "de" PRIM_TYPE_PL{
	$$ = node; node++;
	printf("node%d[label=\"tp_matriz\"];\n",$$);
	
	printf("node%d[label=\"matriz\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"tp_mat_B\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"de\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"%s\"];\n",$4.nNode,$4.label);
	printf("node%d -> node%d;\n",$$,$4.nNode);
}
tp_mat_B: tp_mat_B '[' T_INT_LIT ']'{
	$$ = node; node++;
	printf("node%d[label=\"tp_mat_B\"];\n",$$);
	
	printf("node%d[label=\"tp_mat_B\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"[\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"%s\"];\n",$3.nNode,$3.label);
	printf("node%d -> node%d;\n",$$,$3.nNode);
	
	printf("node%d[label=\"]\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);	
}
| '[' T_INT_LIT ']' {
	$$ = node; node++;
	printf("node%d[label=\"tp_mat_B\"];\n",$$);
	
	printf("node%d[label=\"[\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"]\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}

//stm_block : "inicio" (stm_list)* "fim"
stm_block : "inicio" "fim"{
			$$ = node; node++;								
			printf("node%d[label=\"stm_block\"];\n",$$);
			
			printf("node%d[label=\"inicio\"];\n",$1);
			printf("node%d -> node%d;\n",$$,$1);
			
			printf("node%d[label=\"fim\"];\n",$2);				
			printf("node%d -> node%d;\n",$$,$2);			
}
| "inicio" stmb_B "fim"{
		$$ = node; node++;								
		printf("node%d[label=\"stm_block\"];\n",$$);
		
		printf("node%d[label=\"inicio\"];\n",$1);
		printf("node%d -> node%d;\n",$$,$1);
		
		printf("node%d[label=\"stmb_B\"];\n",$2);
		printf("node%d -> node%d;\n",$$,$2);
		
		printf("node%d[label=\"fim\"];\n",$3);				
		printf("node%d -> node%d;\n",$$,$3);	

}
stmb_B: stmb_B stm_list{
	$$ = node; node++;								
	printf("node%d[label=\"stmb_B\"];\n",$$);
	
	printf("node%d[label=\"stmb_B\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"stm_list\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	
}
| stm_list{
	$$ = node; node++;								
	printf("node%d[label=\"stmb_B\"];\n",$$);
	
	printf("node%d[label=\"stm_list\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}

stm_list: stm_attr{
	$$ = node; node++;								
	printf("node%d[label=\"stm_list\"];\n",$$);
	
	printf("node%d[label=\"stm_attr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| fcall ';'{
	$$ = node; node++;								
	printf("node%d[label=\"stm_list\"];\n",$$);
	
	printf("node%d[label=\"fcall\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\";\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
| stm_ret{
	$$ = node; node++;								
	printf("node%d[label=\"stm_list\"];\n",$$);
	
	printf("node%d[label=\"stm_ret\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| stm_se{
	$$ = node; node++;								
	printf("node%d[label=\"stm_list\"];\n",$$);
	
	printf("node%d[label=\"stm_se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| stm_enquanto{
	$$ = node; node++;								
	printf("node%d[label=\"stm_list\"];\n",$$);
	
	printf("node%d[label=\"stm_enquanto\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| stm_para{
	$$ = node; node++;								
	printf("node%d[label=\"stm_list\"];\n",$$);
	
	printf("node%d[label=\"stm_para\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}

//stm_ret: "retorne" expr? ";"
stm_ret: "retorne" ';' {
	$$ = node; node++;								
	printf("node%d[label=\"stm_ret\"];\n",$$);
	
	printf("node%d[label=\"retorne\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\";\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
| "retorne" expr ';'{
	$$ = node; node++;								
	printf("node%d[label=\"stm_ret\"];\n",$$);
	
	printf("node%d[label=\"retorne\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\";\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}


stm_attr: lvalue ":=" expr ';'{
	$$ = node; node++;								
	printf("node%d[label=\"stm_attr\"];\n",$$);
		
	printf("node%d[label=\"lvalue\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\":=\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\";\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
}

//lvalue: T_IDENTIFICADOR '('"["expr"]"')''*'
lvalue: T_IDENTIFICADOR{
	$$ = node; node++;								
	printf("node%d[label=\"lvalue\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);	
}
| T_IDENTIFICADOR lvalue_B{
	$$ = node; node++;								
	printf("node%d[label=\"lvalue\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
	
	printf("node%d[label=\"lvalue_B\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
lvalue_B: lvalue_B '['expr']'{
	$$ = node; node++;								
	printf("node%d[label=\"lvalue_B\"];\n",$$);
		
	printf("node%d[label=\"lvalue_B\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"[\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"]\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
}
| '['expr']'{
	$$ = node; node++;								
	printf("node%d[label=\"lvalue_B\"];\n",$$);
		
	printf("node%d[label=\"[\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"]\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}

//precisa aninhar o bloco SE
//stm_se: "se" expr "entao" stm_list '('"senao" stm_list')''?' "fim_se"
stm_se: "se" expr "entao" stm_rec "fim_se"{
	$$ = node; node++;
	printf("node%d[label=\"stm_se\"];\n",$$);
		
	printf("node%d[label=\"se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"entao\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"stm_rec\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"fim_se\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	
}
| "se" expr "entao" "fim_se"{
	$$ = node; node++;
	printf("node%d[label=\"stm_se\"];\n",$$);
		
	printf("node%d[label=\"se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"entao\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"fim_se\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
}
| "se" expr "entao" stm_rec "senao" stm_rec "fim_se"{
	$$ = node; node++;
	printf("node%d[label=\"stm_se\"];\n",$$);
		
	printf("node%d[label=\"se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"entao\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"stm_rec\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"senao\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"stm_rec\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"fim_se\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
	
}
| "se" expr "entao" "senao" stm_rec "fim_se"{
	$$ = node; node++;
	printf("node%d[label=\"stm_se\"];\n",$$);
		
	printf("node%d[label=\"se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"entao\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"senao\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"stm_rec\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"fim_se\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
}
| "se" expr "entao" stm_rec "senao" "fim_se"{
	$$ = node; node++;
	printf("node%d[label=\"stm_se\"];\n",$$);
		
	printf("node%d[label=\"se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"entao\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"stm_rec\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"senao\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"fim_se\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
}
| "se" expr "entao" "senao" "fim_se"{
	$$ = node; node++;
	printf("node%d[label=\"stm_se\"];\n",$$);
		
	printf("node%d[label=\"se\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"entao\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"senao\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"fim_se\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);	
}


//precisa aninhar o bloco ENQUANTO
stm_enquanto: "enquanto" expr "faca" stm_rec "fim_enquanto" {
	$$ = node; node++;
	printf("node%d[label=\"stm_enquanto\"];\n",$$);
		
	printf("node%d[label=\"enquanto\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"faca\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"stm_rec\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"fim_enquanto\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);	
}
| "enquanto" expr "faca" "fim_enquanto"{
	$$ = node; node++;
	printf("node%d[label=\"stm_enquanto\"];\n",$$);
		
	printf("node%d[label=\"enquanto\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"faca\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"fim_enquanto\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
}

//stm_para: "para" lvalue "de" expr "ate" passo'?' "faca" stm_list "fim_para"
stm_para: "para" lvalue "de" expr "ate" expr "faca" "fim_para"{
	$$ = node; node++;
	printf("node%d[label=\"stm_para\"];\n",$$);
		
	printf("node%d[label=\"para\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"lvalue\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"de\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"expr\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"ate\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"expr\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"faca\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
	
	printf("node%d[label=\"fim_para\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
}
| "para" lvalue "de" expr "ate" expr passo "faca" "fim_para"{
	$$ = node; node++;
	printf("node%d[label=\"stm_para\"];\n",$$);
	
	printf("node%d[label=\"para\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"lvalue\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"de\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"expr\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"ate\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"expr\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"passo\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
	
	printf("node%d[label=\"faca\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
	
	printf("node%d[label=\"fim_para\"];\n",$9);
	printf("node%d -> node%d;\n",$$,$9);
}	
| "para" lvalue "de" expr "ate" expr "faca" stm_rec "fim_para"{
	$$ = node; node++;
	printf("node%d[label=\"stm_para\"];\n",$$);
	
	printf("node%d[label=\"para\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"lvalue\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"de\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"expr\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"ate\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"expr\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"faca\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
	
	printf("node%d[label=\"stm_rec\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
	
	printf("node%d[label=\"fim_para\"];\n",$9);
	printf("node%d -> node%d;\n",$$,$9);
}
| "para" lvalue "de" expr "ate" expr passo "faca" stm_rec "fim_para"{
	$$ = node; node++;
	printf("node%d[label=\"stm_para\"];\n",$$);
	
	printf("node%d[label=\"para\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"lvalue\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"de\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"expr\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"ate\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"expr\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"passo\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
	
	printf("node%d[label=\"faca\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
	
	printf("node%d[label=\"stm_rec\"];\n",$9);
	printf("node%d -> node%d;\n",$$,$9);
	
	printf("node%d[label=\"fim_para\"];\n",$10);
	printf("node%d -> node%d;\n",$$,$10);
}

//passo: "passo" '('"+"|"-"')''?' T_INT_LIT
passo: "passo" passo_B{
	$$ = node; node++;
	printf("node%d[label=\"passo\"];\n",$$);
	
	printf("node%d[label=\"passo\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"passo_B\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
passo_B: '+' T_INT_LIT{
	$$ = node; node++;
	printf("node%d[label=\"passo_B\"];\n",$$);
	
	printf("node%d[label=\"+\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
}
| '-' T_INT_LIT{
	$$ = node; node++;
	printf("node%d[label=\"passo_B\"];\n",$$);
	
	printf("node%d[label=\"-\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
}
| T_INT_LIT{
	$$ = node; node++;
	printf("node%d[label=\"passo_B\"];\n",$$);	
	
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}

expr: expr "ou" expr {
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"ou\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr "e" expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"e\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr '|' expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"|\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr '^' expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"^\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr '&' expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"&\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr "=" expr {
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"=\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr "<>" expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"<>\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr ">" expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\">\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr ">=" expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\">=\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr "<" expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"<\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr "<=" expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"<=\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}	
| expr '+' expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"+\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr '-' expr{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"-\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| expr '/' expr	{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"/\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}	
| expr '*' expr	{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"*\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}	
| expr '%' expr	{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"%%\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| '+' termo{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"+\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"termo\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}

| '-' termo {
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"-\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"termo\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
| '~' termo  {
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"~\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"termo\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
| "nao" termo  {
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"nao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"termo\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
| termo	{
	$$ = node; node++;
	printf("node%d[label=\"expr\"];\n",$$);
		
	printf("node%d[label=\"termo\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
}

termo: fcall{
	$$ = node; node++;
	printf("node%d[label=\"termo\"];\n",$$);
		
	printf("node%d[label=\"fcall\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);

}
| lvalue{
	$$ = node; node++;
	printf("node%d[label=\"termo\"];\n",$$);
		
	printf("node%d[label=\"lvalue\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| literal{
	$$ = node; node++;
	printf("node%d[label=\"termo\"];\n",$$);
		
	printf("node%d[label=\"literal\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| '(' expr ')'{
	$$ = node; node++;
	printf("node%d[label=\"termo\"];\n",$$);
	
	printf("node%d[label=\"(\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\")\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}

fcall: T_IDENTIFICADOR fc_B{
	$$ = node; node++;
	printf("node%d[label=\"fcall\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
	
	printf("node%d[label=\"fc_B\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}
fc_B: '(' fargs ')'{
	$$ = node; node++;
	printf("node%d[label=\"fc_B\"];\n",$$);
	
	printf("node%d[label=\"(\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"fargs\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\")\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| '(' ')'{
	$$ = node; node++;
	printf("node%d[label=\"fc_B\"];\n",$$);
	
	printf("node%d[label=\"(\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\")\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}

//fargs: expr '('"," expr')''*'
fargs: expr{
	$$ = node; node++;
	printf("node%d[label=\"fargs\"];\n",$$);
	
	printf("node%d[label=\"expr\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);	
}
| fargs ',' expr{
	$$ = node; node++;
	printf("node%d[label=\"fargs\"];\n",$$);
	
	printf("node%d[label=\"fargs\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\",\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"expr\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| ',' expr{
	$$ = node; node++;
	printf("node%d[label=\"fargs\"];\n",$$);
	
	printf("node%d[label=\",\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"expr\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}

literal: T_STRING_LIT{
	$$ = node; node++;
	printf("node%d[label=\"literal\"];\n",$$);	
		
	printf("node%d[label=%s];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}
| T_INT_LIT{
	$$ = node; node++;
	printf("node%d[label=\"literal\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}
| T_REAL_LIT{
	$$ = node; node++;
	printf("node%d[label=\"literal\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}
| T_CARAC_LIT{
	$$ = node; node++;
	printf("node%d[label=\"literal\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}
| T_KW_VERDADEIRO {
	$$ = node; node++;
	printf("node%d[label=\"literal\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}
| T_KW_FALSO{
	$$ = node; node++;
	printf("node%d[label=\"literal\"];\n",$$);
		
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
}
	
//func_decls: "funcao" T_IDENTIFICADOR "(" fparams'?' ")" '('":" PRIM_TYPE')''?' fvar_decl stm_block

func_decls: "funcao" T_IDENTIFICADOR '(' ')' fvar_decl stm_block {
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);	
	
	printf("node%d[label=\")\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\"fvar_decl\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"stm_block\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
}
| "funcao" T_IDENTIFICADOR '(' ')' stm_block {
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);	
	
	printf("node%d[label=\")\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);		
	
	printf("node%d[label=\"stm_block\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
}

| "funcao" T_IDENTIFICADOR '(' fparams')' ':' PRIM_TYPE fvar_decl stm_block{
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"fparams\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\")\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\":\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"%s\"];\n",$7.nNode,$7.label);
	printf("node%d -> node%d;\n",$$,$7.nNode);
	
	printf("node%d[label=\"fvar_decl\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
	
	printf("node%d[label=\"stm_block\"];\n",$9);
	printf("node%d -> node%d;\n",$$,$9);
}
| "funcao" T_IDENTIFICADOR '(' fparams')' ':' PRIM_TYPE stm_block{
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"fparams\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\")\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\":\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"%s\"];\n",$7.nNode,$7.label);
	printf("node%d -> node%d;\n",$$,$7.nNode);	
	
	printf("node%d[label=\"stm_block\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
}

| "funcao" T_IDENTIFICADOR '(' fparams')' fvar_decl stm_block{
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"fparams\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\")\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);	
	
	printf("node%d[label=\"fvar_decl\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
	
	printf("node%d[label=\"stm_block\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
}

| "funcao" T_IDENTIFICADOR '(' fparams')' stm_block{
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\"fparams\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\")\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);	
	
	printf("node%d[label=\"stm_block\"];\n",$6);
	printf("node%d -> node%d;\n",$$,$6);
}

| "funcao" T_IDENTIFICADOR '(' ')' ':' PRIM_TYPE fvar_decl stm_block{
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\")\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\":\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"%s\"];\n",$6.nNode,$6.label);
	printf("node%d -> node%d;\n",$$,$6.nNode);
	
	printf("node%d[label=\"fvar_decl\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
	
	printf("node%d[label=\"stm_block\"];\n",$8);
	printf("node%d -> node%d;\n",$$,$8);
}

| "funcao" T_IDENTIFICADOR '(' ')' ':' PRIM_TYPE stm_block{
	$$ = node; node++;
	printf("node%d[label=\"func_decls\"];\n",$$);
	
	printf("node%d[label=\"funcao\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
		
	printf("node%d[label=\"%s\"];\n",$2.nNode,$2.label);
	printf("node%d -> node%d;\n",$$,$2.nNode);
	
	printf("node%d[label=\"(\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
	
	printf("node%d[label=\")\"];\n",$4);
	printf("node%d -> node%d;\n",$$,$4);
	
	printf("node%d[label=\":\"];\n",$5);
	printf("node%d -> node%d;\n",$$,$5);
	
	printf("node%d[label=\"%s\"];\n",$6.nNode,$6.label);
	printf("node%d -> node%d;\n",$$,$6.nNode);	
	
	printf("node%d[label=\"stm_block\"];\n",$7);
	printf("node%d -> node%d;\n",$$,$7);
}

stm_rec: stm_list{
	$$ = node; node++;
	printf("node%d[label=\"stm_rec\"];\n",$$);
	
	printf("node%d[label=\"stm_list\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);	
}
| stm_rec stm_list{
	$$ = node; node++;
	printf("node%d[label=\"stm_rec\"];\n",$$);
	
	printf("node%d[label=\"stm_rec\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"stm_list\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
}	

fvar_decl: var_decl ';'{
	$$ = node; node++;
	printf("node%d[label=\"fvar_decl\"];\n",$$);
	
	printf("node%d[label=\"var_decl\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);	
	
	printf("node%d[label=\";\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);	
}
| fvar_decl var_decl ';'{
	$$ = node; node++;
	printf("node%d[label=\"fvar_decl\"];\n",$$);
	
	printf("node%d[label=\"fvar_decl\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\"var_decl\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\";\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);	
}

//fparams: fparam '('"," fparam')''*'
fparams: fparam{
	$$ = node; node++;
	printf("node%d[label=\"fparams\"];\n",$$);
	
	printf("node%d[label=\"fparam\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
}
| fparams ',' fparam{
	$$ = node; node++;
	printf("node%d[label=\"fparams\"];\n",$$);
	
	printf("node%d[label=\"fparams\"];\n",$1);
	printf("node%d -> node%d;\n",$$,$1);
	
	printf("node%d[label=\",\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"fparam\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}

fparam: T_IDENTIFICADOR ':' tp_matriz{
	$$ = node; node++;
	printf("node%d[label=\"fparam\"];\n",$$);
	
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
	
	printf("node%d[label=\":\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"tp_matriz\"];\n",$3);
	printf("node%d -> node%d;\n",$$,$3);
}
| T_IDENTIFICADOR ':' PRIM_TYPE {
	$$ = node; node++;
	printf("node%d[label=\"fparam\"];\n",$$);
	
	printf("node%d[label=\"%s\"];\n",$1.nNode,$1.label);
	printf("node%d -> node%d;\n",$$,$1.nNode);
	
	printf("node%d[label=\":\"];\n",$2);
	printf("node%d -> node%d;\n",$$,$2);
	
	printf("node%d[label=\"%s\"];\n",$3.nNode,$3.label);
	printf("node%d -> node%d;\n",$$,$3.nNode);
}
%%
