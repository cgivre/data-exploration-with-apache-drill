-- This requires that the tables from 00 SalesOrdersStructureModifyMY.sql be created first.

Use SalesOrdersModify;

CREATE PROCEDURE CH15_Adjust_Accessory_Retail_Price ()
UPDATE Products SET RetailPrice = ROUND(1.35 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT max(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)), 0)
WHERE RetailPrice < 1.35 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT max(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber) LIMIT 1) AND CategoryID = 1 ;

CREATE VIEW CH15_Adjust_Accessory_Retail_Price_Query
AS
SELECT RetailPrice, ROUND(1.35 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT max(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)), 0) As UpdatedPrice
FROM Products
WHERE RetailPrice < 1.35 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT max(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)) AND CategoryID = 1 ;

CREATE PROCEDURE CH15_Adjust_Bike_Retail_Price ()
UPDATE Products SET RetailPrice = ROUND(1.45 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT min(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)), 0)
WHERE RetailPrice < 1.45 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT min(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)) AND CategoryID = 2 ;

CREATE VIEW CH15_Adjust_Bike_Retail_Price_Query
AS
SELECT ProductNumber, ProductName, RetailPrice, ROUND(1.45 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT min(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)), 0) As UpdatedPrice
FROM Products 
WHERE RetailPrice < 1.45 * 
(SELECT DISTINCT WholesalePrice FROM Product_Vendors 
WHERE Product_Vendors.ProductNumber = Products.ProductNumber 
AND WholesalePrice = (SELECT min(WholesalePrice) FROM Product_Vendors WHERE Product_Vendors.ProductNumber = Products.ProductNumber)) AND CategoryID = 2 ;

CREATE PROCEDURE CH15_Adjust_Late_Order_Prices ()
UPDATE    Order_Details
SET              QuotedPrice = ROUND(QuotedPrice * 0.98, 2)
WHERE     (OrderNumber IN
                          (SELECT     Orders.OrderNumber
                            FROM          Orders
                            WHERE      DateDiff(Orders.ShipDate, Orders.OrderDate) > 30));

CREATE VIEW CH15_Adjust_Late_Order_Prices_Query
AS 
SELECT OrderNumber, ProductNumber, QuotedPrice, ROUND(QuotedPrice * 0.98, 2) As UpdatedPrice
FROM Order_Details
WHERE     (OrderNumber IN
                          (SELECT     Orders.OrderNumber
                            FROM          Orders
                            WHERE      DateDiff(Orders.ShipDate, Orders.OrderDate) > 30));

/* MySQL does not allow you to reference the table being updated in 
   the WHERE clause.  Original statement is:
CREATE PROCEDURE CH15_Give_Discount_To_Good_October_Customers ()
UPDATE    Order_Details
SET              QuotedPrice = ROUND(QuotedPrice * .95, 2)
WHERE     (OrderNumber IN
                          (SELECT     Orders.OrderNumber
                            FROM          Orders
                            WHERE      Orders.CustomerID IN
                                                       (SELECT     O2.CustomerID
                                                         FROM          Orders AS O2 INNER JOIN
                                                                                Order_Details ON O2.OrderNumber = Order_Details.OrderNumber
                                                         WHERE      O2.OrderDate BETWEEN CAST('2017-10-01' AS Date) AND CAST('2017-10-31' As Date)
                                                         GROUP BY O2.CustomerID
                                                         HAVING      SUM(Order_Details.QuotedPrice * Order_Details.QuantityOrdered) > 50000)));

   The solution I used is to create a temporary
   table that can be used to update the target table.
   Note that the procedure below does not delete the temporary table.
   (This is because, when you do drop the table, the procedure
   does not report the number of rows that were updated.) The system
   automatically drops the table when the procedure ends.

   Procedure that works follows:
*/

DELIMITER $$
CREATE PROCEDURE CH15_Discount_Good_Customers_October()
BEGIN
CREATE temporary TABLE IF NOT EXISTS tmp_Orders_to_Update
(OrderNumber int PRIMARY KEY)
SELECT     Orders.OrderNumber
FROM          Orders
WHERE      Orders.CustomerID IN
					(SELECT     O2.CustomerID
					FROM          Orders AS O2 INNER JOIN
									Order_Details ON O2.OrderNumber = Order_Details.OrderNumber
					WHERE      O2.OrderDate BETWEEN CAST('2017-10-01' AS Date) AND CAST('2017-10-31' As Date)
					GROUP BY O2.CustomerID
					HAVING      SUM(Order_Details.QuotedPrice * Order_Details.QuantityOrdered) > 50000);

