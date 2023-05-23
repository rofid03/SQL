-----DAY 1-----
--2.1--
select * from data_src
where journal = 'Food Chemistry';
select count(*) from data_src
where journal = 'Food Chemistry';

--2.2--
select * from food_des;
select * from food_des
where manufacname = 'Kellogg, Co.';


--2.3--
select * from data_src
where year > 2000;
select count(*) from data_src
where year > 2000;

--2.4--
select * from food_des
where pro_factor > 1.5 and fat_factor < 5;
select count(*) from food_des
where pro_factor > 1.5 and fat_factor < 5;

--2.5--
select * from data_src
where year = 1990 and journal = 'Cereal Foods World';

--2.6--
select * from nutr_def;
select * from nutr_def
where units = 'kcal' or units = 'kj';

--2.7--
select * from data_src
where year = 2000 or journal = 'Food Chemistry';
select count(*) from data_src
where year = 2000 or journal = 'Food Chemistry';

--2.8--
select * from data_src
where year between 1990 and 2000 and (journal = 'J. Food Protection' or journal = 'Food Chemistry');

--2.9--
select * from weight;
select * from weight
where gm_wgt between 50 and 75;
select count(*) from weight
where gm_wgt between 50 and 75;

--2.10--
select * from data_src
where year in (1960, 1970, 1980, 2000);