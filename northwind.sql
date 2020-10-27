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

