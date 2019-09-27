------------------------ BEGINNER PROBLEMS ----------------------------------

-- Query #1
SELECT * FROM Shippers;

-- Query #2
SELECT CategoryName, Description
FROM Categories;

-- Query #3
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales Representative';

-- Query #4
SELECT FirstName, LastName, HireDate
FROM Employees
WHERE Title = 'Sales Representative' AND Country = 'USA';

-- Query #5
SELECT OrderID, OrderDate
FROM Orders
WHERE EmployeeID = 5;

-- Query #6
SELECT SupplierID, ContactName, ContactTitle
FROM Suppliers
WHERE ContactTitle != 'Marketing Manager';

-- Query #7
SELECT ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%queso%';

-- Query #8
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
Where ShipCountry IN ('France', 'Belgium');

-- Query #9
SELECT OrderID, CustomerID, ShipCountry
FROM Orders
Where ShipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela');

-- Query #10
SELECT FirstName, LastName, Title, BirthDate
FROM Employees
ORDER BY BirthDate ASC;

-- Query #11
SELECT FirstName, LastName, Title, CONVERT(Date, BirthDate)
FROM Employees
ORDER BY BirthDate ASC;

-- Query #12
SELECT FirstName, LastName, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Employees;

-- Query #13
SELECT OrderID, ProductID, UnitPrice, Quantity, UnitPrice*Quantity AS TotalPrice
FROM OrderDetails;

-- Query #14
SELECT COUNT(*) AS TotalCustomers 
FROM Customers;

-- Query #15
SELECT MIN(OrderDate) AS FirstOrder
FROM Orders;

-- Query #16
SELECT DISTINCT Country 
FROM Customers;

-- or --

SELECT Country 
FROM Customers
GROUP BY Country;

-- Query #17
SELECT ContactTitle, COUNT(ContactTitle) AS TotalContactTitle
FROM Customers
GROUP BY ContactTitle
ORDER BY TotalContactTitle DESC;

-- Query #18
SELECT Products.ProductID, Products.ProductName, Suppliers.CompanyName
FROM Products 
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID;

-- Query #19
SELECT Orders.OrderID, CONVERT(DATE, Orders.OrderDate) AS OrderDate, Shippers.CompanyName AS Shipper
FROM Orders 
INNER JOIN Shippers ON Shippers.ShipperID = Orders.ShipVia
WHERE Orders.OrderID < 10270
ORDER BY Orders.OrderID;

------------------------ INTERMEDIATE PROBLEMS ----------------------------------

-- Query #20
SELECT Categories.CategoryName, COUNT(Categories.CategoryName) AS TotalProducts
FROM Products 
INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
ORDER BY TotalProducts DESC;

-- Query #21
SELECT Country, City, COUNT(*) AS TotalCustomers
FROM Customers
GROUP BY Country, City
ORDER BY TotalCustomers DESC;

-- Query #22
SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM Products
WHERE UnitsInStock <= ReorderLevel
ORDER BY ProductID ASC;

-- Query #23
SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM Products
WHERE (UnitsInStock + UnitsOnOrder <= ReorderLevel) AND Discontinued = 0
ORDER BY ProductID ASC;

-- Query #24
SELECT CustomerID, CompanyName, Region 
FROM Customers
ORDER BY 
    (
        CASE 
        WHEN Region IS NOT NULL THEN 0
        ELSE 1
        END
    ) ASC,
    Region ASC, 
    CustomerID ASC;

-- Query #25
SELECT TOP 3 ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

-- Query #26
SELECT TOP 3 ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE YEAR(OrderDate) = '2015'
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

-- Query #28
SELECT TOP 3 ShipCountry, AVG(Freight) AS AverageFreight
FROM Orders
WHERE OrderDate >= DATEADD(year, -1, (SELECT Max(OrderDate) FROM Orders))
GROUP BY ShipCountry
ORDER BY AverageFreight DESC;

