# Week 1 - Danny's Diner: SQL Challenge

This week, I tackled the Week 1 case study from [Danny Ma's 8-Week SQL Challenge](https://8weeksqlchallenge.com/case-study-1/). The dataset models a Japanese restaurant's sales, menu items, and customer memberships. Using SQL, I answered various business questions to uncover customer behavior and trends.

---

## Case Study Tables

- `sales`: Customer purchases with `order_date` and `product_id`
- `menu`: Product details with `product_id`, `product_name`, and `price`
- `members`: Membership info with `customer_id` and `join_date`

---

## Business Questions & SQL Solutions

> **1. What is the total amount each customer spent at the restaurant?**

```sql
SELECT s.customer_id, SUM(m.price) AS total_amount
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY customer_id;
```

> **2. How many days has each customer visited the restaurant?**

```sql
SELECT customer_id, COUNT(DISTINCT order_date) AS days
FROM sales
GROUP BY customer_id;
```

> **3. What was the first item from the menu purchased by each customer?**

```sql
WITH rank_cte AS (
  SELECT *, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS rnk
  FROM sales
)
SELECT customer_id, product_name
FROM rank_cte s
JOIN menu m ON s.product_id = m.product_id
WHERE rnk = 1;
```

> **4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

```sql
SELECT s.product_id, COUNT(*) AS orders, RANK() OVER(ORDER BY COUNT(*) DESC) AS ranking
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.product_id
LIMIT 1;
```

> **5. Which item was the most popular for each customer?**

```sql
WITH rank_cte AS (
  SELECT customer_id, product_id, COUNT(*) AS count,
         RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS rnk
  FROM sales
  GROUP BY customer_id, product_id
)
SELECT *
FROM rank_cte
WHERE rnk = 1;
```

> **6. Which item was purchased first by the customer after they became a member?**

```sql
WITH rank_cte AS (
  SELECT s.customer_id, product_id, DATEDIFF(order_date, join_date) AS diff,
         RANK() OVER(PARTITION BY s.customer_id ORDER BY DATEDIFF(order_date, join_date)) AS rnk
  FROM sales s
  JOIN members m ON s.customer_id = m.customer_id
  HAVING diff >= 0
)
SELECT customer_id, product_name
FROM rank_cte a
JOIN menu b ON a.product_id = b.product_id
WHERE rnk = 1;
```

> **7. Which item was purchased just before the customer became a member?**

```sql
WITH rank_cte AS (
  SELECT s.customer_id, product_id, DATEDIFF(order_date, join_date) AS diff,
         RANK() OVER(PARTITION BY s.customer_id ORDER BY DATEDIFF(order_date, join_date) DESC) AS rnk
  FROM sales s
  JOIN members m ON s.customer_id = m.customer_id
  HAVING diff < 0
)
SELECT customer_id, product_name
FROM rank_cte a
JOIN menu b ON a.product_id = b.product_id
WHERE rnk = 1;
```

> **8. What is the total items and amount spent for each member before they became a member?**

```sql
WITH before_member AS (
  SELECT s.customer_id, s.product_id, price, DATEDIFF(order_date, join_date) AS diff
  FROM sales s
  JOIN members m ON s.customer_id = m.customer_id
  JOIN menu n ON s.product_id = n.product_id
  HAVING diff < 0
)
SELECT customer_id, COUNT(product_id) AS total_items, SUM(price) AS total_amount
FROM before_member
GROUP BY customer_id;
```

> **9. If each \$1 spent equates to 10 points and sushi has a 2x multiplier – how many points would each customer have?**

```sql
WITH items AS (
  SELECT s.customer_id, s.product_id, product_name, price, DATEDIFF(order_date, join_date) AS diff
  FROM sales s
  JOIN members m ON s.customer_id = m.customer_id
  JOIN menu n ON s.product_id = n.product_id
  HAVING diff >= 0
)
SELECT customer_id,
       ROUND(SUM(IF(product_id = 1, 2 * 10.0 * price, 10.0 * price)), 2) AS points
FROM items
GROUP BY customer_id;
```

> **10. In the first week after joining (incl. join date), members earn 2x points on all items – how many points do A and B have by end of Jan?**

```sql
WITH items AS (
  SELECT s.customer_id, order_date, s.product_id, product_name, price,
         join_date + INTERVAL 7 DAY AS bonus_end,
         DATEDIFF(order_date, join_date) AS diff
  FROM sales s
  JOIN members m ON s.customer_id = m.customer_id
  JOIN menu n ON s.product_id = n.product_id
  HAVING diff >= 0
)
SELECT customer_id,
       ROUND(SUM(
         IF(diff < 7, 2 * 10.0 * price,
         IF(product_id = 1, 2 * 10.0 * price, 10.0 * price))
       ), 2) AS points
FROM items
WHERE order_date < '2021-02-01'
GROUP BY customer_id;
```

---

## 🖼️ Query Output Screenshots

> *📎 Add screenshots of your query results here (if applicable)*

---

## 🔍 Key Insights

* **Customer A** spent the most and visited frequently in early January.
* **Ramen** was the most purchased item overall.
* **Membership** boosted engagement—many purchases happened shortly after joining.
* **Sushi's 2x bonus** makes it an attractive upsell item.

---

## 🧠 What I Learned

* Practice using **window functions** like `RANK()` and `ROW_NUMBER()`.
* How to use **`WITH` CTEs** to organize complex subqueries.
* Real-world application of **`DATEDIFF`** and conditional logic with `IF(...)`.
* How SQL can drive **customer behavior analysis** and loyalty tracking.
