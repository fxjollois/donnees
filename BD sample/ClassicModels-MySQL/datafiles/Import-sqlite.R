library(RSQLite)
library(tidyverse)

tables = gsub(".txt", "", dir(pattern = ".txt"))
for (t in tables) {
  temp = read_csv(paste0(t, ".txt"), col_names = FALSE, locale = readr::locale(encoding = "latin1"))
  assign(t, temp)
}

conn = dbConnect(SQLite(), "ClassicModel.sqlite")

dbExecute(conn, "
DROP TABLE Customers;
DROP TABLE Employees;
DROP TABLE Offices;
DROP TABLE OrderDetails;
DROP TABLE Orders;
DROP TABLE Payments;
DROP TABLE Products;
")

dbExecute(conn, "
CREATE TABLE Customers (
  customerNumber INTEGER NOT NULL,
  customerName VARCHAR(50) NOT NULL,
  contactLastName VARCHAR(50) NOT NULL,
  contactFirstName VARCHAR(50) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  addressLine1 VARCHAR(50) NOT NULL,
  addressLine2 VARCHAR(50) NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NULL,
  postalCode VARCHAR(15) NULL,
  country VARCHAR(50) NOT NULL,
  salesRepEmployeeNumber INTEGER NULL,
  creditLimit DOUBLE NULL,
  PRIMARY KEY (customerNumber)
);
");

dbExecute(conn, "
CREATE TABLE Employees (
  employeeNumber INTEGER NOT NULL,
  lastName VARCHAR(50) NOT NULL,
  firstName VARCHAR(50) NOT NULL,
  extension VARCHAR(10) NOT NULL,
  email VARCHAR(100) NOT NULL,
  officeCode VARCHAR(20) NOT NULL,
  reportsTo INTEGER NULL,
  jobTitle VARCHAR(50) NOT NULL,
  PRIMARY KEY (employeeNumber)
);
")

dbExecute(conn, "
CREATE TABLE Offices (
  officeCode VARCHAR(50) NOT NULL,
  city VARCHAR(50) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  addressLine1 VARCHAR(50) NOT NULL,
  addressLine2 VARCHAR(50) NULL,
  state VARCHAR(50) NULL,
  country VARCHAR(50) NOT NULL,
  postalCode VARCHAR(10) NOT NULL,
  territory VARCHAR(10)  NULL,
  PRIMARY KEY (officeCode)
);
");

dbExecute(conn, "
CREATE TABLE OrderDetails (
  orderNumber INTEGER NOT NULL,
  productCode VARCHAR(50) NOT NULL,
  quantityOrdered INTEGER NOT NULL,
  priceEach DOUBLE NOT NULL,
  orderLineNumber SMALLINT NOT NULL,
  PRIMARY KEY (orderNumber, productCode)
);
");

dbExecute(conn, "
CREATE TABLE Orders (
  orderNumber INTEGER NOT NULL,
  orderDate DATETIME NOT NULL,
  requiredDate DATETIME NOT NULL,
  shippedDate DATETIME NULL,
  status VARCHAR(15) NOT NULL,
  comments TEXT NULL,
  customerNumber INTEGER NOT NULL,
  PRIMARY KEY (orderNumber)
);
")

dbExecute(conn, "
CREATE TABLE Payments (
  customerNumber INTEGER NOT NULL,
  checkNumber VARCHAR(50) NOT NULL,
  paymentDate DATETIME NOT NULL,
  amount DOUBLE NOT NULL,
  PRIMARY KEY (customerNumber, checkNumber)
);
")

dbExecute(conn, "
CREATE TABLE Products (
  productCode VARCHAR(50) NOT NULL,
  productName VARCHAR(70) NOT NULL,
  productLine VARCHAR(50) NOT NULL,
  productScale VARCHAR(10) NULL,
  productVendor VARCHAR(50) NOT NULL,
  productDescription TEXT NOT NULL,
  quantityInStock SMALLINT NOT NULL,
  buyPrice DOUBLE NOT NULL,
  MSRP DOUBLE NOT NULL,
  PRIMARY KEY (productCode)
);
")

for (t in tables) dbExecute(conn, paste0("DELETE FROM ", t))

import = function(table) {
  temp = get(table)
  names(temp) = dbListFields(conn, table)
  nblignes = nrow(dbReadTable(conn, table))
  if (nblignes == 0) dbAppendTable(conn, table, temp)
}

import("Customers")
import("Employees")
import("Offices")
import("OrderDetails")
import("Orders")
import("Payments")
import("Products")

dbDisconnect(conn)