UPDATE    Order_Details
SET              QuotedPrice = ROUND(QuotedPrice * .95, 2)
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM  tmp_Orders_to_Update));
                            
END
$$
DELIMITER ;

CREATE VIEW CH15_Give_Discount_To_Good_October_Customers_Query
AS 
SELECT QuotedPrice, ROUND(QuotedPrice * .95, 2) As UpdatedPrice
FROM Order_Details
WHERE     (OrderNumber IN
                          (SELECT     Orders.OrderNumber
                            FROM          Orders
                            WHERE      Orders.CustomerID IN
                                                       (SELECT     O2.CustomerID
                                                         FROM          Orders AS O2 INNER JOIN
                                                                                Order_Details ON O2.OrderNumber = Order_Details.OrderNumber
                                                         WHERE      O2.OrderDate BETWEEN CAST('2017-10-01' AS Date) AND CAST('2017-10-31' As Date)
                                                         GROUP BY O2.CustomerID
                                                         HAVING      SUM(Order_Details.QuotedPrice * Order_Details.QuantityOrdered) > 50000)));

CREATE PROCEDURE CH15_Update_Order_Totals_Subquery ()
UPDATE    Orders
SET              OrderTotal =
                          (SELECT     SUM(Order_Details.QuantityOrdered * Order_Details.QuotedPrice)
                            FROM          Order_Details
                            WHERE      Order_Details.OrderNumber = Orders.OrderNumber);

CREATE VIEW CH15_Update_Order_Totals_Subquery_Query
AS 
SELECT OrderTotal, (SELECT     SUM(Order_Details.QuantityOrdered * Order_Details.QuotedPrice)
               FROM          Order_Details
               WHERE      Order_Details.OrderNumber = Orders.OrderNumber) As NewTotal
FROM Orders;

CREATE PROCEDURE CH16_Add_Sales_Customer ()
INSERT INTO Customers
                      (CustFirstName, CustLastName, CustStreetAddress, CustCity, CustState, CustZipCode, CustAreaCode, CustPhoneNumber)
VALUES     ('Mary', 'Baker', '7834 W 32nd Ct', 'Bothell', 'WA', '98011', 425, '555-9876');

CREATE VIEW CH16_Add_Sales_Customer_Query
AS
SELECT 'Mary' As CustFirstName, 'Baker' As CustLastName, '7834 W 32nd Ct' As CustStreetAddress, 'Bothell' As CustCity, 'WA' As CUstState, '98011' As CustZipCode, 425 As CustAreaCode, '555-9876' As CustPhoneNumber
FROM Customers
WHERE CustomerID = 1001;

CREATE PROCEDURE CH16_Add_Employee ()
INSERT INTO Employees
                      (EmpFirstName, EmpLastName, EmpStreetAddress, EmpCity, EmpState, EmpZipCode, EmpAreaCode, EmpPhoneNumber)
VALUES     ('Susan', 'Metters', '16547 NE 132nd St', 'Woodinville', 'WA', '98072', 425, '555-7825');

CREATE VIEW CH16_Add_Employee_Query
AS
SELECT 'Susan' As EmpFirstName, 'Metters' As EmpLastName, '16547 NE 132nd St' As EmpStreetAddress, 'Woodinville' As EmpCity, 'WA' As EmpState, '98072' As EmpZipCode, 425 As EmpAreaCode, '555-7825' As EmpPhoneNumber
FROM Employees
WHERE EmployeeID = 701;

CREATE PROCEDURE CH16_Add_Product ()
INSERT INTO Products ( ProductName, RetailPrice, CategoryID )
SELECT 'Hot Dog Spinner', 895, CategoryID
FROM Categories WHERE
CategoryDescription = 'Bikes';

CREATE VIEW CH16_Add_Product_Query
AS 
SELECT 'Hot Dog Spinner' As ProductName, 895 As RetailPrice, CategoryID
FROM Categories WHERE
CategoryDescription = 'Bikes';

CREATE PROCEDURE CH16_Add_Vendor ()
INSERT INTO Vendors
                      (VendName, VendStreetAddress, VendCity, VendState, VendZipCode, VendPhoneNumber, VendFaxNumber, VendWebPage, VendEMailAddress)
