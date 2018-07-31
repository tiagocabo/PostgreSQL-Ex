-- Problems From Book " SQL Practice Problems" by Sylvia Moestl Vasilik


-- Problem 1
CREATE TABLE shippers
(ShipperID INT PRIMARY KEY NOT NULL ,CompanyName VARCHAR(30) NOT NULL ,Phone INT);

SELECT *
FROM shippers;

-- Problem 2
CREATE TABLE Categories
 (CategoriesID SERIAL  PRIMARY KEY NOT NULL ,
  CategoryName VARCHAR(30),
  Description VARCHAR(100),
  picture TEXT);

SELECT *
FROM Categories;

-- Problem 3
CREATE TABLE employee
(employeeID SERIAL  PRIMARY KEY NOT NULL, lastName VARCHAR(30), firstName VARCHAR(30), title VARCHAR(30), titleOfCourtesy VARCHAR(30),
birthDate TIMESTAMP, hireDate TIMESTAMP , address VARCHAR(30), city varchar(30), region varchar(30),postalCode VARCHAR(30), country varchar(30),
homePhone VARCHAR(30), extension int, photo VARCHAR(300), notes varchar(300), reportsTo INT, photoPath VARCHAR(50));

SELECT *
FROM employee;

SELECT firstName, lastName, hireDate FROM employee
WHERE title = 'Sales Representative';

-- Problem 4
SELECT firstName, lastName, hireDate FROM employee
WHERE title = 'Sales Representative' AND country = 'USA' ;

-- Problem 5
CREATE TABLE orders
(orderID SERIAL  PRIMARY KEY NOT NULL, customerID VARCHAR(10), employeeID INT, orderDate timestamp, requiredDate timestamp, shippedDate timestamp,
shipVia INT, freight FLOAT, shipName varchar(30), shipAddress varchar(30), shipCity varchar(30),shipRegion VARCHAR(30), shipPostalCode VARCHAR(30),
shipCountry VARCHAR(30));

ALTER TABLE orders
    ADD FOREIGN KEY (employeeID) REFERENCES employee (employeeID);

SELECT * FROM orders;

SELECT orderID, orderDate FROM orders
WHERE employeeID = (SELECT employeeID FROM employee WHERE FirstName = 'Steven'  and lastName = 'Buchanan');

-- Problem 6
CREATE TABLE suppliers
(supplierID SERIAL  PRIMARY KEY NOT NULL, companyName VARCHAR(50), contactName VARCHAR(30), contactTitle VARCHAR(30), address VARCHAR(100),
city VARCHAR(20), region VARCHAR(20), postalCode VARCHAR(20), country VARCHAR(30), phone VARCHAR(10), fax VARCHAR(20), homePage VARCHAR(100));

SELECT * from suppliers;

SELECT supplierID, contactName, contactTitle FROM suppliers
WHERE NOT contactTitle = 'Marketing Manager';

-- Problem 7

CREATE TABLE products
  (productID SERIAL  PRIMARY KEY NOT NULL,
  productName VARCHAR(30),
  supplierID INT REFERENCES suppliers(supplierID),
  categoryID INT REFERENCES Categories(CategoriesID),
  quantityPerUnit VARCHAR(40),
  unitPrice FLOAT,
  unitsInStock INT,
  unitsOnOrder INT,
  reorderLevel INT,
  discontinued INT);

SELECT * FROM products;



SELECT LC.productID, LC.lower FROM (SELECT productID, lower(productName) FROM products ) AS LC
WHERE LC.lower LIKE '%queso%';

-- Problem 8
SELECT * FROM orders;

SELECT orderID, customerID, shipCountry
FROM orders
WHERE shipCountry = 'France' OR shipCountry = 'Belgium';

-- Problem 9 ---    IN Statement

SELECT orderID, customerID, shipCountry
FROM orders
WHERE shipCountry IN ('Brazil', 'Mexico', 'Argentina', 'Venezuela');

-- Problem 10 ----    ORDER BY Statement

SELECT * FROM employee;

SELECT firstName, lastName, title, birthDate FROM employee
ORDER By birthDate asc ;

-- Problem 11 -----      CAST Statement
SELECT firstName, lastName, title, date(birthDate) FROM employee
-- alternative solution

SELECT firstName, lastName, title, birthDate::timestamp :: date  FROM employee

--- Problem 12 --- Concat Function

SELECT firstname, lastname, CONCAT(firstName,' ', lastName) FROM employee;

--- Problem 13 -- AS STATEMENT
CREATE TABLE order_details
(orderID INT REFERENCES  orders(orderID),
productID INT REFERENCES products(productID),
unitPrice FLOAT,
quantity INT,
discount float);


SELECT
  orderID,
  productID,
  unitPrice,
  quantity,
  unitPrice * quantity AS TotalPrice
