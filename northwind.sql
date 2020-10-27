SELECT * FROM find_client2('Mario Pontes');


SELECT c.ContactName, p.ProductName, 
    od.UnitPrice, od.Quantity, o.OrderDate
        FROM Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        JOIN [Order Details] od ON o.OrderID = od.OrderID
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE c.ContactName LIKE 'Mario Pontes';

SELECT * FROM Customers
WHERE Region IS NOT NULL;

select p.ProductName, c.CategoryName, s.CompanyName
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Suppliers s on p.SupplierID = s.SupplierID
ORDER BY 3; 

SELECT c.ContactName, p.ProductName, 
    od.UnitPrice, od.Quantity, o.OrderDate
        FROM Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        JOIN [Order Details] od ON o.OrderID = od.OrderID
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE p.UnitPrice > 20
        ORDER BY 3 DESC;

SELECT c.ContactName, p.ProductName, od.UnitPrice
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE od.UnitPrice > (
    SELECT AVG(UnitPrice)
    FROM [Order Details]
) ORDER BY 3;

SELECT AVG(UnitPrice) as average
INTO #T1
FROM [Order Details];

SELECT * FROM #T1;

SELECT * FROM Customers;

SELECT c.ContactName, p.ProductName, od.UnitPrice
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
CROSS JOIN #T1
WHERE od.UnitPrice > #T1.average
ORDER BY 3;

DECLARE @custId NCHAR(5);

SET @custId = 'ALFKI';

SELECT * FROM Customers
WHERE CustomerID LIKE @custId;