-- Query #29
SELECT e.EmployeeID, e.LastName, o.OrderID, p.ProductName, od.Quantity
FROM Employees AS e 
INNER JOIN Orders AS o ON e.EmployeeID = o.EmployeeID
INNER JOIN OrderDetails as od ON o.OrderID = od.OrderID
INNER JOIN Products as p ON od.ProductID = p.ProductID
ORDER BY o.OrderID, p.ProductID;

-- Query #30
SELECT c.CustomerID, o.CustomerID
FROM Customers AS c 
LEFT JOIN Orders as o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL;

-- Query #31
SELECT Customers.CustomerID, Orders.CustomerID
FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
AND Orders.EmployeeID = 4
WHERE Orders.CustomerID IS NULL;

------------------------ ADVANCED PROBLEMS ----------------------------------

-- Query #32
WITH VIPOrders AS (
    SELECT OrderID, SUM(UnitPrice*Quantity) AS TotalOrderAmount
    FROM OrderDetails
    GROUP BY OrderID
    HAVING SUM(UnitPrice*Quantity) >= 10000
)
SELECT 
    Orders.CustomerID, 
    Customers.CompanyName, 
    VIPOrders.OrderID, 
    VIPOrders.TotalOrderAmount
FROM VIPOrders
INNER JOIN Orders ON VIPOrders.OrderID = Orders.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(Orders.OrderDate) = '2016';

-- Query #33
SELECT 
    Customers.CustomerID, 
    Customers.CompanyName, 
    SUM(OrderDetails.Quantity*OrderDetails.UnitPrice) AS TotalOrderAmount
FROM Orders 
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(OrderDate) = '2016'
GROUP BY Customers.CustomerID, Customers.CompanyName
HAVING SUM(OrderDetails.Quantity*OrderDetails.UnitPrice) >= 15000
ORDER BY TotalOrderAmount DESC;

-- Query #34
SELECT 
    Customers.CustomerID, 
    Customers.CompanyName, 
    SUM(OrderDetails.Quantity*OrderDetails.UnitPrice*(1-OrderDetails.Discount)) AS TotalOrderAmount
FROM Orders 
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE YEAR(OrderDate) = '2016'
GROUP BY Customers.CustomerID, Customers.CompanyName
HAVING SUM(OrderDetails.Quantity*OrderDetails.UnitPrice) >= 15000
ORDER BY TotalOrderAmount DESC;

-- Query #35
SELECT EmployeeID, OrderID, CONVERT(Date, OrderDate) AS OrderDate
FROM Orders
WHERE OrderDate = EOMONTH(OrderDate);

-- Query #36
SELECT TOP 10 OrderID, COUNT(*) AS TotalOrderDetails
FROM OrderDetails
GROUP BY OrderID
ORDER BY COUNT(*) DESC;

-- Query #37
SELECT TOP 2 percent OrderID 
FROM Orders
ORDER BY NEWID();

-- Query #38
SELECT OrderID
FROM OrderDetails
WHERE Quantity >= 60
GROUP BY OrderID, Quantity
HAVING COUNT(*) > 1
ORDER BY OrderID;

-- Query below is more general, finding ones where the quantity was not repeated.

WITH query_1 AS 

    (SELECT OrderDetails.OrderID, OrderDetails.ProductID, OrderDetails.Quantity
    FROM Orders 
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    WHERE EmployeeID = 3 AND Quantity >= 60),

query_2 AS

    (SELECT OrderID, COUNT(*) AS total
    FROM query_1
    GROUP BY OrderID
    HAVING COUNT(*) > 1)

SELECT query_1.OrderID, query_1.ProductID, query_1.Quantity 
FROM query_1 
INNER JOIN query_2 ON query_1.OrderID = query_2.OrderID
ORDER BY query_1.OrderID;

-- Query #39
WITH query_1 AS (
    SELECT DISTINCT OrderID
    FROM OrderDetails
    WHERE Quantity >= 60
    GROUP BY OrderID, Quantity
    HAVING COUNT(*) > 1
)