FROM
  order_details
ORDER BY
  orderID,
productID;

------ Problem 14 -----
CREATE TABLE customers
(customerID VARCHAR(30)PRIMARY KEY  NOT NULL ,
companyName varchar(50),
contactName varchar(50),
contactTitle varchar(50),
address VARCHAR(100),
city VARCHAR(30),
region VARCHAR(40),
postalCode VARCHAR(50),
country VARCHAR(30),
phone VARCHAR(40),
fax VARCHAR(40));


SELECT
   COUNT(*)
FROM customers
  as totalcustomers ;

----- Problem 15------    MIN FUNCTION

SELECT MIN(orderDate) FROM orders AS FIRSTORDER

------PROBLEM 16 --------  GROUP BY STATEMENT

SELECT shipCountry from orders
group by shipCountry;

------ Problem 17 ------ GROUP BY AND COUNT

SELECT contactTitle,
COUNT(contactTitle) AS NumberContactTitles
FROM customers
GROUP BY
  contactTitle
ORDER BY
  COUNT(contactTitle) desc ;

----- Problem 18 ---- JOIN TWO TABLES

SELECT productID, productName, companyName FROM products
JOIN suppliers
  ON suppliers.supplierID = products.supplierID;

----- Problem 19 ----

SELECT
  orderID, date(orderDate) as orderdate,  CompanyName as supplier FROM orders
JOIN shippers
  ON shippers.ShipperID = orders.shipVia
WHERE orderID < 10300
order by orderID ASC ;
---------------------------------------------------------------------
----------------------- Intermediate problems------------------------
---------------------------------------------------------------------

------- Problem 20 --------------------
SELECT CategoryName, count(*) as total_products FROM Categories

JOIN products
  ON Categories.CategoriesID = products.categoryID

GROUP BY CategoryName

ORDER BY total_products desc
;

-------- Problem 21 -------

SELECT * FROM customers;

SELECT  country ,city ,count(*)  as TotalCustomer FROM customers
group by city, country
ORDER BY TotalCustomer desc
;

------- Problem 22 --------
SELECT * FROM products;

SELECT
  productID,
  unitsInStock,
  reorderLevel
FROM
  products
WHERE
  unitsInStock < reorderLevel;

----------Problem 23 --------
SELECT
  productID,
  productName,
  unitsInStock,
  unitsOnOrder,
  reorderLevel,
  discontinued
FROM
  products
WHERE
  unitsInStock + unitsOnOrder <= reorderLevel
AND
  discontinued = 0;

------------ Problem 24 ---------

SELECT
  customerID,
  companyName,
  region
FROM customers
order by
  Case
 when Region is null then 1
 else 0
END,
  region ASC,
customerID asc
;

------- Problem 25 ------ How to show top 3
SELECT  * FROM orders;

SELECT
  shipCountry,
  AVG(freight) AS AverageFreight
FROM orders
GROUP BY shipCountry
ORDER BY AverageFreight DESC
limit 3;

------- Problem 26 --------
SELECT
  shipCountry,
  AVG(freight) AS AverageFreight
FROM orders
  WHERE date_part('year',orderDate) > 1996 AND date_part('year',orderDate)<1998
GROUP BY shipCountry
ORDER BY AverageFreight DESC
limit 3;

-------- Problem 27 -------
select * from orders order by OrderDate;

-- The between statement is exclusive, which means that the last values on 31 December is not included

------- Problem 28-------

SELECT
  shipCountry,
  AVG(freight) AS AverageFreight
FROM orders
  WHERE
  (OrderDate) > (SELECT Max((OrderDate)) from Orders) - interval '12 month'

Group by ShipCountry
ORDER BY AverageFreight DESC
LIMIT 3
;

--------- Problem 29 -------------
-- orders join employee -->> employee lastname and order join order details -->> product Id and quantity finally order details JOIN products -->> product name

SELECT
  O.employeeID ,
  E.lastname,
  O.orderID,
  P.productName,
  OD.quantity
FROM
  orders as O
JOIN employee as E
  ON O.employeeID = E.employeeID
JOIN order_details AS OD
    ON OD.orderID = O.orderID
JOIN products AS P
  ON P.productID = OD.productID

ORDER BY O.orderID, P.productID;

------- Problem 30 ------------ Left Join

Select
 Customers.CustomerID as Customers_CustomerID,
  Orders.CustomerID as Orders_CustomerID
 From Customers
LEFT JOIN  Orders
 on Orders.CustomerID = Customers.CustomerID
WHERE orders.customerID IS NULL
;

--------- PROBLEM 31 ------------- Sub queries.

--Subqueries on select statment must return single values

Select
 Customers.CustomerID as Customers_CustomerID,
  Orders.CustomerID as Orders_CustomerID
 From Customers
