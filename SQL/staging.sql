-- STAGING CRIAR CÓPIA DOS DADOS

/*
	Camada intermediária
	Simula um processo de ingestão (ETL/ELT)
	Evita mexer direto no OLTP
	Cria isolamento
	Base para transformação
*/


SELECT * INTO stg_SalesOrderHeader FROM Sales.SalesOrderHeader;
SELECT * INTO stg_SalesOrderDetail FROM Sales.SalesOrderDetail;
SELECT * INTO stg_Customer FROM Sales.Customer;
SELECT * INTO stg_Person FROM Person.Person;
SELECT * INTO stg_Product FROM Production.Product;
SELECT * INTO stg_ProductSubcategory FROM Production.ProductSubcategory;
SELECT * INTO stg_ProductCategory FROM Production.ProductCategory;
