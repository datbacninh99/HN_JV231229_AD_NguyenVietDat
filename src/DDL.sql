CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

CREATE TABLE IF NOT EXISTS Customers
(
    customerId VARCHAR(4)   NOT NULL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    phone      VARCHAR(25)  NOT NULL,
    address    VARCHAR(255) NOT NULL
    );

CREATE TABLE IF NOT EXISTS Orders
(
    orderId     VARCHAR(4) NOT NULL PRIMARY KEY,
    customerId  VARCHAR(4) NOT NULL,
    orderDate   DATE       NOT NULL,
    totalAmount DOUBLE     NOT NULL
    );

CREATE TABLE IF NOT EXISTS Products
(
    productId   VARCHAR(4)   NOT NULL PRIMARY KEY,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    price       DOUBLE       NOT NULL,
    status      BIT(1)       NOT NULL
    );

CREATE TABLE IF NOT EXISTS OrdersDetails
(
    orderId   VARCHAR(4) NOT NULL,
    productId VARCHAR(4) NOT NULL,
    quantity  INT(11)    NOT NULL,
    price     DOUBLE     NOT NULL,
    PRIMARY KEY (orderId, productId)
    );

ALTER TABLE OrdersDetails
    ADD FOREIGN KEY (orderId) REFERENCES Orders (orderId),
    ADD FOREIGN KEY (productId) REFERENCES Products (productId);