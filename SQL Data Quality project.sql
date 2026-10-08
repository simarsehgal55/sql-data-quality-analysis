use companyanalysis;
SHOW VARIABLES LIKE 'local_infile';
SHOW TABLES;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM customersclean;
DROP TABLE customersclean;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/TechStack/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM customers;
SHOW WARNINGS;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/TechStack/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM customers;
SELECT * FROM customers LIMIT 5;
DESCRIBE customers;
SELECT COUNT(*) FROM products;
TRUNCATE TABLE products;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/TechStack/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM products LIMIT 5;
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    SaleID INT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(12,2),
    DiscountPct DECIMAL(8,2),
    TaxPct DECIMAL(8,2),
    GrossAmount DECIMAL(14,2),
    DiscountAmount DECIMAL(14,2),
    TaxAmount DECIMAL(14,2),
    NetAmount DECIMAL(14,2)
);
LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/TechStack/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM sales;
USE companyanalysis;

CREATE TABLE orders (
    OrderID INT,
    CustomerID INT,
    OrderDate VARCHAR(20),
    OrderStatus VARCHAR(30),
    PaymentMethod VARCHAR(50),
    ShippingCity VARCHAR(50),
    SalesChannel VARCHAR(30)
);

LOAD DATA LOCAL INFILE 'C:/Users/hp/Desktop/TechStack/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM orders;
select table_name, count(*) as column_count from information_schema.columns where table_schema="companyanalysis" and table_name in ('customers', 'products', 'orders', 'sales')
group by table_name order by table_name; 
describe customers;
describe products;
describe orders;
describe sales;
select customerID,count(*) from customers group by customerID having count(*) > 1;
select productID,count(*) from products group by productID having count(*) > 1;
select orderID,count(*) from orders group by orderID having count(*) > 1;
select saleID,count(*) from sales group by saleID having count(*) > 1;
SELECT COUNT(*) AS null_count
FROM customers
WHERE CustomerID IS NULL
   OR CustomerName IS NULL
   OR Email IS NULL
   OR Phone IS NULL
   OR City IS NULL
   OR State IS NULL
   OR CustomerSegment IS NULL
   OR RegistrationDate IS NULL;
SELECT COUNT(*) AS null_count
FROM orders
WHERE OrderID IS NULL
   OR CustomerID IS NULL;
SELECT COUNT(*) AS null_count
FROM sales
WHERE SaleID IS NULL
   OR OrderID IS NULL
   OR ProductID IS NULL;
SELECT COUNT(*) AS invalid_dates FROM customers WHERE STR_TO_DATE(RegistrationDate, '%Y-%m-%d') IS NULL;
SELECT RegistrationDate
FROM customers
LIMIT 10;
SELECT COUNT(*) AS invalid_dates FROM orders WHERE STR_TO_DATE(orderdate, '%Y-%m-%d') IS NULL;
SELECT COUNT(*) FROM customers WHERE STR_TO_DATE(RegistrationDate, '%Y-%m-%d') >curdate();
SELECT COUNT(*) FROM orders WHERE STR_TO_DATE(orderdate, '%Y-%m-%d') >curdate();
SELECT orderdate,COUNT(*) FROM orders WHERE STR_TO_DATE(orderdate, '%Y-%m-%d') >curdate() group by orderdate order by STR_TO_DATE(orderdate, '%Y-%m-%d');
select * from sales limit 5;
select count(*) from sales where quantity<0 or unitprice<0 or discountamount<0 or taxamount<0 or netamount<0;
select count(*) from sales where quantity=0 or unitprice=0 or grossamount=0 or netamount=0;
select count(*) from sales where discountpct<0 or discountpct>100 or taxpct<0 or taxpct>100;
select customersegment,count(*) from customers group by customersegment order by customersegment;
SELECT COUNT(*) FROM customers WHERE CustomerSegment != TRIM(CustomerSegment);
SELECT LOWER(CustomerSegment) AS segment, COUNT(*) AS count
FROM customers
GROUP BY LOWER(CustomerSegment);
select count(*) from orders o left join customers c on o.customerID=c.CustomerID where c.CustomerID is null;
select count(*) from sales s left join orders o on s.orderID=o.orderID where s.orderID is null;
select count(*) from products p left join sales s on p.productID=s.productID where p.productID is null;
select max(quantity) from sales;
select max(unitprice),min(unitprice) from sales;
SELECT MIN(NetAmount) AS min_net_amount,
       MAX(NetAmount) AS max_net_amount
FROM sales;
SHOW TABLES;
DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE sales;
SELECT MAX(CHAR_LENGTH(CustomerName)),MAX(CHAR_LENGTH(Email)),MAX(CHAR_LENGTH(Phone)),MAX(CHAR_LENGTH(City)),MAX(CHAR_LENGTH(State)),MAX(CHAR_LENGTH(CustomerSegment)) FROM customers;
SELECT RegistrationDate
FROM customers
LIMIT 5;
SELECT OrderDate
FROM orders
LIMIT 5;
alter table customers modify RegistrationDate date;
alter table orders modify orderdate date;
DESCRIBE customers;
DESCRIBE orders;

