--Lesson 30: Project
drop table books;
create table Books (Book_id int primary key,
					Title text not null,
					Author varchar(100) not null,
					Genre varchar (100) not null,
					Published_year int not null,
					price decimal not null,
					Stock int not null);
select * from books;

drop table Customers;
create table Customers (Customer_id int primary key,
						Name varchar(100) not null,
						Email varchar(100) unique not null,
						Phone int not null,
						City varchar(100) not null,
						Country varchar(200) not null);
select * from Customers;

create table Orders(Order_id int primary key,
					Customer_id int not null,
					Book_id int not null,
					Order_date text not null,
					Quantity int not null,
					Total decimal not null);
select * from Orders;

-- 1) Retrieve all books in the "Fiction" genre:
select * from books
where genre='Fiction';

-- 2) Find books published after the year 1950:
select * from books
where published_year>1950;

-- 3) List all customers from the Canada:
select * from customers
where country='Canada';

-- 4) Show orders placed in November 2023:
select * from orders
alter table orders
drop column year; 
alter table orders
drop column month;
alter table orders
add year text,
add month text;

alter table orders
add formated_date date;

update orders
set formated_date =to_date(order_date, 'yyyy-mm-dd');
select * from orders;

update orders
set year=extract(year from formated_date)
update orders
set month=extract(month from formated_date)

select * from orders
where year='2023' and month='11';

-- 5) Retrieve the total stock of books available:
select * from books;
select sum(stock) from books;

-- 6) Find the details of the most expensive book:
select * from books order by price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders where quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders where total>20;

-- 9) List all genres available in the Books table:
select distinct genre from books;

-- 10) Find the book with the lowest stock:
select * from books order by stock limit 6;

-- 11) Calculate the total revenue generated from all orders:
select sum(total) from orders;


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select * from books;
select * from orders;

select b.genre, sum(o.quantity)
from books b
join orders o on b.book_id=o.book_id
group by b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
select * from books;
select avg(price) as Avg_price_fantasy from books where genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
select * from orders;
select * from customers;

select c.customer_id, c.name, count (order_id) as order_count
from customers c
join orders o on o.customer_id=c.customer_id
group by c.customer_id, c.name having count (order_id)>=2; 


-- 4) Find the most frequently ordered book:
select * from orders;
select * from books;

select b.book_id, b.title, count (order_id) as order_count
from books b
join orders o on b.book_id=o.book_id
group by b.book_id, b.title order by order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
select * from books where genre='Fantasy' order by price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select * from books;
select * from orders;
select b.author, sum(o.quantity) as total_books
from books b
join orders o on b.book_id=o.order_id
group by b.author order by total_books desc;

-- 7) List the cities where customers who spent over $30 are located:
select * from customers;
select * from orders;
select distinct c.city, o.total
from customers c
join orders o on c.customer_id=o.customer_id
where o.total>30;

-- 8) Find the customer who spent the most on orders:
select * from customers;
select * from orders order by total desc;
select c.customer_id, c.name, sum(o.total) as total_amount
from customers c
join orders o on c.customer_id=o.customer_id
group by c.customer_id, c.name order by total_amount desc limit 1;

--9) Calculate the stock remaining after fulfilling all orders:
select * from books;
select * from orders order by quantity desc;
select b.book_id, b.stock, coalesce (sum(o.quantity),0) as total_orders, b.stock-coalesce (sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id=o.book_id
group by b.book_id order by remaining_quantity asc;