--Yuto Wada MWF 8:30-9:20
--Question 1
SELECT O.CustomerID, COUNT(*) AS OrderCount, MIN(O.OrderDate) AS FirstOrderDate, MAX(O.OrderDate) AS LastOrderDate,
	CASE
		WHEN MIN(O.OrderDate) >= '2016-01-01' THEN N'New Customer'
		WHEN COUNT(*) < 25 THEN N'Few Orders'
		WHEN COUNT(*) >= 25
		AND COUNT(*) < 100 THEN N'Growing Customer'
		ELSE N'Large Customer'
	END AS CustomerStatus
FROM Sales.Orders O
GROUP BY O.CustomerID;

--Question 2
DECLARE
	 @FirstDate DATE = '2016-01-01',
	 @LastDate DATE = '2018-01-31',
	 @PageSize INT = 20,
	 @Page INT = 1;

SELECT O.OrderDate, COUNT(*) AS OrderCount, COUNT(DISTINCT O.CustomerID) AS CustomerCount
FROM SALES.Orders O
WHERE O.OrderDate BETWEEN @FirstDate
AND @LastDate
GROUP BY O.OrderDate
ORDER BY O.OrderDate ASC
OFFSET @PageSize * (@Page - 1) ROWS FETCH NEXT @PageSize ROWS ONLY;

--Question 3
SELECT YEAR(O.OrderDate) AS OrderYear, CS.CustomerCategoryName, COUNT(DISTINCT O.CustomerID) as CustomerCount, COUNT(DISTINCT O.OrderID) as OrderCount, SUM(OL.Quantity * OL.UnitPrice) AS Sales, SUM((OL.Quantity * OL.UnitPrice)) / COUNT(DISTINCT O.CustomerID) as AverageSalesPerCustomer
FROM Sales.Orders O
	INNER JOIN Sales.OrderLines OL ON OL.OrderID = O.OrderID
	INNER JOIN Sales.Customers C ON O.CustomerID = C.CustomerID
	INNER JOIN Sales.CustomerCategories CS  ON C.CustomerCategoryID = CS.CustomerCategoryID
GROUP BY CS.CustomerCategoryName, YEAR(O.OrderDate)
ORDER BY YEAR(O.OrderDate) ASC;




