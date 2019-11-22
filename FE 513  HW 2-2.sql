----Assignment 2
----Question 1

---------------Create table------------
drop table banks_al_2001;
CREATE table banks_al_2001(id integer NOT NULL, dates date NOT null,asset float,liability float);
--------------Import Data--------------
----\copy banks_al_2001(id, dates, asset, liability) from '/Users/rhearepe/Downloads/banks_al_2001.csv' delimiter ',' csv header;
--------------View Data-----------------
select * from banks_al_2001;

------------Count the number of banks whose equity is over 10% of its asset in the first quarter(hint: equity = asset-liability).------

alter table banks_al_2001 add equity float;
UPDATE banks_al_2001 set equity = asset - liability;


select count(*) as cnt from banks_al_2001 where dates = '3/31/2001' and equity > 0.1*asset;
----4417

----What is the average liability value for banks whose asset is higher than average asset value in first quarter.
select avg(liability)::integer from banks_al_2001 where asset > (select avg(asset) from banks_al_2001) and dates between '2001-01-01' and '2001-3-31' ;
-----Display ID for banks with second largest asset
select id from banks_al_2001 order by asset desc offset 1 row fetch next 1 row only;
-----3510

-----Count number of banks for each 
select count (*) from banks_al_2001 group by dates order by dates;

------Question 2 
-----What is the difference between inner join and intersect? Please give an example.
-----A JOIN clause is used to combine rows from two or more tables, based on a related column between them.
--The INNER JOIN keyword selects records that have matching values in both tables. 
---The INNER JOIN creates a new result table by combining column values of two tables (table1 and table2) based upon the join-predicate. 
--The query compares each row of table1 with each row of table2 to find all pairs of rows which satisfy the join-predicate. 
---When the join-predicate is satisfied, column values for each matched pair of rows of A and B are combined into a result row.
 	 ----Create two tables customers and orders for examples
create table customers(
   id  int   not null,
   name varchar (20) not null,
   age int not null,
   address char (25) ,
   salary decimal(18, 2),       
   primary key (id)
);

insert into customers (id, name, age, address, salary)
values (1, 'Ramesh', 32, 'Ahmedabad', 2000.00 );

insert into customers (id, name, age, address, salary)
values(2, 'Khilan', 25, 'Delhi', 1500.00 );

insert into customers (id, name, age, address, salary)
values (3, 'kaushik', 23, 'Kota', 2000.00 );

insert into customers (id, name, age, address, salary)
values (4, 'Chaitali', 25, 'Mumbai', 6500.00 );

insert into customers (id, name, age, address, salary)
values(5, 'Hardik', 27, 'Bhopal', 8500.00 );

insert into customers (id, name, age, address, salary)
values(6, 'Komal', 22, 'MP', 4500.00 );


select * from customers;


create table orders(
   oid  int   not null,
   dates date not null,
   customer_id int not null,
   amount float
);	

insert into orders (oid, dates, customer_id, amount) 
values( 102, '2009-10-08', 3 , 3000);
	
insert into orders (oid, dates, customer_id, amount) 
values( 100, '2009-10-08', 3, 1500 );

insert into orders (oid, dates, customer_id, amount) 
values( 101, '2009-11-20', 2 , 1560);


insert into orders (oid, dates, customer_id, amount) 
values( 103, '2008-05-20', 4, 2060);

select * from orders;

-----Example for inner join


select id, name, amount from customers inner join orders on customers.id = orders.customer_id;
   
   -----takes id and name from table of customers and amount from order table by matching customer id.
   
 -----Intersect
 ----Inner join and Intersect do the similar things, which is to select the same value from the two tables.  
-----The SQL INTERSECT clause/operator is used to combine two SELECT statements, but returns rows only from the first SELECT statement that are identical to a row in the second SELECT statement. 
---This means INTERSECT returns only common rows returned by the two SELECT statements.


select id, name, amount from customers left join orders on customers.id = orders.customer_id
intersect select id, name, amount from customers right join orders on customers.id = orders.customer_id;
   
 
-----Delete duplicate rows from banks sec 2002

drop table banks_sec_2002;
create table banks_sec_2002 (
id integer not NULL, dates date not NULL, security float
);

----\COPY banks_sec_2002 FROM '/Users/rhearepe/Downloads/banks_sec_2002.csv' WITH (FORMAT csv, HEADER true);

select * from banks_sec_2002 order by id;
select distinct id, dates, security from banks_sec_2002 order by id; -- use "distinct" to remove duplicate rows



--------Import data from banks sec 2002 and banks al 2002.csv. 
drop table banks_al_2002;
CREATE TABLE banks_al_2002 (
al_id integer NOT NULL, al_dates date NOT NULL, al_asset float,
al_liability float);

---\COPY banks_al_2002 FROM '/Users/rhearepe/Downloads/banks_al_2002.csv' WITH (FORMAT csv, HEADER true);

select * from banks_al_2002;

drop table banks_sec_2002;
CREATE TABLE banks_sec_2002 (
sec_id integer NOT NULL, sec_dates date NOT NULL, sec_security float
);
---\COPY banks_sec_2002 FROM '/Users/rhearepe/Downloads/banks_sec_2002.csv' WITH (FORMAT csv, HEADER true);

select * from banks_sec_2002;



-------How many banks have security over 20% of its’ asset in the first quarter of 2002.


alter table banks_al_2002 add al_equity float; 
update banks_al_2002 set al_equity = al_asset - al_liability;


select count (*) from banks_al_2002 al inner join banks_sec_2002 sec on (al_id = sec_id AND al_dates ='2002-03-31' )
where sec_security > 0.2*al_asset and ((date_part('month', al_dates) >= 1 and date_part('month', sec_dates) <= 3));

----984 banks have secuirties over 20% of its assets in the first quarter of 2002

---How many banks have liability over 90% of assets in last quarter of 2001 but goes below 90% in first quarter of 2002.


select count (*) from banks_al_2001 where (0.9*asset < liability AND dates between '10/01/2001' and '12/31/2001')
intersect select al_id from banks_al_2002 where (0.9*al_asset > al_liability AND al_dates between '01/01/2002' and '03/31/2002');



-------5523 banks have 

----Get banks’ asset and security whose security is over average in first quarter of 2002. Export the result to a csv file.
drop table security;
create table security(
sid integer NOT NULL, sassets float NOT NULL, ssecurity float
);
insert into security
select al_id, al_asset, sec_security from banks_al_2002 al inner join banks_sec_2002 sec on (al_id = sec_id AND al_dates = '03/31/2002')
where sec_security > (select avg(sec_security) from banks_sec_2002 where (date_part('month',al_dates) >= 1 AND date_part('month',al_dates) <= 3)) order by al_id;

----\copy security to '/users/rhearepe/Downloads/questions2.csv' delimiter ',' csv header;																		  
																		  
------Create a new table banks al. Copy all the records from the any two existing tables in database to this new table. 
------Then set a primary key for the table.
																		  
drop table banks_al; 
CREATE TABLE banks_al (
id integer NOT NULL, dates date NOT NULL, asset float,
liability float,
equity float );		


insert into banks_al select * from banks_al_2001 union select *from banks_al_2002;
select * from banks_al;																		  

																		  
alter table banks_al add primary key (id, dates);		
select * from banks_al;
																		  
																		  
