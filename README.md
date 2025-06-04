# Stochastic-Capacitated-Perishable-Lot-Sizing-Problem-for-Wholesale-Supply-Chains
# SPCLSP - Dimensionamento de Lotes com Capacidade e Perecibilidade sob Demanda Estocástica

Este repositório contém o modelo matemático de dimensionamento de lotes para cadeias de suprimentos atacadistas com produtos perecíveis, sob demanda estocástica. O modelo foi desenvolvido em OPL (Optimization Programming Language) e pode ser resolvido com o IBM ILOG CPLEX.

## 🧩 Características do Modelo

- Demanda incerta representada por múltiplos cenários com probabilidades associadas.
- Produtos com tempo de validade (perecíveis).
- Capacidade limitada de:
  - Armazenamento (cozinha e congelador)
  - Transporte
  - Compra por período
- Faixas de desconto e lotes mínimos/máximos por faixa.
- Estoque mínimo por produto.
- Penalizações por:
  - Descarte de produtos vencidos
  - Falta de atendimento à demanda
- Custo fixo por compra em cada período.

## 📁 Estrutura dos dados

O modelo depende dos seguintes conjuntos e parâmetros:

- **Conjuntos**: Produtos, Períodos, Faixas de desconto, Cenários.
- **Parâmetros**: 
  - Demanda `D[i][j][s]`
  - Custo de compra por faixa `C[i][j][f]`
  - Validade `V[i]`
  - Estoque inicial `E_0[i][s]`
  - Volume dos produtos `W[i]`
  - Limites de compra `Q_min`, `Q_max`
  - Capacidades `C_CON`, `C_COZ`, `C_CAR`
  - Penalizações `rho` (descarte), `mu` (falta)
  - Probabilidade dos cenários `pi[s]`

## 🎯 Função Objetivo

Minimiza o custo total esperado, que inclui:
- Custos fixos por compra
- Custo total de aquisição (com descontos)
- Custo esperado com descarte de perecíveis
- Custo esperado com falta de produtos

## 🛠️ Tecnologias

- **OPL (Optimization Programming Language)**
- **CPLEX** (para resolução do modelo)

## 🧪 Como usar

1. Instale o IBM ILOG CPLEX Optimization Studio.
2. Crie um projeto e insira o arquivo `.mod` (modelo) e `.dat` (instância com os dados).
3. Execute o modelo.
4. Analise os resultados para diferentes cenários.

## 📌 Observações

- A estrutura de tempo considera um horizonte com `PeriodosR = -4..T` para ajustes de tempo de entrega.
- O modelo utiliza variáveis inteiras e booleanas, sendo um MIP de média a alta complexidade.

## 📄 Licença

Este projeto é de uso acadêmico. Caso deseje utilizar em aplicações comerciais ou publicações, por favor entre em contato.

---

João Pedro Gouvêa de Camargo  
[Bacharel em Matemática Industrial - CEUNES]  
[LinkedIn: www.linkedin.com/in/joaopedrogcamargo]
[e-mail: joao.cgouveia@hotmail.com]
