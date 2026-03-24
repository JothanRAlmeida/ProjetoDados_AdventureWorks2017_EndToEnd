-- TRANSFORMAÇÃO - CAMADA LÓGICA

/*
	Prepara os dados para análise
	Usa Views
	Define granularidade
	Cria métricas
	Limpa dados
	Faz JOINs
*/

-- VIEW DE VENDA - BASE DA TABELA FATO

/*
	Corverti a data para não ter horário, desnecessário neste caso pois estava zerado
	Não arredondei os valores monetários para maior precisão nos resultados
	Filtrei a quantidade para não ter vendas de zero produtos ou negativos
*/

CREATE VIEW vw_Vendas AS
SELECT 
	H.SalesOrderID AS id_venda,
	CAST(H.OrderDate AS DATE) AS data,
	H.CustomerID AS id_cliente,
	D.ProductID AS id_produto,
	D.OrderQty AS quantidade,
	D.UnitPrice AS preco_unitario,
	D.LineTotal AS valor_total
FROM stg_SalesOrderHeader H
JOIN stg_SalesOrderDetail D
	ON H.SalesOrderID = D.SalesOrderID
WHERE D.OrderQty > 0






-- Validar a regra de valor total
SELECT 
	D.LineTotal AS ValorTotal,
	D.LineTotal - ((D.OrderQty * D.UnitPrice * (1 - D.UnitPriceDiscount))) AS Validacao
FROM Sales.SalesOrderHeader H
JOIN Sales.SalesOrderDetail D
	ON H.SalesOrderID = D.SalesOrderID