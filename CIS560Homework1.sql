--Yuto Wada MWF 8:30-9:20
--Question 1
SELECT O.OrderID, O.CustomerID, O.SalespersonPersonID
FROM Sales.Orders O
WHERE O.OrderDate = '2015-01-15'


--Question 2
SELECT O.OrderID, O.CustomerID, O.SalespersonPersonID
FROM Sales.Orders O
WHERE O.OrderDate >= '2015-01-01'
AND O.OrderDate < '2015-02-01'
AND O.CustomerID = '50'


--Question 3
SELECT O.SalespersonPersonID, MIN(O.OrderDate) AS FirstOrderDate, MAX(O.OrderDate) AS LastOrderDate, COUNT(*) AS OrderCount
FROM Sales.Orders O
WHERE O.OrderDate > '2014-12-31'
AND O.OrderDate <= '2015-12-31'
GROUP BY O.SalespersonPersonID


--Question 4
SELECT O.OrderDate, COUNT(DISTINCT O.CustomerID) AS CustomerCount, COUNT(*) AS OrderCount
FROM Sales.Orders O
WHERE O.OrderDate >= '2015-01-01'
AND O.OrderDate <= '2015-01-31'
GROUP BY O.OrderDate
HAVING COUNT(*) >= 50










