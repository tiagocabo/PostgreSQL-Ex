-- Problems From Book " SQL Practice Problems" by Sylvia Moestl Vasilik


-- Problem 1
CREATE TABLE shippers
(ShipperID INT PRIMARY KEY NOT NULL ,CompanyName VARCHAR(30) NOT NULL ,Phone INT);

SELECT *
FROM shippers;

-- Problem 2
CREATE TABLE Categories
(CategoriesID SERIAL  PRIMARY KEY NOT NULL ,CategoryName VARCHAR(30), Description VARCHAR(30));

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
shipVia INT, freight FLOAT, shipName varchar(30), shipAddress varchar(30), shipCity varchar(30),shipRegion VARCHAR(30),shipPostalCode VARCHAR(30),
shipCountry VARCHAR(30));

ALTER TABLE orders
    ADD FOREIGN KEY (employeeID) REFERENCES employee (employeeID);

SELECT * FROM orders;

SELECT orderID, orderDate FROM orders
WHERE employeeID = (SELECT employeeID FROM employee WHERE FirstName = 'Steven'  and lastName = 'Buchanan');

