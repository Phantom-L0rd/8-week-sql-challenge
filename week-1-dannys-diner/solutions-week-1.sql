-- Active: 1747829711247@@localhost@3306@dannys_diner
select * 
from sales;
select *
from members;
SELECT *
FROM menu;

-- What is the total amount each customer spent at the restaurant?
select s.customer_id, sum(m.price) as total_amount
from sales s
join menu m on s.product_id = m.product_id
group by customer_id;

-- How many days has each customer visited the restaurant?
select customer_id, count(distinct order_date) as days
from sales
group by customer_id;

-- What was the first item from the menu purchased by each customer?
with rank_cte as (select *, row_number() over(partition by customer_id order by order_date) as rnk
from sales)
select customer_id, product_name
from rank_cte s
join menu m on s.product_id = m.product_id
where rnk = 1;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
select s.product_id, count(*) as orders, rank() over(order by count(*) desc) ranking
from sales s
join menu m on s.product_id = m.product_id
group by s.product_id
limit 1;

-- Which item was the most popular for each customer?
with rank_cte as (select customer_id, product_id, count(*), rank() over(partition by customer_id order by count(*)) as rnk
from sales group by customer_id, product_id)
select *
from rank_cte ;

-- Which item was purchased first by the customer after they became a member?
with rank_cte as (select s.customer_id, product_id, datediff(order_date,join_date) as diff, 
rank() over(partition by s.customer_id order by datediff(order_date,join_date)) as rnk
from sales s join members m 
	on s.customer_id = m.customer_id
having diff >= 0)
select customer_id, product_name
from rank_cte a
join menu b	 on a.product_id = b.product_id
where rnk = 1;


-- Which item was purchased just before the customer became a member?
with rank_cte as (select s.customer_id, product_id, datediff(order_date,join_date) as diff, 
rank() over(partition by s.customer_id order by datediff(order_date,join_date) desc) as rnk
from sales s join members m 
	on s.customer_id = m.customer_id
having diff < 0)
select customer_id, product_name
from rank_cte a
join menu b	 on a.product_id = b.product_id
where rnk = 1;

-- What is the total items and amount spent for each member before they became a member?
with before_member as (select s.customer_id,s.product_id,price, datediff(order_date,join_date) as diff
from sales s join members m 
	on s.customer_id = m.customer_id
join menu n on s.product_id = n.product_id
having  diff < 0)
select customer_id, count(product_id) total_items,sum(price) as Total_amount
from before_member
group by customer_id;

-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
with items as (select s.customer_id,s.product_id,product_name,price, datediff(order_date,join_date) as diff
from sales s join members m 
	on s.customer_id = m.customer_id
join menu n on s.product_id = n.product_id
having  diff >= 0)
select customer_id, round(sum(IF(product_id = 1,2*10.0*price/1.0,10.0*price/1.0)),2) as points
from items
group by customer_id;

-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
with items as (select s.customer_id,order_date,s.product_id,product_name,price,join_date + interval 7 day, datediff(order_date,join_date) as diff
from sales s join members m 
	on s.customer_id = m.customer_id
join menu n on s.product_id = n.product_id
having  diff >= 0)
select customer_id, round(sum(IF(diff <7,2*10.0*price/1.0, IF(product_id = 1,2*10.0*price/1.0,10.0*price/1.0))),2) as points
from items
where order_date < '2021-02-01'
group by customer_id;


-- Joining everything together
SELECT s.customer_id,order_date,product_name, price, 
CASE 
	WHEN join_date IS NULL THEN "N"
	ELSE  IF(order_date>=join_date,"Y","N")
END as `member`
FROM sales s
LEFT JOIN menu m 
	ON s.product_id = m.product_id
LEFT JOIN members n
	ON s.customer_id = n.customer_id;