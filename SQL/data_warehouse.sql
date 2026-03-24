-- DATA WAREHOUSE

/*
	Criação da tabela fato:
		Armazena métricas de negócio
		Responder perguntas
	Criação das tabelas de dimensão:
		Descrever quem compra
		Descrever o que é vendido
*/

-- TABELA FATO DE VENDA
CREATE TABLE F_Venda (
	id_venda INT PRIMARY KEY IDENTITY (1,1),
	id_cliente INT NOT NULL,
	id_produto INT NOT NULL,
	id_data INT NOT NULL,
	quantidade INT NOT NULL,
	valor_total DECIMAL (18,2) NOT NULL
);

/*
	O nome do cliente foi limpo
	Foi feita a distinsão de pessoa física e pessoa jurídica para filtro
	Também foi criada a coluna de recebe_promocao para filtro e análise de tendência
*/

-- DIMENSÃO CLIENTE
SELECT DISTINCT
	C.CustomerID AS id_cliente,
	TRIM(CONCAT(P.FirstName,' ',P.LastName)) AS nome,
	CASE 
		WHEN P.PersonType = 'IN' THEN 'PF'
		WHEN P.PersonType = 'SC' THEN 'PJ'
		ELSE NULL
		END AS tipo_pessoa,
	CASE
		WHEN P.EmailPromotion = 0 THEN 'Não'
		ELSE 'Sim'
	END AS recebe_promocao
INTO D_Cliente
FROM stg_Customer C
JOIN stg_Person P
	ON C.PersonID = P.BusinessEntityID


/*
	O nome, subcategoria e categoria foram limpos
	Retirado horário das datas pois estavam zerados
	Criado um campo ativo para filtrar produtos que ainda são vendidos e outros que não são mais
*/

-- DIMENSÃO PRODUTO
SELECT
	P.ProductID AS id_produto,
	TRIM(P.Name) AS nome,
	TRIM(PS.Name) AS subcategoria,
	TRIM(PC.Name) AS categoria,
	CAST(P.SellStartDate AS DATE) AS inicio_vendas,
	CAST(P.SellEndDate AS DATE) AS fim_vendas,
	CASE
		WHEN P.SellEndDate IS NULL THEN 1
		ELSE 0
	END AS ativo
INTO D_Produto
FROM stg_Product P
JOIN stg_ProductSubcategory PS 
	ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN stg_ProductCategory PC
	ON PS.ProductCategoryID = PC.ProductCategoryID


-- DIMENSÃO TEMPO
CREATE TABLE D_Calendario (
	id_data INT PRIMARY KEY IDENTITY(1,1),
	data DATE NOT NULL,
	dia INT NOT NULL,
	mes INT NOT NULL,
	nome_mes VARCHAR(10) NOT NULL,
	ano INT NOT NULL,
	trimestre INT NOT NULL,
	nome_dia_semana VARCHAR(15) NOT NULL,
	dia_semana INT NOT NULL,
	fim_semana INT NOT NULL
);

-- POPULA DADOS CALENDARIO
SET LANGUAGE Portuguese;
DECLARE @DataInicio DATE = '2000-01-01';
DECLARE @DataFim DATE = '2030-12-31';

;WITH CTE_Datas AS (
    SELECT @DataInicio AS Data
    UNION ALL
    SELECT DATEADD(DAY, 1, Data)
    FROM CTE_Datas
    WHERE Data < @DataFim
)
INSERT INTO D_Calendario (data, ano, mes, nome_mes, dia, trimestre, dia_semana, nome_dia_semana, fim_semana)
SELECT
    Data,
    YEAR(Data),
    MONTH(Data),
    DATENAME(MONTH, Data),
    DAY(Data),
    DATEPART(QUARTER, Data), --Trimestre
    DATEPART(DW, Data), --DiaSemana
    DATENAME(DW, Data), --NomeDiaSemana
    CASE WHEN DATEPART(DW, Data) IN (1, 7) THEN 1 ELSE 0 END-- 1=Domingo, 7=Sábado
FROM CTE_Datas
OPTION (MAXRECURSION 0); -- Necessário para intervalos longos


-- POPULA TABELA FATO
INSERT INTO F_VENDA(id_cliente, id_produto, id_data, quantidade, valor_total)
SELECT 
	V.id_cliente,
	V.id_produto,
	C.id_data,
	V.quantidade,
	V.valor_total
FROM vw_Vendas V
JOIN D_Calendario C
	ON V.data = C.data

SELECT * FROM F_Venda
