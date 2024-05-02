USE QuanLyBanHang;

INSERT INTO Customers (customerId, name, email, phone, address)
VALUES ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

INSERT INTO Products (productId, name, description, price, status)
VALUES ('P001', 'iPhone 13 Pro Max', 'Bản 512GB, xanh lá', 22999999, 1),
       ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999, 1),
       ('P003', 'Macbook Pro M2', '8 CPU, 10 GPU, 8GB, 256GB', 28999999, 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
       ('P005', 'Airpods 2 2022', 'Spatial Audio', 4090000, 1);

INSERT INTO Orders (orderId, customerId, orderDate, totalAmount)
VALUES ('H001', 'C001', '2023-02-22', 52999997),
       ('H002', 'C001', '2023-03-11', 80999997),
       ('H003', 'C002', '2023-01-22', 54359998),
       ('H004', 'C003', '2023-03-14', 102999995),
       ('H005', 'C003', '2023-03-12', 80999997),
       ('H006', 'C004', '2023-02-01', 110449994),
       ('H007', 'C004', '2023-03-29', 79999996),
       ('H008', 'C005', '2023-02-14', 29999998),
       ('H009', 'C005', '2023-01-10', 28999999),
       ('H010', 'C005', '2023-04-01', 149999994);

INSERT INTO OrdersDetails (orderId, productId, quantity, price)
VALUES ('H001', 'P002', 1, 14999999),
       ('H001', 'P004', 2, 18999999),
       ('H002', 'P001', 1, 22999999),
       ('H002', 'P003', 2, 28999999),
       ('H003', 'P004', 2, 18999999),
       ('H003', 'P005', 4, 4090000),
       ('H004', 'P002', 3, 14999999),
       ('H004', 'P003', 2, 28999999),
       ('H005', 'P001', 1, 22999999),
       ('H005', 'P003', 2, 28999999),
       ('H006', 'P005', 5, 4090000),
       ('H006', 'P002', 6, 14999999),
       ('H007', 'P004', 3, 18999999),
       ('H007', 'P001', 1, 22999999),
       ('H008', 'P002', 2, 14999999),
       ('H001', 'P003', 1, 28999999),
       ('H009', 'P003', 2, 28999999),
       ('H010', 'P001', 4, 22999999),
       ('H010', 'P002', 1, 14999999);

# Bài 3
# 1. Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers
SELECT name, email, phone, address
FROM Customers;

# 2. Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng)
SELECT DISTINCT c.name, c.phone, c.address
FROM Customers c
         JOIN Orders o ON c.customerId = o.customerId
WHERE o.orderDate BETWEEN '2023-03-01' AND '2023-03-31';

# 3. Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu)
SELECT MONTH(orderDate) AS Month, SUM(totalAmount) AS `Doanh thu`
FROM Orders
WHERE YEAR(orderDate) = 2023
GROUP BY MONTH(orderDate)
ORDER BY MONTH(orderDate);

# 4. Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại)
SELECT c.name, c.address, c.email, c.phone
FROM Customers c
WHERE NOT EXISTS (SELECT 1
                  FROM Orders o
                  WHERE o.customerId = c.customerId
                            AND MONTH(o.orderDate) = 2
                    AND YEAR(o.orderDate) = 2023);

# 5. Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra)
SELECT p.productId, p.name, SUM(od.quantity) AS `Số lượng sản phẩm bán ra`
FROM Products p
         JOIN OrdersDetails od ON p.productId = od.productId
         JOIN Orders o ON od.orderId = o.orderId
WHERE MONTH(o.orderDate) = 3
  AND YEAR(o.orderDate) = 2023
GROUP BY p.productId, p.name
ORDER BY p.productId;

# 6. Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu)
SELECT c.customerId, c.name, SUM(o.totalAmount) AS `Tổng chi tiêu`
FROM Customers c
         JOIN Orders o ON c.customerId = o.customerId
WHERE YEAR(o.orderDate) = 2023
GROUP BY c.customerId, c.name
ORDER BY `Tổng chi tiêu` DESC;

# 7. Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm tên người mua, tổng tiền, ngày tạo hoá đơn, tổng số lượng sản phẩm)
SELECT c.name AS BuyerName, o.totalAmount, o.orderDate, SUM(od.quantity) AS `Tổng số lượng sản phẩm`
FROM Orders o
         JOIN Customers c ON o.customerId = c.customerId
         JOIN OrdersDetails od ON o.orderId = od.orderId
GROUP BY o.orderId, c.name, o.totalAmount, o.orderDate
HAVING SUM(od.quantity) >= 5
ORDER BY o.orderDate;

# Bài 4: Tạo View, Procedure
# 1. Tạo VIEW lấy các thông tin hoá đơn bao gồm: Tên khách hàng, số điện thoại, địa chỉ, tổng tiền và ngày tạo hoá đơn
CREATE VIEW InvoiceDetails AS
SELECT c.name        AS `Tên khách hàng`,
       c.phone       AS `Số điện thoại`,
       c.address     AS `Địa chỉ`,
       o.totalAmount AS `Tổng tiền`,
       o.orderDate   AS `Ngày tạo hóa đơn`
FROM Customers c
         JOIN Orders o ON c.customerId = o.customerId;

# 2. Tạo VIEW hiển thị thông tin khách hàng gồm: tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt
CREATE VIEW CustomerOrderCount AS
SELECT c.name           AS `Tên khách hàng`,
       c.address        AS `Địa chỉ`,
       c.phone          AS `Số điện thoại`,
       COUNT(o.orderId) AS `Tổng số đơn đã đặt`
FROM Customers c
         LEFT JOIN Orders o ON c.customerId = o.customerId
GROUP BY c.customerId, c.name, c.address, c.phone;

# 3. Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã bán ra của mỗi sản phẩm
CREATE VIEW ProductSalesDetails AS
SELECT p.name                      AS `Tên sản phẩm`,
       p.description               AS `Mô tả`,
       p.price                     AS `Giá`,
       IFNULL(SUM(od.quantity), 0) AS `Tổng số lượng đã bán ra`
FROM Products p
         LEFT JOIN OrdersDetails od ON p.productId = od.productId
GROUP BY p.productId, p.name, p.description, p.price;

# 4. Đánh Index cho trường `phone` và `email` của bảng Customer
CREATE INDEX index_phone ON Customers (phone);
CREATE INDEX index_email ON Customers (email);

# 5. Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng
DELIMITER //

CREATE PROCEDURE GetCustomerInfo(IN customerId VARCHAR(4))
BEGIN
SELECT *
FROM Customers
WHERE customerId = customerId;
END;

DELIMITER //

# 6. Tạo PROCEDURE lấy thông tin của tất cả sản phẩm
DELIMITER //

CREATE PROCEDURE GetAllProducts()
BEGIN
SELECT *
FROM Products;
END;

DELIMITER //

# 7. Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng
DELIMITER //

CREATE PROCEDURE GetOrdersByCustomerId(IN customerId VARCHAR(4))
BEGIN
SELECT *
FROM Orders
WHERE customerId = customerId;
END;

DELIMITER //

# 8. Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo

# 9. Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc

# 10. Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê