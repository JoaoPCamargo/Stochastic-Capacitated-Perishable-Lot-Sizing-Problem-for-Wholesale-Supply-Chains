// Arquivo: SPCLSP-W.mod
// Problema de Dimensionamento de Lotes com Capacidade e Perecibilidade sob Demanda Estocástica para Cadeias de Suprimentos Atacadistas

//execute {
   //cplex.tilim = 3600; // Limite de tempo de 3600 segundos (1 hora)
   //cplex.epgap = 0.0016; // gap de 0.16%
//}

/* Declaração dos Conjuntos */
int F = ...;  // Número de Faixas
int S = ...;  // Número de Cenários
int T = ...;  // Número de Períodos
int I = ...;  // Número de Produtos

range Faixas = 1..F;      // Conjunto das Faixas de Desconto
range Cenarios = 1..S;    // Conjunto dos Cenarios
range PeriodosR = -4..T;  // Conjunto do Horizonte de Planejamento (ajuste manual de lambda)
range Periodos = 1..T;    // Subconjunto do Horizonte
range Periodos_ = 0..T;   // Subconjunto do Horizonte
range Produtos = 1..I;    // Conjunto dos Insumos
{int} CON = ...;          // Subconjunto dos Insumos
{int} COZ = ... ;         // Subconjunto dos Insumos

/* Declaração dos parâmetros */
float D[Produtos][Periodos][Cenarios] = ... ; // Demanda
float C[Produtos][PeriodosR][Faixas] = ...;   // Custo de Compra
int Q_max[Produtos][Faixas] = ...;            // Quantida Máxima por Faixa
float E_0[Produtos][Cenarios] = ...;          // Estoque Inicial
int V[Produtos] = ... ;                       // Validade
int L[Produtos] = ... ;                       // Disponibilidade
float W[Produtos] = ... ;                     // Volume
float E_min[Produtos] = ... ;                 // Estoque Mínimo
int U[PeriodosR] = ... ;                      // Custo por Dia
float pi[Cenarios] = ...;                     // Probabilidades dos Cenários
int C_CON = ... ;                             // Capacidade do Congelador
int C_COZ = ... ;                             // Capacidade da Cozinha
int C_CAR = ... ;                             // Capacidade do Transporte
int Q_min = ...;                              // Quantidade Mínima de Compras
int M = ...;                                  // Big-M
int lambda = ...;                             // Valor Máximo em L_i
float delta = ...;			      // Tolerancia
float rho = ...;       			      // Custo Associado a Descartar
float mu = ...;				      // Custo Associado a Faltar


/* Declaração das variáveis de decisão */
dvar int+ x[Produtos][PeriodosR];              // Quantidade Comprada
dvar int+ r[Produtos][PeriodosR];              // Quantidade que Chega
dvar int+ a[Produtos][PeriodosR][Faixas];      // Quantidade Comprada por Faixa
dvar float+ e[Produtos][Periodos_][Cenarios];  // Estoque ao Final do Dia 
dvar float+ z[Produtos][Periodos][Cenarios];   // Quantidade Descartada
dvar float+ u[Produtos][Periodos][Cenarios];   // Quantidade em Falta
dvar boolean y[PeriodosR];                     // Decisão de Comprar
dvar boolean b[Produtos][PeriodosR][Faixas];   // Decisão de Faixa de Desconto 


/* Função Objetivo 01 */
minimize sum(j in PeriodosR) (U[j] * y[j]) +
		 sum(i in Produtos, j in PeriodosR, f in Faixas) (C[i][j][f] * a[i][j][f]) +  
         sum(s in Cenarios) (pi[s] * sum(i in Produtos, j in Periodos, f in Faixas) ((rho * C[i][j][f]) * z[i][j][s])) +
         sum(s in Cenarios) (pi[s] * sum(i in Produtos, j in Periodos, f in Faixas) ((mu * C[i][j][f])  * u[i][j][s]));
         
/* Restrições */
subject to {
    /* Restrição 02 */
    forall(j in Periodos, s in Cenarios) 
        sum(i in CON) (e[i][j][s]) <= C_CON;

    /* Restrição 03 */
    forall(j in Periodos, s in Cenarios) 
        sum(i in COZ) (e[i][j][s]) <= C_COZ;
        
    /* Restrição 04 */
    forall(j in PeriodosR) 
        sum(i in Produtos) (W[i] * r[i][j]) <= C_CAR;
        
    /* Restrição 05 */
    forall(i in Produtos, j in Periodos, s in Cenarios)
   	u[i][j][s] <= delta * D[i][j][s];
        
    /* Restrição 06 */
    forall(j in PeriodosR) 
       sum(i in Produtos) (x[i][j]) >= (Q_min * y[j]);
        
    /* Restição 07 */
	forall(i in Produtos, j in PeriodosR)
   		x[i][j] <= M * y[j];
        
    /* Restrição 08 */   
    forall(i in Produtos, j in lambda..T-L[i])   
        x[i][j] == r[i][j+L[i]]; 
        
    /* Restrição 09 */
    forall(i in Produtos, j in PeriodosR)
        x[i][j] == sum(f in Faixas)(a[i][j][f]); 
        
    /* Restrição 10 */
    forall(i in Produtos, j in PeriodosR, f in Faixas)
        a[i][j][f] <= Q_max[i][f] * b[i][j][f];
        
    /* Restrição 11 */
    forall(i in Produtos, j in PeriodosR)
        sum(f in Faixas)(b[i][j][f]) == 1;  

    /* Restrição 12 */
    forall(i in Produtos, j in Periodos_, s in Cenarios) 
        e[i][j][s] >= E_min[i];
        
    /* Restrição 13 */
    forall(i in Produtos, s in Cenarios)
        e[i][0][s] == E_0[i][s];
        
    /* Restrição 14 */
    forall(i in Produtos, j in Periodos, s in Cenarios) 
        e[i][j][s] == e[i][j-1][s] + (W[i] * r[i][j]) - D[i][j][s] - z[i][j][s] + u[i][j][s]; 

    /* Restrição 15 */
    forall(i in Produtos, j in V[i]..T-1, s in Cenarios)
        z[i][j+1][s] >= W[i] * r[i][j-V[i]+1] - sum(k in j-V[i]+1..j)(D[i][k][s]); 
}
