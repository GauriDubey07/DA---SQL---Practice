-- DAY -3 
-- 1)	Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.
-- State should not contain null values	credit limit should be between 50000 and 100000

USE classicmodels;
select * from customers;
select customerNumber , customerName , state ,creditLimit from customers where state is not null and creditLimit between 50000 and 100000 order by creditLimit desc ;


-- 2)	Show the unique productline values containing the word cars at the end from products table.
select * from products ;
Select distinct productLine from products where productLine like '%Cars'; 


-- DAY - 4
-- 1)Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.
select orderNumber, status, 
       case 
           when comments is null then '-'
           else comments
       end as comments
from orders
where status = 'Shipped';

-- 2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
-- If job title is one among the below conditions, then job title abbreviation column should show below forms.
-- President then “P”
-- Sales Manager / Sale Manager then “SM”
-- Sales Rep then “SR”
-- Containing VP word then “VP”

select employeeNumber , firstName ,jobtitle ,
	case
			when jobTitle = 'President' then 'P'
            when jobTitle Like '%Sales Manager%' then 'SM'
            when jobTitle Like '%Sale Manager%' then 'SM'
            when jobtitle = 'Sales Rep' then 'SR'
            when jobTitle Like '%VP%' then 'VP'
            else jobTitle 
		End as jobtitleAbbreviation
	from employees;
        
        
-- DAY- 5
-- 1)	For every year, find the minimum amount value from payments table.
select * from payments;
select year(paymentDate) as paymentYear, min(amount) as minAmount from payments group by paymentYear order by paymentyear;

-- 2)	For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.
select 
	concat('Q' , quarter(orderDate)) as quarter ,
    year(orderDate) as year, 
    count(distinct customerNumber) as uniqueCustomers,
    count(*) as totalOrders from 
	orders 
    group by year , quarter
    order by year , quarter ;  
    
    
-- 3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]
 select * from payments;
 select concat(format(sum(amount) / 1000 ,0 ) ,'K') 
	as formattedAmount , date_format(paymentDate , '%b') as month ,
    sum(amount) as totalAmount 
    from payments group by month 
    having sum(amount) between 500000 and 1000000 
    order by totalAmount desc;
    
    
    -- DAY- 6
    -- 1)	Create a journey table with following fields and constraints.
-- Bus_ID (No null values)
-- Bus_Name (No null values)
-- Source_Station (No null values)
-- Destination (No null values)
-- Email (must not contain any duplicates)

create table journey(
	Bus_ID int not null ,
    Bus_Name varchar(300) not null,
    Source_Station varchar(300) not null,
    Destination varchar(300) not null,
    Email varchar(250) not null unique,
    constraint pk_journey primary key (Bus_ID)
    );
    
-- 2)	Create vendor table with following fields and constraints.
-- Vendor_ID (Should not contain any duplicates and should not be null)
-- Name (No null values)
-- Email (must not contain any duplicates)
-- Country (If no data is available then it should be shown as “N/A”)
create table Vendor (
	Vendor_ID int not null unique,
    Name varchar(300) not null ,
    Email varchar(250) not null unique,
    Country varchar(250) default 'N/A' ,
    constraint pk_vendor primary key (Vendor_ID)
    );
    

-- 3)Create movies table with following fields and constraints.
-- Movie_ID (Should not contain any duplicates and should not be null)
-- Name (No null values)
-- Release_Year (If no data is available then it should be shown as “-”)
-- Cast (No null values)
-- Gender (Either Male/Female)
-- No_of_shows (Must be a positive number)
create table Movies (
	Movie_ID int not null unique,
    Name varchar(300) not null,
    Release_Year varchar (10) default'-',
    Cast varchar(300) not null,
    Gender enum('Male','Female'),
    No_of_Show int check(No_of_Show > 0),
    constraint pk_movies primary key (Movie_ID)
    );
    
-- 4)	Create the following tables. Use auto increment wherever applicable
-- Product
create table Product(
		product_id int auto_increment primary key,
        product_name varchar(250) not null unique,
        description text,
        supplier_id int,
        foreign key (supplier_id) references Suppliers(supplier_id)
        );
-- Suppliers
create table Suppliers(
	supplier_id int auto_increment primary key,
    supplier_name varchar(255),
    location varchar(255)
    );
