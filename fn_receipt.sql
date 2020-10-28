-------------------------------------------------
-------         Make a receipt           -------- 
-------------------------------------------------

CREATE OR ALTER FUNCTION Receipt(@orderID INT)
RETURNS TABLE
AS
RETURN(
    SELECT o.OrderID,  p.ProductName, od.Quantity,
        od.UnitPrice, od.Discount, 
        (od.UnitPrice - od.Discount) AS "Price without disc",
        o.OrderDate, o.ShippedDate, c.CompanyName AS "Customer's Company",
        CONCAT_WS(' ', e.LastName, e.FirstName) AS "Employee"
    FROM Products p
    JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
    JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN Employees e ON o.EmployeeID = e.EmployeeID
    WHERE o.OrderID = @orderID
);

