-----DAY 1-----
--3.1--
select * from sales.salesorderdetail;
select * from sales.salesorderdetail
where productid = 799;

--3.2--
select * from sales.specialoffer s
order by discountpct desc;
select * from sales.specialoffer s
where  discountpct = 0.5;

--3.3--
select * from production.workorder;
select scrappedqty from production.workorder
where  productid = 529;
select sum(scrappedqty) from production.workorder
where  productid = 529;

--3.4--
select * from purchasing.vendor v ;
select name from purchasing.vendor
where name like 'G%';

--3.5--
select * from person.person p ;
select firstname  from person.person p 
where firstname like '_t%';

--3.6--
select * from person.emailaddress e ;
select * from person.emailaddress e
order by emailaddress limit 20;

--3.7--
select * from person.person;
select * from person.person
where  additionalcontactinfo is not null ;
select count(*)  from person.person
where  additionalcontactinfo is not null ;


--4.1--
select firstname, middlename, lastname, phonenumber, person.phonenumbertype.name
from person.person
inner join person.personphone on person.person.businessentityid = person.personphone.businessentityid
inner join person.businessentity on person.person.businessentityid = person.businessentity.businessentityid
inner join person.phonenumbertype on person.personphone.phonenumbertypeid = person.phonenumbertype.phonenumbertypeid
order by person.businessentity.businessentityid desc;

--4.2--
select production.product.name, production.productreview.rating, production.productreview.comments
from production.product
join production.productreview on production.product.productid = production.productreview.productid
order by production.productreview.rating asc;

--4.3--
select production.product.name, production.workorder.orderqty, production.workorder.scrappedqty
from production.workorder
right join production.product on production.workorder.productid = production.product.productid
order by production.product.productid asc;