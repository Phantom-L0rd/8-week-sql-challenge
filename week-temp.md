# Week X – Case Study Name

## Description

Brief summary of the case study's goal and domain (e.g. food, finance, marketing).  
This week's challenge involved analyzing [describe the company or system] using SQL.

[Case Study Link](https://8weeksqlchallenge.com/case-study-X/) | [My Solution Code](./solutions-week-X.sql)

## Tables Overview

- `table_1`: short description  
- `table_2`: short description  
- `table_3`: short description

![Diagram](dannys-diagram.png)
*Relationship Diagram*


## Questions

## Key Concepts Used

- JOINs (`INNER`, `LEFT`, etc.)
- Aggregation (`COUNT`, `SUM`, `GROUP BY`)
- Window Functions (`ROW_NUMBER`, `RANK`)
- CTEs (Common Table Expressions)
- Date Filtering & Case Logic


## Example Query

```sql
-- Sample query using window functions
WITH ranked_orders AS (
  SELECT customer_id, product_id, order_date,
         ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date) AS rn
  FROM sales
)
SELECT customer_id, product_id
FROM ranked_orders
WHERE rn = 1;
```

> Sample output: ![Screenshot](q3-output.png)

---

## Insights

* Customer A prefers sushi and visits most frequently
* Loyalty program increased spending frequency post-join
* Product X was the most purchased item overall


