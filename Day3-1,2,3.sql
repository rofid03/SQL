-----DAY 3-----
--1.1--
create index idx_orders_customerid_orderid
on orders(customerid, orderid);

--1.2--
drop index idx_orders_customerid_orderid;

--1.3--
create table returns(
			returnid smallint not null,
			customerid smallint not null,
			date_returned date,
			productid smallint not null,
			quantity smallint not null,
			orderid smallint not null
);

--1.4--
alter table "returns" 
rename date_returned to return_date;

--1.5--
alter table "returns" 
rename to bad_orders;

--1.6--
alter table bad_orders 
add column reason text;

--1.7--
alter table bad_orders 
drop column reason;

--1.8--
alter table bad_orders
alter column quantity set data type int;

--1.9--
drop table bad_orders;



--2.1--
create table practices(
		practiceid int not null,
		practicefield varchar(50) not null,
);

--2.2--
alter table employees 
alter lastname set not null;

--2.3--
create table pets(
		petid int unique not null,
		petname varchar(25) not null
);

--2.4--
alter table shippers 
add constraint unique_companyname unique (companyname);

--2.5--
drop table pets;

--2.6--
create table pets(
		petid int primary key,
		petname varchar(25) not null
		customerid
);

--2.7--
drop table pets;

create  table pets (
		petid int primary key,
		petname varchar(25) not null,
		customerid char(5) not null,
		foreign key (customerid) references customers (customerid)
);

--2.8--
create  table pets (
		petid int primary key,
		petname varchar(25) not null,
		customerid char(5) not null,
		weight int constraint pets_weight check (weight > 0 and weight < 200 ),
		foreign key (customerid) references customers (customerid)
);




--3.1--
with list_customer_ordered as(
	select productid, sum(quantity)
	from order_details od 
	group by productid
	order by sum(quantity) limit 2
)
select c.companyname from customers c
join orders o using (customerid)
join order_details od using (orderid)
join list_customer_ordered using (productid);

--3.2--
with list_product as (
	select productid, productname, sum(quantity) as ordered
	from products p 
	join order_details od using (productid)
	group by productid, productname
	order by ordered limit 2
	),
list_customer as (
	select customerid, companyname, quantity*unitprice as sales
	from customers 
	join orders using (customerid)
	join order_details as od using (orderid)
	join list_product using (productid)
	)
select companyname, sum(quantity*unitprice) as sales, sum(quantity*unitprice)/(select sum(quantity*unitprice) from order_details) * 100 as percentage
from order_details
join orders using (orderid)
join list_customer using (customerid)
group by companyname
order by percentage desc;