create table staging_customers like customers;
create table staging_products like products;
create table staging_orders like orders;
create table staging_sales like sales;
insert into staging_customers select * from customers;
insert into staging_products select * from products;
insert into staging_orders select * from orders;
insert into staging_sales select * from sales;
select count(*) from staging_products;
select count(*) from staging_customers;
select count(*) from staging_orders;
select count(*) from staging_sales;
truncate table staging_customers;
truncate table staging_products;
insert into staging_customers select * from customers;
insert into staging_products select * from products;
select count(*) from staging_customers;
select count(*) from staging_products;
select count(*) from customers;
select count(*) from products;
alter table customers add primary key (CustomerID);
alter table products add primary key (ProductID);
alter table orders add primary key (OrderID);
alter table sales add primary key (SaleID);

alter table orders add constraint fk_orders_customer foreign key (CustomerID) references customers(CustomerID);
alter table sales add constraint fk_sales_order foreign key (OrderID) references orders(OrderID);
alter table sales add constraint fk_sales_product foreign key (ProductID) references products(ProductID);
select Email, count(*) as email_count from customers group by Email having count(*) > 1;
alter table customers add constraint uq_customers_email unique (Email);

select count(*) from customers where CustomerID is null or CustomerName is null or Email is null;
select count(*) from products where ProductID is null;
select count(*) from orders where OrderID is null or CustomerID is null or OrderDate is null;
select count(*) from sales where SaleID is null or OrderID is null or ProductID is null or Quantity is null or UnitPrice is null;
alter table customers modify CustomerID int not null, modify CustomerName varchar(100) not null, modify Email varchar(150) not null;
alter table products modify ProductID int not null;
alter table orders modify OrderID int not null, modify CustomerID int not null, modify OrderDate date not null;
select count(*) from sales where DiscountPct < 0 or DiscountPct > 100 or TaxPct < 0 or TaxPct > 100;
alter table sales add constraint chk_sales_quantity check (Quantity > 0);
alter table sales add constraint chk_sales_unitprice check (UnitPrice >= 0);
alter table sales add constraint chk_sales_discount check (DiscountPct between 0 and 100);
alter table sales add constraint chk_sales_tax check (TaxPct between 0 and 100);

select OrderStatus, count(*) as count from orders group by OrderStatus;
alter table orders modify OrderStatus varchar(30) not null default 'Processing';

start transaction;
insert into orders (OrderID, CustomerID, OrderDate, OrderStatus) values (9999999, 999999999, '2026-09-28', 'Processing');
rollback;
start transaction;
select Email from customers limit 1;
insert into customers (CustomerID, CustomerName, Email) values (9999998, 'Test Customer', 'customer100001@example.com');
rollback;
insert into sales (SaleID, OrderID, ProductID, Quantity, UnitPrice, DiscountPct, TaxPct) values (9999999, 1, 1, -1, 100, 10, 18);
insert into customers (CustomerID, CustomerName, Email) values (9999999, null, 'testnull@example.com');
insert into orders (OrderID, CustomerID, OrderDate) values (9999999, 100001, '2026-09-28');
select OrderStatus from orders where OrderID = 9999999;

select distinct CustomerSegment from customers;
select CustomerName, CustomerSegment, case when CustomerSegment = 'Consumer' then 'Individual' when CustomerSegment = 'Corporate' then 'Business' else 'Small Business' end from customers limit 4;
select CustomerSegment,count(*) from customers group by CustomerSegment having count(*) >50000;
select CustomerName, orderID, orderdate, orderstatus from customers c inner join orders o on c.CustomerID = o.CustomerID limit 5;
select c.CustomerName, o.OrderID, s.ProductID, s.Quantity, s.NetAmount from customers c inner join orders o on c.CustomerID = o.CustomerID inner join sales s on o.OrderID = s.OrderID limit 5;

select avg(order_count) from (select count(*) as order_count from orders group by customerID) x ;
select customerID, count(*) as order_count from orders group by customerID having count(*) > (select avg(order_count) from (select count(*) as order_count from orders group by customerID) x) ;
with customer_orders as (select CustomerID, count(*) as order_count from orders group by CustomerID) select * from customer_orders limit 5;

select City as Location from customers limit 10;
select ShippingCity as Location from orders limit 10;
select City as Location from customers union select ShippingCity as Location from orders limit 10;
select CustomerID, count(*) as order_count, rank() over (order by count(*) desc) as order_rank from orders group by CustomerID limit 10;
select CustomerID, sum(NetAmount) as customer_revenue, round(sum(NetAmount) / (select sum(NetAmount) from sales) * 100, 2) as revenue_percentage from sales group by CustomerID order by customer_revenue desc limit 10;

