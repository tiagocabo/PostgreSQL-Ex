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