-- Stock 
create table Stock(
	id int auto_increment primary key,
    product_id int,
    balance_stock int,
    foreign key (product_id) references Product(product_id)
    );
    -- DAY-7:
  --   1)	Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
    select 
    e.employeeNumber as employee_number,
    concat(e.firstName, ' ', e.lastName) as Sales_Person,
    (select count(distinct customerNumber) 
     from Customers 
     where salesRepEmployeeNumber = e.employeeNumber) as unique_customers
from 
    Employees e
order by 
    unique_customers desc;

-- 2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.
select 
	c.customerNumber,
    c.customerName,
    p.productCode,
    p.productName,
    sum(od.quantityOrdered) as total_quantities_ordered,
    sum(p.quantityInStock) as total_quantites_in_stock,
    sum(p.quantityInStock) - sum(od.quantityOrdered) as left_over_quantities 
from
	Customers c join Orders o on c.customerNumber = o.customerNumber join OrderDetails od on o.orderNumber = od.orderNumber join Products p on od.productCode = p.productCode 
    group by c.customerNumber, p.productCode order by c.customerNumber;
  
-- 3)	Create below tables and fields. (You can add the data as per your wish)
-- Laptop: (Laptop_Name)
-- Colours: (Colour_Name)
-- Perform cross join between the two tables and find number of rows.
create table Laptop( Laptop_Name varchar(200));
create table Colours( Colour_Name varchar(200));
insert into Laptop(Laptop_Name) values ('Dell'),('Dell'),('Dell'),('HP'),('HP'),('HP');	
insert into Colours( Colour_Name) values ('White'),('Silver'),('Black'),('White'),('Silver'),('Black');	
select Laptop.Laptop_Name , Colours.Colour_Name from Laptop cross join Colours;

-- 4)	Create table project with below fields.Find out the names of employees and their related managers.
create table Project( EmployeeID int, FullName varchar(200)  , Gender varchar(10) , ManagerID int );
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select  m.FullName as Manager_Name , e.FullName as Employee_Name from Project e left join Project m on e.ManagerID = m.EmployeeID order by m.FullName , e.FullName;

-- DAY 8
-- Create table facility. Add the below fields into it.
create table facility (Facility_ID int , Name varchar(250), State varchar(250), Country varchar(250));
-- ) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type as varchar which should not accept any null values.
alter table facility add column city varchar(250) not null after Name , add primary key(Facility_ID);
show columns from facility;

-- DAY 9
-- Create table university with below fields Remove the spaces from everywhere and update the column like Pune University etc.
SET SQL_SAFE_UPDATES = 0;
create table University (ID int , Name varchar(200));
insert into University values (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi      University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
update University set Name = TRIM(Name) where ID > 0;
select * from University;

-- Day 10
-- Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.
select Year, concat(Total_Products_Sold, ' (', format(Percentage_Total_Value, 2),  '%)') as value
FROM products_status;

-- Day 11
-- 1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.
DELIMITER //

create procedure GetCustomerLevel (in customerNumber int)
begin 
    declare customerCredit decimal(10, 2);

    select creditLimit into customerCredit
    from Customers
    where customerNumber = customerNumber;

    if customerCredit > 100000 then
        select 'Platinum' as CustomerLevel;
    elseif customerCredit >= 25000 and customerCredit <= 100000 then
        select 'Gold' as CustomerLevel;
    else
        select 'Silver' as CustomerLevel;
    end if;
end//

DELIMITER ;

-- 2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
DELIMITER //
create procedure Get_country_payment( in input_year int , in input_country varchar (300))
begin
	select year(p.paymentDate) as year, c.country as Country, concat(format(sum(p.amount),0),'k') as Total_Amount
    from Payment p join Customer c on p.customerNumber = c.customerNumber 
    where year(p.paymentDate)= input_year and c.country=input_country
    group by year,Country;
end//
DELIMITER ;
call Get_country_payments(2003,'France');

-- Day 12
-- 1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
select 
	year(orderDate) as year,
    monthname(orderDate) as Month_Name,
    count(*) as Order_count,
	concat(format((count(*) - lag(count(*), 12) over (order by year(orderDate), month(orderDate))) / lag(count(*), 12) over (order by year(orderDate), month(orderDate)) * 100, 0), '%') as YoY_Percentage_Change
from
		Orders
group by 
	year , month(orderDate), Month_Name
order by 
	year , month(orderDate);


-- 2) SELECT Name, DOB, calculate_age(DOB) AS Age FROM emp_udf;
-- create the ep_udf table 
create table emp_udf(
	Emp_ID int auto_increment primary key,
    Name varchar(300),
    DOB date);
