--Yuto Wada MWF 8:30-9:20
--Question 1
SELECT C.CustomerID, C.CustomerName, 
SUM(CASE WHEN(O.OrderDate >= '2014-01-01' AND O.OrderDate < '2015-01-01') 
THEN (OL.Quantity * OL.UnitPrice)
ELSE 0 END) AS N'2014Sales',
SUM(CASE WHEN(O.OrderDate >= '2015-01-01' AND O.OrderDate < '2016-01-01') 
THEN (OL.Quantity * OL.UnitPrice)
ELSE 0 END) AS N'2015Sales'
FROM Sales.Customers C
	INNER JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
	INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
GROUP BY C.CustomerID, C.CustomerName
HAVING SUM(CASE WHEN(O.OrderDate >= '2014-01-01' AND O.OrderDate < '2016-01-01') 
THEN (OL.Quantity * OL.UnitPrice)
ELSE 0 END) > 0
ORDER BY SUM(OL.Quantity * OL.UnitPrice) DESC, C.CustomerID ASC

--Question 2
SELECT 
	S.SupplierID,
	S.SupplierName, 
	COUNT(DISTINCT O.OrderID) AS [Order Count], 
	ISNULL(SUM(OL.Quantity * OL.UnitPrice), 0.00) AS [Sales]
FROM Sales.OrderLines OL 
	FULL OUTER JOIN Warehouse.StockItems SI ON OL.StockItemID = SI.StockItemID
	RIGHT JOIN Sales.Orders O ON O.OrderID = OL.OrderID AND O.OrderDate BETWEEN '2015-01-01' AND '2015-12-31'
	RIGHT JOIN Purchasing.Suppliers S ON S.SupplierID = SI.SupplierID
GROUP BY S.SupplierName, S.SupplierID
ORDER BY [Sales] DESC, [Order Count], S.SupplierName

--Question 3
SELECT O.OrderID, O.OrderDate , O.CustomerID,
SUM(OL.Quantity * OL.UnitPrice) AS [OrderTotal]
FROM Sales.Orders O
	INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
WHERE O.OrderDate BETWEEN '2016-01-01' AND '2016-01-31' 
AND O.CustomerID = 
	(
		SELECT C.CustomerID
		FROM Sales.Customers C
			INNER JOIN Sales.CustomerCategories CC ON C.CustomerCategoryID = CC.CustomerCategoryID
		WHERE CC.CustomerCategoryName = 'Computer Store' AND C.CustomerID = O.CustomerID
	)
GROUP BY O.OrderID, O.OrderDate, O.CustomerID
ORDER BY [OrderTotal] DESC, O.OrderID ASC