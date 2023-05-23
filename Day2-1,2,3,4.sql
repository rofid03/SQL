-----DAY 2-----
--1.1--
select productname, categoryname, count(*)
from categories 
join products using (categoryid)
group by productname, categoryname;

--1.2--
select productname, sum(od.unitprice*quantity) as totalvalue
from products
join order_details as od using (productid)
join orders using (orderid)
where extract (year from orderdate) in (1997)
group by productname
order by totalvalue;

--1.3--
select contactname, productname, sum(od.unitprice*quantity) as total 
from customers
join orders using (customerid)
join order_details as od using (orderid)
join products using (productid)
group by contactname, productname
having sum(od.unitprice*quantity) > 5000
order by total;

--1.4--
select contactname, productname, sum(od.unitprice*quantity) as total 
from customers
join orders using (customerid)
join order_details as od using (orderid)
join products using (productid)
where orderdate between '1997-01-01' and '1997-06-30'
group by contactname, productname
having sum(od.unitprice*quantity) > 5000
order by total;

--1.5--
select cus.companyname as buyer, sup.companyname as supplier, sum(od.unitprice*quantity) as total
from customers as cus
join orders using (customerid)
join order_details as od using (orderid)
join products using (productid)
join suppliers as sup using (supplierid)
group by grouping sets (cus.companyname),(cus.companyname, sup.companyname)
order by buyer, supplier;

--1.6--
select pro.productname as product, sup.companyname as supplier, cus.companyname as buyer
from customers as cus
join orders using (customerid)
join order_details as od using (orderid)
join products as pro using (productid)
join suppliers as sup using (supplierid)
group by rollup (pro.productname, sup.companyname, cus.companyname);

--1.7--
select pro.productname as product, sup.companyname as supplier, cus.companyname as buyer, sum(od.unitprice*quantity) as total
from customers as cus
join orders using (customerid)
join order_details as od using (orderid)
join products as pro using (productid)
join suppliers as sup using (supplierid)
group by cube (pro.productname, sup.companyname, cus.companyname);




--2.1--
select distinct country  from customers c 
union
select distinct country  from suppliers s
order by country;

--2.2--
select country, count(*)  from customers c 
group by country 
union
select country, count(*) from suppliers s
group by country 
order by country;

--2.3--
select country  from customers c 
intersect 
select country from suppliers s 
order by country;

--2.4--
select city from suppliers s 
except
select city from customers c 
order by city ;

--2.5--
select city, count(*)  from customers
group by city 
except
select city, count(*)  from suppliers s 
group by city 
order by city ;



--3.1--
select distinct(companyname)
from customers
join orders using(customerid)
where customerid not in (
	select distinct(customerid)
	from orders
	where orderdate between '1997-04-01' and '1997-04-30');

--3.2--
select s.companyname from suppliers s  
join products p using (supplierid)
join order_details od using (productid)
where quantity = 1
order by s.companyname asc;

--3.3--
select distinct companyname from customers c 
join orders o on o.customerid = c.customerid 
join order_details od on od.orderid = o.orderid 
where  od.unitprice*quantity > all 
(select avg(od.unitprice*quantity)
from order_details od 
join orders on o.orderid = od.orderid 
group by customerid);

--3.4--
select c.companyname , s.city   from suppliers s 
join products p using (supplierid)
join order_details od using (productid)
join orders o using (orderid)
join customers c using (customerid)
where s.city = any (select distinct c.city from customers);


--4.1--
create table orders_sample(
		productid int, 
		orderid int, 
		unitprice int, 
		quantity int, 
		discount decimal);

insert into orders_sample 
(productid, orderid, unitprice, quantity, discount) 
values 
(11,10248,14,20,0);

select * from orders_sample;

--4.2--
update orders_sample 
set quantity = 40, discount = 0.05
where orderid = 10248;

--4.3--
delete from orders_sample 
where orderid=11078;

--4.4--
select * 
into table_orders_1997 
from orders o 
where date_part ('year', orderdate) = '1997';

--4.5--
insert into table_orders_1997 
select * from orders o 
where orderdate between '1996-12-01' and '1996-12-31';
