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

-- sum of each company
SELECT c.CompanyName, SUM(od.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName
ORDER BY 1 ASC, 2 DESC;

-- sum of each product that every company ordered
SELECT c.CompanyName, p.ProductName, SUM(od.UnitPrice) AS Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CompanyName, p.ProductName
ORDER BY 1 ASC, 3 DESC;



SELECT c.companyName, p.ProductName, SUM(od.UnitPrice) AS Total
FROM Customers c, Products p, [Order Details] od, Orders o
WHERE c.CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE OrderID IN (
        SELECT OrderID
        FROM [Order Details]
        WHERE UnitPrice > (
            SELECT AVG(UnitPrice)
            FROM [Order Details]
        )
    )
)
AND c.CustomerID = o.CustomerID
AND o.OrderID = od.OrderID
AND od.ProductID = p.ProductID
GROUP BY c.CompanyName, p.ProductName
ORDER BY 1 ASC, 3 DESC;

SELECT AVG(UnitPrice)
            FROM [Order Details]

SELECT * FROM Territories;

SELECT t.TerritoryDescription, r.RegionDescription
FROM Territories t
JOIN Region r on t.RegionID = r.RegionID
ORDER BY 1 ASC;

SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS "Full Name",
 e.Title, SUM(od.UnitPrice) AS "Total Sales"
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.LastName, e.FirstName, e.Title
ORDER BY 1 ASC;

SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS "Full Name", 
e.Title, SUM(od.UnitPrice) - SUM(od.Discount) AS "Total - Discount"
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.LastName, e.FirstName, e.Title
ORDER BY 1 ASC;

SELECT CompanyName, ContactName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE OrderID IN (
        SELECT OrderID
        FROM [Order Details]
        WHERE Quantity > (
            SELECT AVG(Quantity)
            FROM [Order Details]
        )
    )
);

SELECT CompanyName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerId
    FROM Orders
    WHERE Orders.CustomerID = Customers.CustomerID
    AND OrderDate BETWEEN '1997-04-01' AND '1997-04-30'
);

SELECT ProductName
FROM Products
WHERE NOT EXISTS (
    SELECT ProductID
    FROM [Order Details]
    JOIN Orders ON Orders.OrderID = [Order Details].OrderID
    WHERE [Order Details].ProductID = Products.ProductID
    AND OrderDate BETWEEN '1997-04-01' AND '1997-04-30'
);

SELECT CompanyName
FROM Suppliers
WHERE SupplierID IN (
    SELECT SupplierID
    FROM Products
    WHERE UnitPrice > 50
);

SELECT CompanyName
FROM Suppliers
WHERE EXISTS (
    SELECT ProductID
    FROM Products
    WHERE Products.SupplierID = Suppliers.SupplierID
    AND convert(numeric(10,4), UnitPrice, 1)  > 10
);

SELECT s.CompanyName, p.ProductName, p.UnitPrice
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
WHERE EXISTS (
    SELECT ProductID
    FROM Products, Suppliers
    WHERE Products.SupplierID = Suppliers.SupplierID
    AND convert(numeric(6,4), UnitPrice, 1)  > 10
)
ORDER BY 1;

SELECT * FROM Products;

SELECT s.CompanyName
FROM Suppliers s
WHERE NOT EXISTS (
    SELECT p.ProductID
    FROM Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    WHERE s.SupplierID = p.SupplierID
    AND o.OrderDate BETWEEN '1996-12-01'
            AND '1996-12-31' 
) ;


SELECT c.ContactName, p.ProductName, o.OrderDate
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN '1996-12-01'
            AND '1996-12-31' 
ORDER BY 1;

SELECT CONCAT_WS(' ', s.CompanyName, s.City) 
    AS "Suppliers and their Cities"
FROM Suppliers s
UNION
SELECT CONCAT_WS(' ', c.CompanyName, c.City) 
AS "Customers and their Cities" 
FROM Customers c;


SELECT * FROM Suppliers;

-------------------------------------------------
-------         Make a receipt           -------- 
-------------------------------------------------

SELECT o.OrderID, o.OrderDate, 
        p.ProductName, od.Quantity,
        od.UnitPrice, od.Discount, 
        (od.UnitPrice - od.Discount) AS "Price without disc",
        o.OrderDate, o.ShippedDate, c.CompanyName AS "Customer's Company",
        CONCAT_WS(' ', e.LastName, e.FirstName) AS "Employee"
    FROM Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN Employees e ON o.EmployeeID = e.EmployeeID
    WHERE o.OrderID = 10249;

-- Executing Functions
SELECT * FROM Orders;
SELECT * FROM Customers;

SELECT * FROM dbo.Receipt(10256);

SELECT * FROM dbo.find_client3('Maria Anders');
SELECT * FROM dbo.find_client3('Antonio Moreno');