LEFT JOIN  (SELECT customerID
     from orders
     where
     employeeID = 4) AS Orders
 on Orders.CustomerID = Customers.CustomerID
WHERE orders.customerID IS NULL
;

----Alternatives
-- The most common way to solve this kind of problem is as above, with a left join. However, here are some alternatives using Not In and Not Exists.
--  Select CustomerID
--  From Customers
--  Where
--  CustomerID not in (select CustomerID from Orders where EmployeeID = 4)
--  Select CustomerID
--  From Customers
--  Where Not Exists
--  (
--  Select CustomerID
--  from Orders
--  where Orders.CustomerID = Customers.CustomerID
--  and EmployeeID = 4
--  )

---------------------------------------------------------------------
----------------------- Advanced problems------------------------
---------------------------------------------------------------------

-------- Problem 32----------
SELECT
  customers.customerID,
  customers.companyName,
  orders.orderID,
  sum(unitPrice * quantity) as total_value
  from customers

 join orders

    ON orders.customerID = orders.customerID

join order_details

    ON orders.orderID = order_details.orderID

WHERE  OrderDate >= '19980101'
 and OrderDate  < '19990101'

GROUP BY
  orders.orderID, customers.customerID

having sum(unitPrice * quantity) > 10000

ORDER BY total_value DESC
;

-------- Problem 33 -------------------------- more than 15k in 2016

SELECT
  customers.customerID,
  customers.companyName,
  sum(unitPrice * quantity) as total_value
  from customers

 join orders

    ON orders.customerID = orders.customerID

join order_details

    ON orders.orderID = order_details.orderID

WHERE  OrderDate >= '19980101'
 and OrderDate  < '19990101'

GROUP BY
   customers.customerID, companyName

having sum(unitPrice * quantity) > 15000

ORDER BY total_value DESC
;

----- Problem 34 ---------------------------------- same problem as preview with discount
SELECT
  customers.customerID,
  customers.companyName,
  sum(unitPrice * quantity) as total_value,
  sum(unitPrice * quantity * (1 - discount)) as total_value_discount

  from customers

 join orders

    ON orders.customerID = orders.customerID

join order_details

    ON orders.orderID = order_details.orderID

WHERE  OrderDate >= '19980101'
 and OrderDate  < '19990101'

GROUP BY
   customers.customerID, companyName

having sum(unitPrice * quantity * (1 - discount)) > 15000

ORDER BY total_value_discount DESC
;

------------ Problem 35 ----------------------------------------------
SELECT
  employeeID,
  orderID,
  orderDate,
   date_trunc('month', Date(orderDate)) + interval '1 month' - interval '1 day' AS DATEsss

  FROM orders

WHERE orderDate = date_trunc('month', Date(orderDate)) + interval '1 month' - interval '1 day'

ORDER BY employeeID

--------- Problem 36 --------------------------- Count()
SELECT
  orders.orderID,
  count(*) as TotalNumber
FROM
  order_details
  join orders
  on orders.orderID = order_details.orderID

group by orders.orderID
order by TotalNumber DESC
limit 10;

--------- Problem 37 --------------------------- Random

SELECT orderID
FROM
  orders
WHERE
  random() < 0.01;

---------- Problem 38 -------------

SELECT
  order_details.orderID,
  order_details.quantity,
  count(order_details.quantity) as Duplicate


FROM order_details

--   join orders
--   on orders.orderID = order_details.orderID
--
--   join employee
--   on employee.lastName = 'Leverling'

WHERE quantity >= 60



group by order_details.orderID,  quantity
having count(*) >1

order by order_details.orderID ASC

;
--------- Problem 39 --------------- USING "with" tables
-- Oldest employee
with PotentianDuplicates as (
    SELECT orderID
    FROM
      order_details
    WHERE quantity >= 60
    GROUP BY orderID, quantity
    HAVING COUNT(*) > 1
)
SELECT
  order_details.orderID,
  productID,
  unitPrice,
  quantity,
  discount
  FROM
    order_details

WHERE
  orderID in (SELECT orderID FROM PotentianDuplicates)
ORDER BY
  orderID,
  quantity
;

----------- problem 40 ----- Derived table

SELECT
  order_details.orderID,
  productID,
  unitPrice,
  qUANTITY,
  discount
FROM order_details

  join (SELECT DISTINCT
      orderID
    FROM order_details
    WHERE quantity >=60
    GROUP BY orderID, quantity
    HAVING COUNT(*)> 1
    ) as POTENTIALPROBLEMORDERS
  ON POTENTIALPROBLEMORDERS.orderID = order_details.orderID
ORDER BY  order_details.orderID, productID

------- Problem 41 ----------------------------------------- Late orders
SELECT
  orderID,
  orderDate,
  requiredDate,
  shippedDate
FROM
  orders
where
  shippedDate > requiredDate
;


