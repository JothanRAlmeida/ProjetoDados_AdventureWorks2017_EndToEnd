--Pedidos
SELECT * FROM Sales.SalesOrderHeader

--Itens do pedido
SELECT * FROM Sales.SalesOrderDetail

--Cliente
SELECT * FROM Sales.Customer

SELECT * FROM Person.Person

--Produtos
SELECT * FROM Production.Product

SELECT * FROM Production.ProductSubcategory

SELECT * FROM Production.ProductCategory

-- Auxiliares
SELECT * FROM Person.BusinessEntityAddress

SELECT * FROM Person.Address

SELECT * FROM Person.AddressType

SELECT * FROM Person.StateProvince

SELECT * FROM Person.CountryRegion



SELECT * 
FROM Person.BusinessEntityAddress
WHERE BusinessEntityID in (
	SELECT 
		BusinessEntityID
	FROM Person.BusinessEntityAddress
	GROUP BY BusinessEntityID
	HAVING COUNT(*) > 1
)