VALUES     ('Hot Dog Bikes', '1234 Main Street', 'Chicago', 'IL', '60620', '(773) 555-6543', '(773) 555-6542', 'http://www.hotdogbikes.com/', 
                      'Sales@hotdogbikes.com');

CREATE VIEW CH16_Add_Vendor_Query
AS
SELECT 'Hot Dog Bikes' As VendName, '1234 Main Street' As VendStreetAddress, 'Chicago' As VendCity, 'IL' As VendState, '60620' As VendZipCode, '(773) 555-6543' As VendPhoneNumber, '(773) 555-6542' As VendFaxNumber, 'http://www.hotdogbikes.com/' As VendWebPage, 'Sales@hotdogbikes.com' As VendEMailAddress
FROM Vendors
WHERE VendorID = 1;

CREATE PROCEDURE CH16_Archive_2017_Order_Details ()
INSERT INTO Order_Details_Archive
SELECT     OrderNumber AS OrderNumber, ProductNumber AS ProductNumber, QuotedPrice AS QuotedPrice, QuantityOrdered AS QuantityOrdered
FROM         Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      (Orders.OrderDate < Cast('2018-01-01' As Date))));

CREATE VIEW CH16_Archive_2017_Order_Details_Query
AS 
SELECT     OrderNumber AS OrderNumber, ProductNumber AS ProductNumber, QuotedPrice AS QuotedPrice, QuantityOrdered AS QuantityOrdered
FROM         Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      (Orders.OrderDate < Cast('2018-01-01' As Date))));

CREATE PROCEDURE CH16_Archive_2017_Orders ()
INSERT INTO Orders_Archive
SELECT     OrderNumber AS OrderNumber, OrderDate AS OrderDate, ShipDate AS ShipDate, CustomerID AS CustomerID, EmployeeID AS EmployeeID, 
                      OrderTotal AS OrderTotal
FROM         Orders
WHERE     (OrderDate < Cast('2018-01-01' As Date));

CREATE VIEW CH16_Archive_2017_Orders_Query
AS 
SELECT     OrderNumber AS OrderNumber, OrderDate AS OrderDate, ShipDate AS ShipDate, CustomerID AS CustomerID, EmployeeID AS EmployeeID, 
                      OrderTotal AS OrderTotal
FROM         Orders
WHERE     (OrderDate < Cast('2018-01-01' As Date));

CREATE PROCEDURE CH16_Copy_Customer_To_Employee ()
INSERT INTO Employees
                      (EmpFirstName, EmpLastName, EmpStreetAddress, EmpCity, EmpState, EmpZipCode, EmpAreaCode, EmpPhoneNumber)
SELECT     CustFirstName, CustLastName, CustStreetAddress, CustCity, CustState, CustZipCode, CustAreaCode, CustPhoneNumber
FROM         Customers
WHERE     (CustFirstName = 'David') AND (CustLastName = 'Smith');

CREATE VIEW CH16_Copy_Customer_To_Employee_Query
AS 
SELECT     CustFirstName, CustLastName, CustStreetAddress, CustCity, CustState, CustZipCode, CustAreaCode, CustPhoneNumber
FROM         Customers
WHERE     (CustFirstName = 'David') AND (CustLastName = 'Smith');

CREATE PROCEDURE CH16_Copy_Dec12_OrderDetails_For_Keyser ()
INSERT INTO Order_Details
                      (OrderNumber, ProductNumber, QuotedPrice, QuantityOrdered)
SELECT     OrderNumber + 1000 AS NewOrderNo, ProductNumber, QuotedPrice, QuantityOrdered
FROM         Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      OrderDate = Cast('2017-12-12' As Date) AND CustomerID =
                                                       (SELECT     CustomerID
                                                         FROM          Customers
                                                         WHERE      CustFirstName = 'Liz' AND CustLastName = 'Keyser')));

CREATE VIEW CH16_Copy_Dec12_OrderDetails_For_Keyser_Query
AS
SELECT     OrderNumber + 1000 AS NewOrderNo, ProductNumber, QuotedPrice, QuantityOrdered
FROM         Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      OrderDate = Cast('2017-12-12' As Date) AND CustomerID =
                                                       (SELECT     CustomerID
                                                         FROM          Customers
                                                         WHERE      CustFirstName = 'Liz' AND CustLastName = 'Keyser')));

