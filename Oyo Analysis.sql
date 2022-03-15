/*creating a database*/
create database OYO;

/*Using OYO as a database*/
use	OYO;

/*creating a table for booking details*/
create table oyo_hotels
(
booking_id integer not null,
customer_id bigint, /*The SQL type bigint is typically no shorter than a 64 big signed integer (-9223372036854775808 to 9223372036854775807)*/
status text,
check_in text,
check_out text,
no_of_rooms integer,
hotel_id integer,
amount float,
discount float,
date_of_booking text
);
select * from oyo_hotels;

/*Number of hotels in dataset*/
select count(distinct hotel_id) from oyo_hotels;

/*to check all tables in database*/
show tables;

/* create a new table name "city_table"*/
use oyo;
create table city_table(
Hotel_id integer not null,
City text);

/*Number of hotels in distinct city in dataset*/
select count(distinct Hotel_id) from city_table;

/*Number of hotels by city*/
select count(hotel_id) as "Hotel-ID",City from city_table
group by City;

/*New column added and Changing the check in, check out and date of booking to SQL format*/
alter table oyo_hotels add column new_check_in date;
update oyo_hotels 
set new_check_in = str_to_date(substr(check_in, 1,10), '%d-%m-%y');
/*delete a column newcheck_in*/
ALTER TABLE oyo_hotels DROP COLUMN newcheck_in;
alter table oyo_hotels add column newdate_of_booking date;
update oyo_hotels
set newdate_of_booking = str_to_date(substr(date_of_booking, 1, 10), '%d-%m-%y');
alter table oyo_hotels add column new_check_out date;
update oyo_hotels
set new_check_out = str_to_date(substr(check_out,1,10),'%d-%m-%Y');

/*New column price is added*/
alter table oyo_hotels add column	price float;
update oyo_hotels
set price = amount + discount;

/*New column no_of_nights is added*/
alter table oyo_hotels add column no_of_nights int;
update oyo_hotels
set no_of_nights = datediff(new_check_out, new_check_in);

/*New column "rate" is added*/
alter table oyo_hotels add column rate float;
update oyo_hotels
set rate = round(if(no_of_rooms = 1, (price/no_of_nights), (price/no_of_nights)/no_of_rooms), 2);
select	* from oyo_hotels;

/*Avg room rate by city*/
select round(avg(rate),2) as avg_rate,City from oyo_hotels o, 
city_table c where  o.hotel_id = c.Hotel_id 
group by City order by 1 desc;

/*Bookings made for the months of January, february and March. This can even contain booking made for months other than jan, feb and march*/
select count(booking_id) as 'no._of_booking_id',City, month(newdate_of_booking) as 'month' from oyo_hotels o,
city_table c where month (newdate_of_booking) between 1 and 3 
and o.hotel_id = c.hotel_id 
group by City,month(newdate_of_booking);

/*Bookings made for the months of January, february and March.*/
select count(booking_id) as 'no._of_booking_id',City, month(new_check_in) as 'month' 
from oyo_hotels o,
city_table c where month (new_check_in) between 1 and 3 
and o.hotel_id = c.hotel_id 
group by City,month(new_check_in);

/*How many days prior the bookings were made*/
select count(*),datediff(new_check_in, newdate_of_booking) as date_iff 
from oyo_hotels group by 2 order by 2 asc;
select * from oyo_hotels;