select o.CustomerID, sum(s.NetAmount) as customer_revenue, round(sum(s.NetAmount) / (select sum(NetAmount) from sales) * 100, 2) as revenue_percentage from orders o inner join sales s on o.OrderID = s.OrderID group by o.CustomerID order by customer_revenue desc limit 10;

select ProductID, round(avg(NetAmount), 2) as average_sale from sales group by ProductID having avg(NetAmount) > 5000 order by average_sale desc;

select round(sum(netamount),2) as total_revenue from sales;
select count(*) as incorrect_discount from sales where round(DiscountAmount, 2) != round(GrossAmount * DiscountPct / 100, 2);
select SaleID, GrossAmount, DiscountPct, DiscountAmount, round(GrossAmount * DiscountPct / 100, 2) as calculated_discount from sales where round(DiscountAmount, 2) !=
round(GrossAmount * DiscountPct / 100, 2) limit 10;
select count(*) from sales where abs(DiscountAmount - (GrossAmount * DiscountPct / 100)) <= 0.01;
select count(*) as incorrect_tax from sales where round(TaxAmount, 2) != round((GrossAmount - discountamount) * TaxPct / 100, 2);
select SaleID, GrossAmount, taxpct, taxamount, DiscountAmount, round((GrossAmount - Discountamount) * taxpct/ 100, 2) as calculated_tax from sales where round(taxamount, 2) != round((GrossAmount - Discountamount) * taxpct/ 100, 2) limit 10;
select SaleID, GrossAmount, TaxPct, TaxAmount, round((GrossAmount - DiscountAmount) * TaxPct / 100, 2) as calculated_tax from sales where abs(TaxAmount - round((GrossAmount - DiscountAmount) * TaxPct / 100, 2)) > 0.01 limit 10;
select count(*) from sales where round(NetAmount, 2) != round(GrossAmount - DiscountAmount + TaxAmount, 2);
select orderID, round(sum(NetAmount), 2) from sales group by orderID limit 6;

select o.CustomerID, round(sum(s.NetAmount), 2) as customer_total from orders o inner join sales s on o.OrderID = s.OrderID group by o.CustomerID order by customer_total desc limit 10;
select ProductID, round(sum(NetAmount), 2) as product_total from sales group by ProductID order by product_total desc limit 10;
select * from orders limit 5;
select date_format(o.orderdate,'%y-%m') as month, round(sum(NetAmount), 2) as monthly_revenue from orders o inner join sales s on o.OrderID = s.OrderID group by date_format(o.orderdate,'%y-%m') order by month;
select SaleID, Quantity, UnitPrice, DiscountPct, TaxPct, GrossAmount, DiscountAmount, TaxAmount, NetAmount from sales limit 1;
select sum(Grossamount-discountamount+taxamount) as total_rev from sales;

show index from customers;
show index from orders;
explain select * from orders where CustomerID = 100001;
select CustomerID, count(*) as order_count from orders group by CustomerID order by order_count desc limit 10;
create index idx_orders_customerid on orders(CustomerID);
select 'customers' as table_name, count(*) as row_count from customers union all select 'products', count(*) from products union all select 'orders', count(*) from orders union all select 'sales', count(*) from sales;
select 'customers' as table_name, count(*) - count(CustomerID) as null_ids from customers union all select 'products', count(*) - count(ProductID) from products union all select 'orders', count(*) - count(OrderID) from orders union all select 'sales', count(*) - count(SaleID) from sales;
select 'customers' as table_name, count(*) as production_rows from customers union all select 'products', count(*) from products union all select 'orders', count(*) from orders union all select 'sales', count(*) from sales;


-- Additional Business Analysis Questions

-- question 1: Which payment method generates the highest total revenue?
select PaymentMethod, round(sum(s.NetAmount), 2) as total_revenue from orders o inner join sales s on o.OrderID = s.OrderID group by PaymentMethod order by total_revenue desc;
-- answer 1: cash on delivery

-- question 2: Which shipping city generates the highest revenue?
select o.ShippingCity, round(sum(s.NetAmount), 2) as total_revenue from orders o inner join sales s on o.OrderID = s.OrderID group by o.ShippingCity order by total_revenue desc limit 10;
-- answer 2: chennai

-- question 3: How many repeat customers have placed more than one order?
select count(*) as repeat_customers from (select CustomerID from orders group by CustomerID having count(*) > 1) x;
-- answer 3: 124854

-- question 4: Which product category generates the highest revenue?
select p.Category, round(sum(s.NetAmount), 2) as total_revenue from products p inner join sales s on p.ProductID = s.ProductID group by p.Category order by total_revenue desc;
-- answer 4: grocery

-- question 5: Which customer segment generates the highest revenue?
select c.CustomerSegment, round(sum(s.NetAmount), 2) as total_revenue from customers c inner join orders o on c.CustomerID = o.CustomerID inner join sales s on o.OrderID = s.OrderID group by c.CustomerSegment order by total_revenue desc;
-- answer 5: consumer