SELECT OrderDetails.OrderID, ProductID, UnitPrice, Quantity, Discount 
FROM query_1 INNER JOIN OrderDetails ON query_1.OrderID = OrderDetails.OrderID;

-- Query #41 (#40 was a bug finding exercise)
SELECT OrderID, OrderDate, RequiredDate, ShippedDate
FROM Orders
WHERE CONVERT(DATE, ShippedDate) >= CONVERT(DATE, RequiredDate);

-- Query #42
WITH query_1 AS (
    SELECT EmployeeID, COUNT(*) AS num_late_orders
    FROM Orders 
    WHERE CONVERT(DATE, ShippedDate) >= CONVERT(DATE, RequiredDate)
    GROUP BY EmployeeID
)

SELECT query_1.EmployeeID, Employees.LastName, query_1.num_late_orders
FROM query_1 
INNER JOIN Employees ON query_1.EmployeeID = Employees.EmployeeID
ORDER BY num_late_orders DESC;

-- Query #43
WITH query_1 AS (
    SELECT EmployeeID, COUNT(*) AS num_late_orders
    FROM Orders 
    WHERE CONVERT(DATE, ShippedDate) >= CONVERT(DATE, RequiredDate)
    GROUP BY EmployeeID
),

query_2 AS (
    SELECT EmployeeID, COUNT(*) AS num_all_orders
    FROM Orders 
    GROUP BY EmployeeID
)

SELECT 
    query_1.EmployeeID, 
    Employees.LastName, 
    query_2.num_all_orders, 
    query_1.num_late_orders
FROM query_1 
INNER JOIN Employees ON query_1.EmployeeID = Employees.EmployeeID
INNER JOIN query_2 ON Employees.EmployeeID = query_2.EmployeeID
ORDER BY EmployeeID;

-- Query #44
WITH query_1 AS (
    SELECT EmployeeID, COUNT(*) AS num_late_orders
    FROM Orders 
    WHERE CONVERT(DATE, ShippedDate) >= Convert(DATE, RequiredDate)
    GROUP BY EmployeeID
),

query_2 AS (
    SELECT EmployeeID, COUNT(*) AS num_all_orders
    FROM Orders 
    GROUP BY EmployeeID
)

SELECT 
    query_2.EmployeeID, 
    Employees.LastName, 
    query_2.num_all_orders, 
    query_1.num_late_orders
FROM query_2 
LEFT JOIN Employees ON query_2.EmployeeID = Employees.EmployeeID
LEFT JOIN query_1 ON Employees.EmployeeID = query_1.EmployeeID
ORDER BY EmployeeID;

-- Query #45
WITH query_1 AS (
    SELECT EmployeeID, COUNT(*) AS num_late_orders
    FROM Orders 
    WHERE CONVERT(DATE, ShippedDate) >= Convert(DATE, RequiredDate)
    GROUP BY EmployeeID
),

query_2 AS (
    SELECT EmployeeID, COUNT(*) AS num_all_orders
    FROM Orders 
    GROUP BY EmployeeID
)

SELECT 
    query_2.EmployeeID, 
    Employees.LastName, 
    query_2.num_all_orders, 
    ISNULL(query_1.num_late_orders, 0) AS num_late_orders
FROM query_2 
LEFT JOIN Employees ON query_2.EmployeeID = Employees.EmployeeID
LEFT JOIN query_1 ON Employees.EmployeeID = query_1.EmployeeID
ORDER BY EmployeeID;

-- Query #46
WITH query_1 AS (
    SELECT EmployeeID, COUNT(*) AS num_late_orders
    FROM Orders 
    WHERE CONVERT(DATE, ShippedDate) >= Convert(DATE, RequiredDate)
    GROUP BY EmployeeID
),

query_2 AS (
    SELECT EmployeeID, COUNT(*) AS num_all_orders
    FROM Orders 
    GROUP BY EmployeeID
)

SELECT 
    query_2.EmployeeID, 
    Employees.LastName, 
    query_2.num_all_orders, 
    ISNULL(query_1.num_late_orders, 0) AS num_late_orders, 
    ISNULL((CAST (query_1.num_late_orders AS FLOAT) / CAST (query_2.num_all_orders AS FLOAT)), 0) AS percent_late_orders
FROM query_2 
LEFT JOIN Employees ON query_2.EmployeeID = Employees.EmployeeID
LEFT JOIN query_1 ON Employees.EmployeeID = query_1.EmployeeID
ORDER BY EmployeeID;

-- Query #47
WITH query_1 AS (
    SELECT EmployeeID, COUNT(*) AS num_late_orders
    FROM Orders 
    WHERE CONVERT(DATE, ShippedDate) >= Convert(DATE, RequiredDate)
    GROUP BY EmployeeID
),

query_2 AS (
    SELECT EmployeeID, COUNT(*) AS num_all_orders
    FROM Orders 
    GROUP BY EmployeeID
)

SELECT 
    query_2.EmployeeID, 
    Employees.LastName, 
    query_2.num_all_orders, 
    ISNULL(query_1.num_late_orders, 0) AS num_late_orders, 
    ISNULL(ROUND((CAST (query_1.num_late_orders AS FLOAT) / CAST (query_2.num_all_orders AS FLOAT)), 2), 0) AS percent_late_orders
FROM query_2 
LEFT JOIN Employees ON query_2.EmployeeID = Employees.EmployeeID
LEFT JOIN query_1 ON Employees.EmployeeID = query_1.EmployeeID
ORDER BY EmployeeID;

-- Query #48
WITH query_1 AS (
    SELECT CustomerID, OrderID
    FROM Orders
    WHERE YEAR(OrderDate) = '2016'
),

query_2 AS (
    SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS total_order_amount
    FROM OrderDetails
    GROUP BY OrderID
)

SELECT 
    query_1.CustomerID, 
    Customers.CompanyName, 
    SUM(query_2.total_order_amount) AS total_order_amount,
    CASE
        WHEN SUM(query_2.total_order_amount) <= 1000 THEN 'Low'
        WHEN SUM(query_2.total_order_amount) <= 5000 THEN 'Medium'
        WHEN SUM(query_2.total_order_amount) <= 10000 THEN 'High'
        ELSE 'Very High'
        END AS customer_group
FROM query_1
INNER JOIN Customers ON query_1.CustomerID = Customers.CustomerID
INNER JOIN query_2 ON query_1.OrderID = query_2.OrderID
GROUP BY query_1.CustomerID, Customers.CompanyName
ORDER BY query_1.CustomerID ASC;

-- Query #49
WITH query_1 AS (
    SELECT CustomerID, OrderID
    FROM Orders
    WHERE YEAR(OrderDate) = '2016'
),

query_2 AS (
    SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS total_order_amount
    FROM OrderDetails
    GROUP BY OrderID
)

SELECT 
    query_1.CustomerID, 
    Customers.CompanyName, 
    SUM(query_2.total_order_amount) AS total_order_amount,
    CASE
        WHEN SUM(query_2.total_order_amount) <= 1000 THEN 'Low'
        WHEN SUM(query_2.total_order_amount) <= 5000 THEN 'Medium'
        WHEN SUM(query_2.total_order_amount) <= 10000 THEN 'High'
        ELSE 'Very High'
    END AS customer_group
FROM query_1
INNER JOIN Customers ON query_1.CustomerID = Customers.CustomerID
INNER JOIN query_2 ON query_1.OrderID = query_2.OrderID
GROUP BY query_1.CustomerID, Customers.CompanyName
ORDER BY query_1.CustomerID ASC;

-- Query #50
WITH query_1 AS (
    SELECT CustomerID, OrderID
    FROM Orders
    WHERE YEAR(OrderDate) = '2016'
),

query_2 AS (
    SELECT OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS total_order_amount
    FROM OrderDetails
    GROUP BY OrderID
),