-- instert data
insert into emp_udf(Name, DOB)
values ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
-- Step 3: Create the calculate_age user-defined function
DELIMITER //
create function calculate_age(DOB date) returns varchar(50) deterministic
begin
    declare years int;
    declare months int;
    declare age varchar(50);
    -- Calculate years
    set years = timestampdiff(year, DOB, curdate());
    -- Calculate months
    set months = timestampdiff(month, DOB, curdate()) - (years * 12);
    -- Construct age string
    set age = concat(years, ' years ', months, ' months');
    return age;
end;//
DELIMITER ;
select Emp_ID,Name , DOB , calculate_age(DOB) as Age from emp_udf;

select customerNumber, customerName
from Customers
where customerNumber not in (select distinct customerNumber from Orders);

-- Day 13
-- 1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
select customerNumber , customerName from customers
	where customerNumber not in (select distinct customerNumber from Orders);

-- 2)	Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
select c.customerNumber , c.customerName , 
	count(o.orderNumber) as orderCount 
from customers c 
left join orders o on c.customerNumber = o.customerNumber
group by c.customerNumber, c.customerName
union all 
select c.customerNumber , c.customerName,
count(o.orderNumber) as orderCount
from customers c
right join orders o 
on c.customerNumber = o.customerNumber and o.customerNumber is null
group by c.customerNumber, c.customerName;    

-- 3)	Show the second highest quantity ordered value for each order number.
select orderNumber , quantityOrdered as second_highest_quantity 
from orderdetails od1 
where (select count(distinct quantityOrdered) from orderdetails od2 where od2.orderNumber = od1.orderNumber and od2.quantityOrdered>od1.quantityOrdered)<2
order by orderNumber,quantityOrdered desc;

-- 4)	For each order number count the number of products and then find the min and max of the values among count of orders.
select min(orderCount) as MIN_TOTAL ,max(orderCount) as MAX_TOTAL
from(select count(*) as orderCount 
from orderdetails 
group by orderNumber) as subquery;

-- 5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.
select productline, count(*) as num_product_lines
from products where buyPrice>(select avg(buyPrice) from products)
group by productLine;


-- DAY 14
-- Create the table Emp_EH. Below are its fields.
-- Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong
-- Create the Emp_EH table
create table Emp_EH(EmpID int primary key,
					EmpName varchar(100),
                    EmailAddress varchar(100));
                    
DELIMITER //
create procedure inserEmpEH (in p_EmpID int , in p_EmpName varchar(100) , in p_EmailAddress varchar(100))
begin
	declare exit_handler int default 0;
    declare err_msg varchar(100);
   declare continue handler for sqlexception 
begin 
get diagnostics condition 1 err_msg = message_text;
rollback;
select concat('Error occurred: ' ,err_msg) as Messsage ;
end;
start transaction ;
insert into Emp_EH (EmpID,EmpName,EmailAddress)    
values(p_EmpID,p_EmpName,p_EmailAddress);
commit ;
end;
//
DELIMITER ;

call InsertEmpEH(1, 'John Smith', 'john.smith@example.com');
call InsertEmpEH(2, 'Jane Doe', 'Jane.Doe@example.com');
call InsertEmpEH(3, 'Bob Johnson', 'Bob.Johnson@example.com');
select * from Emp_EH;
					
                    

--  Day 15
-- Create the table Emp_BIT. Add below fields in it.
-- Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.
create table Emp_BIT(Name varchar(50),
					Occupation varchar(50),
                    Working_date date,
                    Working_hours int );
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);
DELIMITER //
create trigger before_insert_Emp_BIT
before insert on Emp_BIT for each row
begin
	if new.Working_hours < 0 then
		set new.Working_hours = -new.Working_hours;
	end if;
end;
//
DELIMITER ;
select * from Emp_BIT;






