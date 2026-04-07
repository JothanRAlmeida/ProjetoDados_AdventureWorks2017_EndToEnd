-- TRANSFORMAÇÃO - CAMADA LÓGICA

/*
	Corverti a data para não ter horário, desnecessário neste caso pois estava zerado
	Peguei apenas as duas primeiras casas dos valores monetários com arredondamento
	Na view de Vendas filtrei a quantidade para não ter vendas de zero produtos ou negativos
*/

-- VIEW DE VENDA - BASE DA TABELA FATO
CREATE VIEW vw_Vendas AS
SELECT 
	H.SalesOrderID AS id_venda,
	H.CustomerID AS id_cliente,
	D.ProductID AS id_produto,
	CAST(H.OrderDate AS DATE) AS data_pedido,
	D.OrderQty AS quantidade,
	ROUND(D.LineTotal,2) AS valor_total
FROM stg_SalesOrderHeader H
JOIN stg_SalesOrderDetail D
	ON H.SalesOrderID = D.SalesOrderID
WHERE D.OrderQty > 0


-- VIEW DE CUSTO DO PRODUTO
--A view abaixo foi desenvolvida para aperfeiçoamento futuro do projeto
CREATE VIEW vw_CustoProduto AS
SELECT 
	SD.ProductID AS id_produto, 
	CAST(PH.StartDate AS DATE) AS data_inicio_custo, 
	CAST(PH.EndDate AS DATE) AS data_fim_custo, 
	ROUND(PH.StandardCost,2) AS custo
FROM stg_SalesOrderHeader SH
JOIN stg_SalesOrderDetail SD
	ON SH.SalesOrderID = SD.SalesOrderID
JOIN stg_ProductCostHistory PH
	ON SD.ProductID = PH.ProductID
WHERE PH.StartDate <= SH.OrderDate 
	AND (PH.EndDate >= SH.OrderDate OR PH.EndDate IS NULL)
GROUP BY SD.ProductID, PH.StartDate, PH.EndDate, PH.StandardCost
ORDER BY SD.ProductID