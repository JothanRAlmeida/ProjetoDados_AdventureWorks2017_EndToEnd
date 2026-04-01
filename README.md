# 📊 Projeto de Data Warehouse e BI — AdventureWorks2017

## Visão Geral

Este projeto tem como objetivo demonstrar a construção de um pipeline completo de dados, desde a extração em um banco transacional até a análise final em um dashboard interativo.

A base utilizada foi a AdventureWorks2017, simulando um ambiente real de vendas.

## Arquitetura do Projeto

O fluxo de dados foi estruturado seguindo boas práticas de engenharia de dados:

OLTP (AdventureWorks) -> Staging (`stg\_`) -> Transformação (views) -> Data Warehouse (fato + dimensões) -> Power BI (dashboard)

## Etapas do Projeto

### 1. Modelagem Dimensional (Star Schema)

Foi desenvolvido um modelo dimensional com:

- **Tabela Fato**
  - `f_vendas`: armazena métricas como quantidade e valor total das vendas

- **Tabelas Dimensão**
  - `d_cliente`
  - `d_produto`
  - `d_calendario`

O modelo segue o padrão **Star Schema**, otimizado para consultas analíticas.

### 2. Camada Staging

Foram criadas tabelas intermediárias (`stg_`) como cópia dos dados do OLTP:

- `stg_salesorderheader`
- `stg_salesorderdetail`
- `stg_customer`
- `stg_product`

Objetivo: isolar a fonte de dados e preparar para transformação.

### 3. Transformação de Dados

Utilização de **views** (`vw_`) para:

- Definir granularidade (1 linha = 1 item vendido)
- Realizar JOINs entre tabelas
- Criar métricas como `valor_total`

Exemplo:

- `vw_vendas`

### 4. Data Warehouse

Criação do modelo dimensional físico:

- Fato: `f_vendas`
- Dimensões: `d_cliente`, `d_produto`, `d_calendario`

Dados tratados, integrados e prontos para análise.

### 5. Power BI

Desenvolvimento de dashboard com:

#### KPIs:

- Faturamento total
- Quantidade vendida
- Ticket médio

#### Visualizações:

- Evolução de vendas ao longo do tempo
- Top produtos
- Análise por categoria

## 📊 Principais Insights

A partir da análise dos dados no Power BI, é possível extrair insights relevantes de negócio:

### Sazonalidade de Vendas

- Identificação de períodos com maior faturamento (ex: picos mensais)
- Possível influência de sazonalidade ou campanhas

### Performance de Produtos

- Identificação dos produtos mais vendidos
- Concentração de receita em poucos itens

### Análise por Categoria

- Categorias com maior participação no faturamento
- Diferença entre volume de vendas e valor gerado

### Ticket Médio

- Avaliação do valor médio por venda
- Apoio na definição de estratégias comerciais

## Tecnologias Utilizadas

- SQL Server
- T-SQL
- Power BI
- Modelagem Dimensional

## Objetivo do Projeto

Demonstrar na prática:

- Construção de pipeline de dados
- Modelagem dimensional (Star Schema)
- Transformação e tratamento de dados
- Criação de dashboards analíticos

## Possíveis Evoluções

- Automatização do ETL
- Uso de Python para ingestão de dados
- Deploy em ambiente cloud (Azure, AWS)
- Incremento de novas métricas e dimensões
