-- LINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_computer_store
-- 1.1 Select the names of all the products in the store.
select Name
from Products;
-- 1.2 Select the names and the prices of all the products in the store.
select Name, Price
from Products;
-- 1.3 Select the name of the products with a price less than or equal to $200.
select Name,
       Price
from Products
WHERE Price <= 200;
-- 1.4 Select all the products with a price between $60 and $120.
select Name,
       Price
from Products
WHERE Price between 60 and 120;
-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
select Name,
       Price * 100 as price_in_cents,
       Price
from Products;
-- 1.6 Compute the average price of all the products.
select avg(Price)
from Products;
-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
select AVG(Price)
from Products P
         left join Manufacturers M on P.Manufacturer = M.Code
where M.Code = 2;
-- 1.8 Compute the number of products with a price larger than or equal to $180.
select count(Name) as count_products
from Products
where Price >= 180;
-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
select Name, Price
from Products
where Price >= 180
order by Price desc, Name asc;
-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
select P.*, M.*
from Products P
         left join Manufacturers M on P.Manufacturer = M.Code;
-- 1.11 Select the product name, price, and manufacturer name of all the products.
select P.Name, P.Price, M.Name
from Products P
         left join Manufacturers M on P.Manufacturer = M.Code;
-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
select M.Code, avg(P.Price) as avg_prices
from Products P
         left join Manufacturers M on P.Manufacturer = M.Code
group by M.Code
order by M.Code;
-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
select M.Name, avg(P.Price) as avg_prices
from Products P
         left join Manufacturers M on P.Manufacturer = M.Code
group by M.Name
order by M.Name;
-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
select M.Name, avg(P.Price) as avg_prices
from Products P
         left join Manufacturers M on P.Manufacturer = M.Code
group by M.Name
having avg_prices >= 150
order by M.Name;
-- 1.15 Select the name and price of the cheapest product.
select Name, Price
from Products
order by Price
limit 1;
-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
# Solution 1: using window function
EXPLAIN ANALYZE
select *
from (select M.Name                                                  as Manufacturer_Name,
             P.Name                                                  as Procduct_Name,
             P.Price,
             rank() over (partition by M.name order by P.Price desc) as r
      from Manufacturers M
               left join Products P on M.Code = P.Manufacturer) t
where t.r = 1
order by t.Manufacturer_Name;

# Solution 2: using join and Max
select *
from (SELECT Manufacturers.Name, MAX(Price) price
      FROM Products,
           Manufacturers
      WHERE Manufacturer = Manufacturers.Code
      GROUP BY Manufacturers.Name) t
         left join (select p1.Name  as p1name,
                           p1.Code  as p1Code,
                           m1.Name  as m1Name,
                           p1.Price as p1Price
                    from Products p1
                             left join Manufacturers m1 on p1.Manufacturer = m1.Code) t1
                   on t1.m1Name = t.Name and t.price = t1.p1Price
order by t.Name;
-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
insert into Products (Code, Name, Price, Manufacturer)
values (11, 'Loudspeakers', 70, 2);
-- 1.18 Update the name of product 8 to "Laser Printer".
update Products
set Name = 'Laser Printer'
WHERE Code = 8;
-- 1.19 Apply a 10% discount to all products.
update Products
set Price = Price * 0.9
where Price > 0;
-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
update Products
set Price = Price * 0.9
where Price >= 120;