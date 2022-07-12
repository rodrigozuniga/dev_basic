use classicmodels;

#define start row and how many rows from the start
select *
from orders
limit 100,22;

#unix timestamp
select now(), unix_timestamp(now());

#define year to date compared to previous year
select orderDate
,yearweek(orderDate)
,date_format(orderDate,'%Y-01-01') start_year 
,datediff(orderDate,date_format(orderDate,'%Y-01-01'))
,date_format(date_sub(orderDate,interval 1 year),'%Y-01-01') start_previous_year
,date_sub(orderDate,interval 1 year) orderDate_previous_year
from orders;

#rank and dense_rank deal differently with tied values
select orderDate
, count(*)
, dense_rank() over (order by count(*) desc)
from orders
group by 1
order by 3;

#Window function only happens after grouping
select orderDate, sum(count(*)) over (partition by year(orderDate) order by orderDate)
from orders
group by 1
order by orderDate;
;

with tbl1 as
(
select distinct paymentDate, amount, rank() over (partition by year(paymentDate) order by amount) as ranking
from payments
)
select * 
from tbl1
where ranking <=3;

#the default is unbounded preceding to current row
#the default has different effects on first_value than on last_value
select 
 distinct year(paymentDate)
,paymentDate
,customerNumber
,first_value(customerNumber) over (partition by year(paymentDate) order by amount) as val_first
,first_value(amount) over (partition by year(paymentDate) order by amount) as val_first
,last_value(amount) over (partition by year(paymentDate) order by amount desc rows between unbounded preceding and unbounded following) as val_last
,last_value(amount) over (partition by year(paymentDate) order by amount desc range between unbounded preceding and unbounded following) as val_last_2
from classicmodels.payments;

#For each value you count the number of values that are +-1000 from the value
select *
,count(amount) over (order by amount range between 5000 preceding and 5000 following)
from classicmodels.payments
order by amount 
;

#LAGS AND LEADS:

select orderDate
,count(*)
,lag(count(*)) over (order by orderDate)   lag1
,lag(count(*),2) over (order by orderDate) lag2
,lead(count(*)) over (order by orderDate)   lead1
,lead(count(*),2) over (order by orderDate) lead2
from orders
group by orderDate;