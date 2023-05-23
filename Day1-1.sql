----Day 1----
--1.1--
select * from staff;
select count(*) from staff;

--1.2--
select * from address;
select address from address;
select distinct address from address;

--1.3--
select * from customer;
select last_name from customer;
select distinct last_name from customer;

--1.4--
select * from film;
select count(*) from film;

--1.5--
select * from actor;
select first_name from actor;
select distinct first_name from actor;
select count(distinct first_name) from actor;

--1.6--
select * from rental;
select rental_id, return_date, rental_date from rental;
select rental_id, return_date-rental_date as difference from rental;