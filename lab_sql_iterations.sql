USE sakila;

-- 1 --
-- Write a query to find what is the total business done by each store.
select s.store_id, sum(p.amount) as total_payment
from store s
	join staff st on s.store_id = st.store_id
    join payment p on st.staff_id = p.staff_id
group by s.store_id;

-- 2 --
-- Convert the previous query into a stored procedure.
drop procedure if exists store_payments;
-- Create stored procedure  
delimiter //
create procedure store_payments ()
begin
	select s.store_id, sum(p.amount) as total_payment
	from store s
		join staff st on s.store_id = st.store_id
		join payment p on st.staff_id = p.staff_id
	group by s.store_id;
end;
//
delimiter ;

call store_payments();

-- 3 --
-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
drop procedure if exists store_payments;
-- Create stored procedure  
delimiter //
create procedure store_payments (in param int)
begin
	select sum(p.amount) as total_payment
	from store s
		join staff st on s.store_id = st.store_id
		join payment p on st.staff_id = p.staff_id
	where s.store_id = param;
end;
//
delimiter ;

call store_payments('1');

-- 4 --
-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result 
-- (of the total sales amount for the store). Call the stored procedure and print the results.
drop procedure if exists store_payments;
-- Create stored procedure  
delimiter //
create procedure store_payments (in param int)
begin
	declare total_sales_value float default 0.0;
	select sum(p.amount) into total_sales_value
	from store s
		join staff st on s.store_id = st.store_id
		join payment p on st.staff_id = p.staff_id
	where s.store_id = param;
    
    select total_sales_value;
end;
//
delimiter ;

call store_payments('1');

-- 5 --
-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, 
-- otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for 
-- that store and flag value.
drop procedure if exists store_payments;
-- Create stored procedure  
delimiter //
create procedure store_payments (in param1 int, out param4 int, out param3 float, out param2 varchar(20))
begin
	declare total_sales_value float default 0.0;
    declare flag varchar(20) default "";
    declare store int default 0;
    if param1 not in (1,2) then 
		select 'Invalid store ID, please provide 1 or 2';
	else
    
	select sum(p.amount) into total_sales_value
	from store s
		join staff st on s.store_id = st.store_id
		join payment p on st.staff_id = p.staff_id
	where s.store_id = param1;
    
    select total_sales_value;

case
    when total_sales_value > 30000 then
		set flag = 'green_flag';
	else
		set flag = 'red_flag';
	end case;

	select flag into param2;
    select total_sales_value into param3;
    select param1 into param4;
    end if;
end;
//
delimiter ;

call store_payments('1',@z,@y,@x);
select @z as store_id, round(@y,2) as total_sales, @x as sales_flag;