CREATE PROCEDURE CH16_Copy_Dec12_Order_For_Keyser ()
INSERT INTO Orders
                      (OrderNumber, OrderDate, ShipDate, CustomerID, EmployeeID, OrderTotal)
SELECT     OrderNumber + 1000 AS NewOrderNo, Cast('2018-12-06' As Date) AS OrderDate, Cast('2018-06-15' As Date) AS ShipDate, CustomerID, EmployeeID, OrderTotal
FROM         Orders
WHERE     (OrderDate = Cast('2017-12-12' As Date)) AND (CustomerID =
                          (SELECT     CustomerID
                            FROM          Customers
                            WHERE      CustFirstName = 'Liz' AND CustLastName = 'Keyser'));

CREATE VIEW CH16_Copy_Dec12_Order_For_Keyser_Query
AS 
SELECT     OrderNumber + 1000 AS NewOrderNo, Cast('2018-12-06' As Date) AS OrderDate, Cast('2018-06-15' As Date) AS ShipDate, CustomerID, EmployeeID, OrderTotal
FROM         Orders
WHERE     (OrderDate = Cast('2017-12-12' As Date)) AND (CustomerID =
                          (SELECT     CustomerID
                            FROM          Customers
                            WHERE      CustFirstName = 'Liz' AND CustLastName = 'Keyser'));

CREATE PROCEDURE CH16_Copy_November_OrderDetails_For_AKennedy ()
INSERT INTO Order_Details
                      (OrderNumber, ProductNumber, QuotedPrice, QuantityOrdered)
SELECT     OrderNumber + 1000 AS NewOrderNo, ProductNumber, QuotedPrice, QuantityOrdered
FROM         Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      OrderDate BETWEEN Cast('2017-11-01' As Date) AND Cast('2017-11-30' As Date) AND CustomerID =
                                                       (SELECT     CustomerID
                                                         FROM          Customers
                                                         WHERE      CustFirstName = 'Angel' AND CustLastName = 'Kennedy')));

CREATE VIEW CH16_Copy_November_OrderDetails_For_AKennedy_Query
AS 
SELECT     OrderNumber + 1000 AS NewOrderNo, ProductNumber, QuotedPrice, QuantityOrdered
FROM         Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      OrderDate BETWEEN Cast('2017-11-01' As Date) AND Cast('2017-11-30' As Date) AND CustomerID =
                                                       (SELECT     CustomerID
                                                         FROM          Customers
                                                         WHERE      CustFirstName = 'Angel' AND CustLastName = 'Kennedy')));

CREATE PROCEDURE CH16_Copy_November_Orders_For_AKennedy ()
INSERT INTO Orders
                      (OrderNumber, OrderDate, ShipDate, CustomerID, EmployeeID, OrderTotal)
SELECT     OrderNumber + 1000 AS NewOrderNo, Cast('2018-06-15' As Date) AS OrderDate, Cast('2018-06-18' As Date) AS ShipDate, CustomerID, EmployeeID, OrderTotal
FROM         Orders
WHERE     (OrderDate BETWEEN Cast('2017-11-01' As Date) AND Cast('2017-11-30' As Date)) AND (CustomerID =
                          (SELECT     CustomerID
                            FROM          Customers
                            WHERE      CustFirstName = 'Angel' AND CustLastName = 'Kennedy'));

CREATE VIEW CH16_Copy_November_Orders_For_AKennedy_Query
AS 
SELECT     OrderNumber + 1000 AS NewOrderNo, Cast('2018-06-15' As Date) AS OrderDate, Cast('2018-06-18' As Date) AS ShipDate, CustomerID, EmployeeID, OrderTotal
FROM         Orders
WHERE     (OrderDate BETWEEN Cast('2017-11-01' As Date) AND Cast('2017-11-30' As Date)) AND (CustomerID =
                          (SELECT     CustomerID
                            FROM          Customers
                            WHERE      CustFirstName = 'Angel' AND CustLastName = 'Kennedy'));

CREATE PROCEDURE CH17_Delete_Archived_Order_Details_OK ()
DELETE FROM Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Order_Details_Archive));

CREATE VIEW CH17_Delete_Archived_Order_Details_OK_Query
AS 
SELECT * FROM Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Order_Details_Archive));

CREATE PROCEDURE CH17_Delete_Archived_Order_Details_Unsafe ()
DELETE FROM Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      Orders.OrderDate < Cast('2018-01-01' As Date)));

