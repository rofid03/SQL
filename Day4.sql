-----DAY 4-----
--contoh 1--
select companyname, country,
case when country in ('Austria', 'Germany', 'Poland') then 'Europe'
	 when country in ('Mexico', 'USA', 'Canada') then 'North America'
	 when country in ('Brazil', 'Venezuela', 'Argentina') then 'South America'
	 else 'unknown'
end as continent
from customers;

--soal 1--
select productname, unitprice,
case when unitprice <= 10 then 'inexpensive'
	 when unitprice between 10 and 50 then 'mid-range'
	 else 'expensive'
end as corresponding
from products
order by unitprice asc;


--contoh 2--
select companyname, 
case city when 'New Orleans' then 'Big Easy'
		  when 'Paris' then 'City of Lights'
		  else  city 
end
from suppliers;

--soal 2--
select orderid, customerid, orderdate, 
case when date_part('year', orderdate) in (1996) then 'year1'
	 when date_part('year', orderdate) in (1997) then 'year2'
	 when date_part('year', orderdate) in (1998) then 'year3'
	 else 'other year'
end as years
from orders
order by orderdate asc;


--contoh 3--
select customerid, coalesce(shipregion, 'N/A')
from orders;

--soal 3--
select companyname, coalesce(homepage, 'Call to find')
from suppliers;


--contoh 4--
select companyname, phone, coalesce (nullif(homepage,''), 'Need to call')
from suppliers;

--soal 4--
select companyname, phone, coalesce(nullif(fax,''),phone) as secondary
from customers;


--contoh 5--
select categoryname, productname, unitprice, avg(unitprice) over (partition by categoryname)
from products
join categories c using (categoryid);

--soal 5--
select orderid,  productname, quantity, avg(quantity) over (partition by productname)
from products p 
join order_details using (productid)
where productname = 'Alice Mutton';


--contoh 6--
select companyname, orderid, amount, avg(amount) over (partition by companyname) as average_order
from (select companyname, orders.orderid, sum(unitprice*quantity) as amount
	  from customers 
	  join orders using (customerid)
	  join order_details od using (orderid)
	  group by companyname, orders.orderid) as order_amounts;
	  
--soal 6--
select companyname, bulan, amount, avg(amount) over (partition by companyname) as average_order,
	case
		when amount > avg(amount) over (partition by companyname)* 3 then 'Extraordinary'
		else 'Normal'
	end as reminder
from (select companyname, date_part('month', orderdate) as bulan, sum(od.unitprice * od.quantity)as amount
	  from suppliers s
		join products p using (supplierid)
		join order_details od using (productid)
		join orders o using (orderid)
		group by companyname, bulan) as amount_month
	 
	 
--contoh 7--
select * from
(select orders.orderid, productid, unitprice, quantity,
rank() over (partition by od.orderid 
order by (quantity*unitprice) desc) as rank_amount
from orders
natural join order_details od) as ranked
where rank_amount <= 2;

--soal 7--
select * from
(select companyname, productname, unitprice,
rank() over (partition by s.companyname 
order by (unitprice) desc) as rank_expensive
from suppliers s 
natural join products) as expensive
where rank_expensive <= 3
order by rank_expensive;


--contoh 8--
create or replace function fix_homepage() returns void as $$
	update suppliers
	set homepage = 'N/A'
	where homepage is not null
$$ language sql

select fix_homepage();

--soal 8--
create or replace function set_employee_default_photo() returns void as $$
	update employees 
	set photopath = 'http:/accweb/employees/default.bmp'
	where photopath is not null 
$$ language sql 

select set_employee_default_photo();


--contoh 9--
create or replace function customer_largest_order(cid bpchar) returns double precision as $$
	select max(order_total) from
	(select sum(quantity*unitprice) as order_total, orderid
	from order_details
	natural join orders
	where customerid = cid
	group by orderid) as order_total
$$ language sql

select customer_largest_order('ANATR');

--soal 9--
create or replace function most_ordered_product(pid varchar) returns double precision as $$
	select max(order_total) from
	(select sum(quantity*unitprice) as order_total, productid
	from order_details
	natural join products
	where productname = pid
	group by productid) as product_total
$$ language  sql

select most_ordered_product('Chai');

--contoh 10--
create or replace function sum_n_product (x int, y int, out sum int, out product int) as $$
	select x*y, x*y
$$ language sql

select sum_n_product(5,20);

--soal 10--
create or replace function square_n_cube(x int, out sqrt int , out cbrt int) as $$
	select power(x, 2), power(x, 3)
$$ language sql

select square_n_cube(3);

--contoh 11--
create or replace function sold_more_than(total_sales real)
returns setof products as $$
	select * from products
	where productid in (
		select productid from
		(select sum(quantity*unitprice), productid
		from order_details
		group by productid
		having sum(quantity*unitprice) > total_sales
		) as qualified_products
	)
$$ language sql 

select productname, productid
from sold_more_than(25000);

--soal 11--
create or replace function total_sales_more_than(x int, total_sales real)
returns setof products as $$
	select * from products
	where productid in (
		select productid from
		(select sum(quantity*unitprice), productid 
		from order_details
		group by productid
		having total_sales > x) as qualified_products
		)
$$ language sql 


select productname, productid
from total_sales_more_than(20000, 50000);

--12--
create or replace function next_birthday()
returns table (birthday date, firstname varchar(10), lastname varchar(20), hiredate date) as $$
	select (birthdate + interval '1 YEAR' * (extract(year from age(birthdate))+1))::date,
	firstname, lastname, hiredate
	from employees
$$ language sql

select * from next_birthday();


--13--
create or replace procedure add_em(x int, y int) as $$
	select x + y
$$ language sql;

call add_em(5,10);
