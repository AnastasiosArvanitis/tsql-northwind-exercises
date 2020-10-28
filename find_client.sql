CREATE FUNCTION find_client3(@client_name NVARCHAR(30))
RETURNS TABLE
AS
RETURN
(
    SELECT c.ContactName, p.ProductName, 
    od.UnitPrice, od.Quantity, o.OrderDate
        FROM Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        JOIN [Order Details] od ON o.OrderID = od.OrderID
        JOIN Products p ON od.ProductID = p.ProductID
        WHERE c.ContactName LIKE @client_name

);

--SELECT * FROM find_client('Mario Pontes');