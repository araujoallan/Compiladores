//Hash Table usando Chainning com Lista simples encadeada
#include "tabelaHash.h"

Hash hashIden[HASHLEN];
Hash hashFunc[HASHLEN];

Identificador *fIden = NULL, *fParam = NULL , *virgulaDecl = NULL;

int aridade = -1;

uint joaat(string buf, int len) {
  uint h = 0;
  int i;

  for (i = 0; i < len; i++) {
    h += buf[i];
    h += (h << 10);
    h ^= (h >> 6);
  }
  h += (h << 3);
  h ^= (h >> 11);
  h += (h << 15);

  return h % HASHLEN;
}

void checarAridade(string nome,int linha)
{	
	int pos = joaat(nome,strlen(nome));
	Funcao *func = (Funcao*) hashFunc[pos].head;	
	
	if(func->aridade == -1) //caso da funcao imprima
	{
		if(aridade == 0)
		{			
			printf("Erro semantico na linha %d: a funcao '%s' foi chamada com %d argumentos mas declarada com %d parametros.\n",linha,nome,aridade,func->aridade);
			exit(1);
		}
			
	}
	else
	{
	
		if(aridade != func->aridade)
		{
			printf("Erro semantico na linha %d: a funcao '%s' foi chamada com %d argumentos mas declarada com %d parametros.\n",linha,nome,aridade,func->aridade);
			exit(1);
		}
		
		Identificador *aux = func->params, *aux2 = fParam;
		
		while(aux != NULL)
		{
			if(strcmp(aux->tipo,aux2->tipo))
			{				
				printf("Erro semantico na linha %d: expressao com tipos de dados incompativeis.\n",linha);
				exit(1);
			}
			
			aux = aux->prox;
			aux2 = aux2->prox;
		}
	}
		
	fParam = NULL;
	aridade = 0;
}


void addArgs(int linha, string nome, string tipo)
{
	Identificador *p;
	
	p = fParam;	
	
	Identificador *ind = (Identificador*) malloc (sizeof(Identificador));
	ind->linha = linha;
	ind->nome = (string) malloc(sizeof(char)*strlen(nome)+1);
	strcpy(ind->nome,nome);
	ind->tipo = (string) malloc(sizeof(char)*strlen(tipo)+1);
	strcpy(ind->tipo,tipo);	

	aridade++;
	
	if(fParam == NULL)
		fParam = ind;
	else
	{
		p = fParam;		
		while(p->prox != NULL)
			p = p->prox;
		
		p->prox = ind;
	}	
}

string procurarDecl(Identificador *lista, string nome)
{
	Identificador *aux =  lista;
	while(aux != NULL)
	{			
		if(!strcmp(aux->nome,nome))		
			return aux->tipo;		
		aux  = aux->prox;
	}	

	return NULL;
}

Funcao* procurarHashFunc(string nome)
{
	int pos;
	Funcao *aux;
	
	pos = joaat(nome,strlen(nome));
	
	aux = (Funcao*) hashFunc[pos].head;	
	
	while(aux != NULL)
	{				
		if(!strcmp(aux->nome,nome))
			return aux;
			
		aux = aux->prox;
	}
	 return NULL;
}

Identificador* procurarHashIden(string nome)
{
	int pos;
	Identificador *aux;
	
	pos = joaat(nome,strlen(nome));
	
	aux = (Identificador*) hashIden[pos].head;	
	
	while(aux != NULL)
	{		
		
		if(!strcmp(aux->nome,nome))
			return aux;
		
		
		aux = aux->prox;
	}
	return NULL;
	
	
}

void addVirgFunc(int linha, string nome)
{
	Identificador *new,*p;
	
	p = virgulaDecl;
	
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: variavel '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}
	
	p = fParam;
	
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: variavel '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}
		
	Identificador *ind = (Identificador*) malloc (sizeof(Identificador));
	ind->linha = linha;
	ind->nome = (string) malloc(sizeof(char)*strlen(nome)+1);
	strcpy(ind->nome,nome);		
	
	new = virgulaDecl;
	virgulaDecl = ind;
	
	virgulaDecl->prox = new;  
	
	
}

void addVar(string tipo, int escopo)
{
	Identificador *aux;
	
	if(escopo == 1)		
	{
		aux = fIden;
		while(aux != NULL)
		{			
			addIdentificador(aux->linha,aux->nome,tipo);
			aux = aux->prox;		
		}
		fIden = NULL;
		
	}
	
	if(escopo == 2)
	{
		aux = virgulaDecl;
		while(aux != NULL)
		{			
			aux->tipo = (string) malloc (sizeof(char)*strlen(tipo)+1);
			strcpy(aux->tipo,tipo);
			aux = aux->prox;		
		}
		
		if(fIden == NULL)		
			fIden = virgulaDecl;
		else
		{
			aux = fIden;
			
			while(aux->prox != NULL)
				aux = aux->prox;
				
			aux->prox = virgulaDecl;			
		}
	}		
	
	virgulaDecl = NULL;
		
}