query_3 AS (
    SELECT query_1.CustomerID, Customers.CompanyName, 
    SUM(query_2.total_order_amount) AS total_order_amount,
    CASE
        WHEN SUM(query_2.total_order_amount) <= 1000 THEN 'Low'
        WHEN SUM(query_2.total_order_amount) <= 5000 THEN 'Medium'
        WHEN SUM(query_2.total_order_amount) <= 10000 THEN 'High'
        ELSE 'Very High'
    END AS customer_group
    FROM query_1
    INNER JOIN Customers ON query_1.CustomerID = Customers.CustomerID
    INNER JOIN query_2 ON query_1.OrderID = query_2.OrderID
    GROUP BY query_1.CustomerID, Customers.CompanyName
)

SELECT 
    query_3.customer_group, 
    COUNT(*) AS total_in_group, 
    (CAST (COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM query_3)) AS percentage_in_group
FROM query_3
GROUP BY query_3.customer_group;

-- Query #51
WITH orders_2016 AS (
    SELECT 
        Customers.CustomerID, 
        Customers.CompanyName, 
        SUM(OrderDetails.UnitPrice*OrderDetails.Quantity*(1-OrderDetails.Discount)) AS total_order_amount
    FROM Customers
    INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
    INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
    WHERE YEAR(OrderDate) = '2016'
    GROUP BY Customers.CustomerID, Customers.CompanyName
)

SELECT 
    orders_2016.CustomerID, 
    orders_2016.CompanyName, 
    orders_2016.total_order_amount,
    CustomerGroupThresholds.CustomerGroupName
FROM orders_2016
INNER JOIN CustomerGroupThresholds ON total_order_amount between CustomerGroupThresholds.RangeBottom and CustomerGroupThresholds.RangeTop
ORDER BY orders_2016.CustomerID;

-- Query #52
SELECT Country
FROM Customers

UNION 

SELECT Country 
FROM Suppliers
ORDER BY Country ASC;

-- Query #53
SELECT DISTINCT 
    Suppliers.Country AS supplier_country, 
    Customers.Country AS customer_country
FROM Suppliers
FULL OUTER JOIN  Customers ON Suppliers.Country = Customers.Country
ORDER BY Suppliers.Country, Customers.Country;

-- Query #54
WITH sc AS (
    SELECT Country, COUNT(*) AS total_suppliers
    FROM Suppliers
    GROUP BY Country
),

cc AS (
    SELECT Country, COUNT(*) AS total_customers
    FROM Customers
    GROUP BY Country 
)

SELECT 
    ISNULL(sc.Country, cc.Country) AS country, 
    ISNULL(sc.total_suppliers, 0) AS total_suppliers, 
    ISNULL(cc.total_customers, 0) AS total_customers
FROM sc
FULL OUTER JOIN cc ON sc.Country = cc.Country;

-- Query #55
WITH query AS (
    SELECT 
        ShipCountry, 
        CustomerID, 
        OrderID, 
        OrderDate, 
        RANK() OVER (
            PARTITION BY ShipCountry
            ORDER BY OrderID ASC
        ) AS test_column
    FROM Orders
)

SELECT ShipCountry, CustomerID, OrderID, OrderDate 
FROM query
WHERE test_column = 1;

-- Query #56
WITH InitialOrder AS (
    SELECT * FROM Orders
),

NextOrder AS (
    SELECT * FROM Orders
)

SELECT 
    InitialOrder.CustomerID,
    InitialOrder.OrderID AS InitialOrderID,
    InitialOrder.OrderDate AS InitialOrderDate,
    NextOrder.OrderID AS NextOrderID,
    NextOrder.OrderDate AS NextOrderDate
FROM InitialOrder
INNER JOIN NextOrder ON InitialOrder.CustomerID = NextOrder.CustomerID
WHERE InitialOrder.OrderID < NextOrder.OrderID and DATEDIFF(d, InitialOrder.OrderDate, NextOrder.OrderDate) <= 5
ORDER BY InitialOrder.CustomerID, NextOrder.CustomerID;