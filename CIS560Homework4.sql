--Yuto Wada MWF 8:30-9:20
--Question 1
SELECT CustomerName, OrderCount, Sales
FROM 
    (
        SELECT C.CustomerName, COUNT(DISTINCT O.OrderID) AS OrderCount,
        SUM(OL.Quantity * OL.UnitPrice) AS Sales
        FROM Sales.Customers C
            INNER JOIN Sales.Orders O ON C.CustomerID = O.CustomerID
            INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
        WHERE O.OrderDate BETWEEN '01-01-2015' AND '12-31-2015'
        GROUP BY C.CustomerName 
    ) AS OrderCustomers
ORDER BY Sales DESC --DO NOT need to use ORDER BY in inner query after WHERE

--Question 2
WITH CustomerTotal(OrderID, OrderDate, OrderTotal, DaysSincePreviousOrders) AS
    (
        SELECT O.OrderID, O.OrderDate,
        SUM(OL.Quantity * OL.UnitPrice) AS OrderTotal,
        DATEDIFF(DAY, LAG(O.OrderDate, 1) OVER (ORDER BY O.OrderDate ASC, O.OrderID ASC), O.OrderDate) AS DaysSincePreviousOrder
        FROM Sales.Orders O
            INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
        WHERE O.CustomerID = 90
        GROUP BY O.OrderID, O.OrderDate
    )
SELECT CT.OrderID, CT.OrderDate, CT.OrderTotal, CT.DaysSincePreviousOrders,
SUM(CT.OrderTotal) OVER(
	ORDER BY CT.OrderID ASC
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS YtdTotal
FROM CustomerTotal CT
ORDER BY CT.OrderDate ASC, CT.OrderID ASC
GO

--Question 3
WITH SalesPersonTotal(SalespersonPersonID, FullName, OrderYear, YearlySales) AS
    (
        SELECT O.SalespersonPersonID, P.FullName, 
        YEAR(O.OrderDate), 
        SUM(OL.UnitPrice * OL.Quantity) AS YearlySales
        FROM Sales.Orders O
            INNER JOIN Application.People P ON O.SalespersonPersonID = P.PersonID
            INNER JOIN Sales.OrderLines OL ON O.OrderID = OL.OrderID
        GROUP BY O.SalespersonPersonID, P.FullName, YEAR(O.OrderDate)
    )
SELECT CT.SalespersonPersonID, CT.FullName, CT.OrderYear, CT.YearlySales,
RANK() OVER(
    PARTITION BY CT.OrderYear
    ORDER BY YearlySales DESC) AS YearlySalesRank,
DENSE_RANK() OVER(
    ORDER BY YearlySales DESC) AS OverallSalesRank
FROM SalesPersonTotal CT
ORDER BY OrderYear ASC, RANK() OVER(
    PARTITION BY CT.OrderYear
    ORDER BY YearlySales DESC)
GO

--Question 4
WITH AllCitiesData(PostalCityID, RecordType) AS
(
    SELECT S.PostalCityID, 'Supplier' AS RecordType
    FROM Purchasing.Suppliers S

    UNION 

    SELECT C.PostalCityID, 'Customer' AS RecordType
    FROM Sales.Customers C
)
SELECT C.CityName, SP.StateProvinceName, AC.RecordType
FROM AllCitiesData AC
    INNER JOIN Application.Cities C ON AC.PostalCityID = C.CityID
    INNER JOIN Application.StateProvinces SP ON C.StateProvinceID = SP.StateProvinceID