void addParams(int linha, string nome, string tipo)
{
	Identificador *p;
	
	p = fParam;
	
	aridade++;
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: variavel '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}	
	
	
	Identificador *ind = (Identificador*) malloc (sizeof(Identificador));
	ind->linha = linha;
	ind->nome = (string) malloc(sizeof(char)*strlen(nome)+1);
	strcpy(ind->nome,nome);
	ind->tipo = (string) malloc(sizeof(char)*strlen(tipo)+1);
	strcpy(ind->tipo,tipo);		
	
	if(fParam == NULL)
		fParam = ind;
	else
	{
		p = fParam;		
		while(p->prox != NULL)
			p = p->prox;
		
		p->prox = ind;
	}	
}

void addIden(int linha, string nome, string tipo)
{
	Identificador *new,*p;
	
	
	p = fParam;
	
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: variavel '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}
	
	p = fIden;
	
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: variavel '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}
	
	
	
	Identificador *ind = (Identificador*) malloc (sizeof(Identificador));
	ind->linha = linha;
	ind->nome = (string) malloc(sizeof(char)*strlen(nome)+1);
	strcpy(ind->nome,nome);
	ind->tipo = (string) malloc(sizeof(char)*strlen(tipo)+1);
	strcpy(ind->tipo,tipo);		
	
	new = fIden;
	fIden = ind;
	
	ind->prox = new;  
}

void addFuncao(string nome,string tipoRetorno,int linha)
{
	Funcao *p, *tail;
	int pos;
	pos = joaat(nome,strlen(nome));
	p = (Funcao*) hashFunc[pos].head;
	
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: funcao '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}
	Funcao *func = (Funcao*) malloc(sizeof(Funcao));
	func->nome = (string) malloc(sizeof(char)*strlen(nome)+1);
	strcpy(func->nome,nome);
	func->tipoRetorno = (string) malloc(sizeof(char)*strlen(tipoRetorno)+1);
	strcpy(func->tipoRetorno,tipoRetorno);
	func->aridade = aridade;
	aridade = 0;
	func->linha = linha;
	func->vars = fIden;
	fIden = NULL;
	func->params = fParam;
	fParam = NULL;
	
	tail = hashFunc[pos].head;
	hashFunc[pos].head = func;
	func->prox = tail;
	
}

void addIdentificador(int linha,string nome,string tipo) {
	int pos;
	Identificador *new, *p;	
	pos = joaat(nome,strlen(nome));
	
	p = (Identificador*) hashIden[pos].head;
	
	while(p != NULL)
	{
		if(!strcmp(nome,p->nome))
		{	
			printf("Erro semantico na linha %d: variavel '%s' ja foi declarada na linha %d.\n",linha, nome,p->linha);
			exit(1);
		}
		p = p->prox;
	}
	
	
	Identificador *ind = (Identificador*) malloc (sizeof(Identificador));
	ind->linha = linha;
	ind->nome = (string) malloc(sizeof(char)*strlen(nome)+1);
	strcpy(ind->nome,nome);
	ind->tipo = (string) malloc(sizeof(char)*strlen(tipo)+1);
	strcpy(ind->tipo,tipo);		
	
	
	new = hashIden[pos].head;
	hashIden[pos].head = ind;
	
	ind->prox = new;  

}

void imprimir(){
	Identificador *ide;
	Funcao *func;
	int i;	

	for(i=0;i<HASHLEN;i++)
	{
		if(hashIden[i].head != NULL)
		{
			
			ide = (Identificador*) hashIden[i].head;
			
			while(ide != NULL)
			{
				printf("Identificador: %s\n",ide->nome);
				printf("Linha: %d\n",ide->linha);
				printf("Tipo: %s\n",ide->tipo);
				printf("Pos = %d\n",i);
				printf("\n");
				
				ide = ide->prox;
			}
		}
		
	}
	printf("\n");
	
	for(i=0;i<HASHLEN;i++)
	{
		if(hashFunc[i].head != NULL)
		{
			func = (Funcao*) hashFunc[i].head;
			
			while(func != NULL)
			{
				printf("Funcao: %s\n",func->nome);
				printf("Linha: %d\n",func->linha);
				printf("Tipo: %s\n", func->tipoRetorno);
				printf("Aridade: %d\n",func->aridade);
				printf("Pos = %d\n",i);
				printf("Parametros:(");
				ide = func->params;
				while(ide != NULL)
				{
					printf("%s : %s  ",ide->nome, ide->tipo);
					ide = ide->prox;
				}
				
				printf(")\nIdentificadores:\n");
				ide = func->vars;
				while(ide != NULL)
				{
					printf("\tNome: %s| Tipo: %s | Linha: %d \n",ide->nome, ide->tipo,ide->linha);
					ide = ide->prox;
				}
				
				printf("\n");
				func = func->prox;
			}
		}
	}
	
	ide = fIden;
	while(ide != NULL)
	{
		printf("Identificador: %s\n",ide->nome);
		printf("Linha: %d\n",ide->linha);
		printf("Tipo: %s\n",ide->tipo);
		
		printf("\n");
		ide = ide->prox;
	}	
	

}

void zerarHash()
{
	int i;
	for(i=0;i<HASHLEN;i++)
	{
		hashIden[i].head = NULL;
		hashFunc[i].head = NULL;
	}
	
	
}





