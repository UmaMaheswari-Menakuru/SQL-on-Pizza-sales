## CREATING DATABASE
create database pizza_orders;
use pizza_orders;

## IMPORTING TABLES 
select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;

## BASIC QUERIES
# 1----> Retrieve the total number of orders placed.
select count(order_id) as no_of_orders from orders; 

# 2---->Calculate the total revenue generated from pizza sales.
select sum(p.price * o.quantity) as total_revenue 
from pizzas as p
join order_details as o
on p.pizza_id=o.pizza_id;

# 3----> Identify the highest-priced pizza.
select max(price) from pizzas;
select p.size,max(p.price) as max_price from pizzas as p
join pizza_types as p1
on p.pizza_type_id=p1.pizza_type_id
group by p.size
order by p.size desc
limit 1;

# 4----> Identify the most common pizza size ordered.
select p.size,count(p.size) as no_of_pizzas
from pizzas as p
join pizza_types as p1
on p.pizza_type_id=p1.pizza_type_id
group by p.size
order by p.size;

# 5----> List the top 5 most ordered pizza types along with their quantities.
select p1.name,sum(o.quantity) as quantity 
from pizzas as p
join pizza_types as p1
on p.pizza_type_id=p1.pizza_type_id 
join order_details as o
on p.pizza_id=o.pizza_id
group by p1.name,o.quantity
order by quantity desc
limit 5;

## INTERMEDIATE QUERIES
# 1----> Join the necessary tables to find the total quantity of each pizza category ordered.
select p1.category,sum(o.quantity) as total_quantity
from pizzas as p
join pizza_types as p1
on p.pizza_type_id=p1.pizza_type_id
join order_details as o
on p.pizza_id=o.pizza_id
group by p1.category;

# 2----> Determine the distribution of orders by hour of the day.
select hour(time) as no_of_hours,
count(order_id) as no_of_orders
from orders
where hour(time) is not null
group by no_of_hours;

# 3----> Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) as no_of_pizzas from pizza_types
group by category; 
select p1.category,count(p1.name) as no_of_pizzas
from pizzas as p
join pizza_types as p1
on p.pizza_type_id = p1.pizza_type_id
group by p1.category 
order by no_of_pizzas desc;

# 4----> Group the orders by date and calculate the average number of pizzas ordered per day.
select o.date,count(o1.quantity) as no_of_pizzas
from orders as o
join order_details as o1
on o.order_id = o1.order_id 
group by o.date
order by no_of_pizzas desc;
with orders_by_day as 
(
select o.date,count(o1.quantity) as no_of_pizzas
from orders as o
join order_details as o1
on o.order_id = o1.order_id 
group by o.date
order by no_of_pizzas desc
)
select round(avg(no_of_pizzas),0) as total_pizzas from orders_by_day;

# 5----> Determine the top 3 most ordered pizza types based on revenue.
select p1.name,sum(p.price * o.quantity) as total_revenue 
from pizzas as p
join pizza_types as p1
on p.pizza_type_id = p1.pizza_type_id
join order_details as o
on p.pizza_id = o.pizza_id
group by p1.name
order by total_revenue desc
limit 3;

## ADVANCED QUERIES
# 1----> Calculate the percentage contribution of each pizza type to total revenue.
select p1.category,round(sum(p.price * o.quantity) / (select round(sum(p2.price * o2.quantity))
                                              from pizzas as p2
                                              join order_details as o2
										      on p2.pizza_id = o2.pizza_id)*100,2) as total_percentage
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id
join pizza_types as p1
on p.pizza_type_id = p1.pizza_type_id
group by p1.category;

# 2----> Analyze the cumulative revenue generated over time.
with revenue_time as
(
select date(o1.date) as order_date,sum(p.price * o.quantity) as cumm_revenue
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id
join orders as o1
on o.order_id = o1.order_id
group by o1.date
)
select order_date,sum(cumm_revenue) over(order by order_date) as date_revenue from revenue_time
where order_date is not null;

# 3----Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with top_category as 
(
select p1.name,p1.category ,round(sum(p.price * o.quantity),2) as revenue_
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id
join pizza_types as p1
on p.pizza_type_id = p1.pizza_type_id
group by p1.category,p1.name
) 
select category,name,revenue_ 
from  top_category
order by revenue_ desc
limit 3;




