CREATE VIEW CH17_Delete_Archived_Order_Details_Unsafe_Query
AS 
SELECT * FROM Order_Details
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders
                            WHERE      Orders.OrderDate < Cast('2018-01-01' As Date)));

CREATE PROCEDURE CH17_Delete_Archived_Orders_OK ()
DELETE FROM Orders
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders_Archive));

CREATE VIEW CH17_Delete_Archived_Orders_OK_Query
AS 
SELECT * FROM Orders
WHERE     (OrderNumber IN
                          (SELECT     OrderNumber
                            FROM          Orders_Archive));

CREATE PROCEDURE CH17_Delete_Archived_Orders_Unsafe ()
DELETE FROM Orders
WHERE     (OrderDate < Cast('2018-01-01' As Date));

CREATE VIEW CH17_Delete_Archived_Orders_Unsafe_Query
AS 
SELECT * FROM Orders
WHERE     (OrderDate < Cast('2018-01-01' As Date));

CREATE PROCEDURE CH17_Delete_Categories_No_Products ()
DELETE FROM Categories
WHERE     (CategoryID NOT IN
                          (SELECT     CategoryID
                            FROM          Products));

CREATE VIEW CH17_Delete_Categories_No_Products_Query
AS 
SELECT * FROM Categories
WHERE     (CategoryID NOT IN
                          (SELECT     CategoryID
                            FROM          Products));

CREATE PROCEDURE CH17_Delete_Customers_Never_Ordered ()
DELETE FROM Customers
WHERE     (CustomerID NOT IN
                          (SELECT     CustomerID
                            FROM          Orders));

CREATE VIEW CH17_Delete_Customers_Never_Ordered_Query
AS 
SELECT * FROM Customers
WHERE     (CustomerID NOT IN
                          (SELECT     CustomerID
                            FROM          Orders));

CREATE PROCEDURE CH17_Delete_Employees_No_Orders ()
DELETE FROM Employees
WHERE     (EmployeeID NOT IN
                          (SELECT     EmployeeID
                            FROM          Orders));

CREATE VIEW CH17_Delete_Employees_No_Orders_Query
AS 
SELECT * FROM Employees
WHERE     (EmployeeID NOT IN
                          (SELECT     EmployeeID
                            FROM          Orders));

CREATE PROCEDURE CH17_Delete_Products_Never_Ordered_1 ()
DELETE 
FROM Product_Vendors
WHERE (Product_Vendors.ProductNumber Not In (SELECT ProductNumber FROM Order_Details)) ;

CREATE VIEW CH17_Delete_Products_Never_Ordered_1_Query
AS
SELECT * 
FROM Product_Vendors
WHERE (Product_Vendors.ProductNumber Not In (SELECT ProductNumber FROM Order_Details)) ;

CREATE PROCEDURE CH17_Delete_Products_Never_Ordered_2 ()
DELETE FROM Products
WHERE     (ProductNumber NOT IN
                          (SELECT     ProductNumber
                            FROM          Order_Details));

CREATE VIEW CH17_Delete_Products_Never_Ordered_2_Query
AS 
SELECT * FROM Products
WHERE     (ProductNumber NOT IN
                          (SELECT     ProductNumber
                            FROM          Order_Details));

CREATE PROCEDURE CH17_Delete_Vendors_No_Products ()
DELETE FROM Vendors
WHERE     (VendorID NOT IN
                          (SELECT     VendorID
                            FROM          Product_Vendors));

CREATE VIEW CH17_Delete_Vendors_No_Products_Query
AS 
SELECT * FROM Vendors
WHERE     (VendorID NOT IN
                          (SELECT     VendorID
                            FROM          Product_Vendors));

CREATE PROCEDURE CH17_DELETE_Zero_OrdersA ()
DELETE FROM Orders
WHERE     (OrderTotal = 0);

CREATE VIEW CH17_DELETE_Zero_OrdersA_Query
AS 
SELECT * FROM Orders
WHERE     (OrderTotal = 0);

CREATE PROCEDURE CH17_DELETE_Zero_OrdersB ()
DELETE FROM Orders
WHERE     (OrderNumber NOT IN
                          (SELECT     OrderNumber
                            FROM          Order_Details));

CREATE VIEW CH17_DELETE_Zero_OrdersB_Query
AS 
SELECT * FROM Orders
WHERE     (OrderNumber NOT IN
                          (SELECT     OrderNumber
                            FROM          Order_Details));
