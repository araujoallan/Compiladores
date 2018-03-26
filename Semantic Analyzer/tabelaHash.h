#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define HASHLEN 61

typedef char* string;

typedef struct parametros {
	string nome;
	struct parametros *prox;
}Parametros;

typedef struct identificador {
    	int linha;
		string nome;
    	string tipo;
    	struct identificador *prox;
}Identificador;

typedef struct funcao{
	string nome, tipoRetorno;
	struct identificador *vars, *params;	
	int aridade,linha;
	struct funcao *prox;
}Funcao;

typedef struct hash {
	void *head;
}Hash;


void addFuncao(string,string,int);
void addIdentificador(int,string,string);
void addIden(int,string nome, string tipo); //função utilizada para criar a lista de identificadores das funções
void addParams(int linha, string nome, string tipo); // função utilizada para criar a lista de parametros das funções
void addVar(string tipo, int escopo); //adiciona na hash de funcao/identificadores as variaaveis com declaração do tipo x,y : inteiro;
void addVirgFunc(int linha, string nome);
Identificador* procurarHashIden(string nome);
Funcao* procurarHashFunc(string nome);
string procurarDecl(Identificador *lista, string nome);
void addArgs(int linha, string nome, string tipo);
void checarAridade(string nome,int linha);
void zerarHash();
uint joaat(string, int);
void imprimir();
