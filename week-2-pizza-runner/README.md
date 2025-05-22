# Week 2 - Pizza Runner: SQL Challenge

## Description

I completed the week 2 case study from [Danny Ma's 8-Week SQL Challenge](https://8weeksqlchallenge.com/case-study-2/). This case study explores Pizza Runner, a pizza delivery service that relies on runners to deliver fresh pizzas. The challenge involves cleaning and transforming raw data, calculating key metrics, and optimizing pizza delivery operations using SQL.
Focus areas included:
- Runner performance metrics
- Pizza popularity and ingredient optimization
- Customer experience analysis

🔗 [My Full Solution Code](week-2-pizza-runner/solutions-week-2.sql)

## 🔍 Questions Explored
### A. Pizza Metrics
1. How many runners signed up?
2. What was the average delivery time?
3. How many pizzas were delivered with exclusions?

### B. Runner Operations
1. What percentage of orders were successfully delivered?
2. How many orders did each runner complete?
3. What was the average distance traveled?

### C. Ingredient Analysis
1. What were the most common exclusions?
2. How many pizzas had both extras and exclusions?

## 🛠️ Methodology
### Data Cleaning
- Standardized NULL values in `extras` and `exclusions`
- Converted distance values to consistent units
- Handled incorrect timestamps in `runner_orders`

### Analysis Techniques
- Used CTEs to modularize complex queries
- Applied `CASE WHEN` for conditional metrics
- Created temporary tables for cleaned data
- Implemented `STRING_SPLIT` for ingredient analysis

## 📊 Key Insights
- **Runner Efficiency**: Found a 15-minute variance in average delivery times
- **Customer Preferences**: 20% of orders requested at least one modification
- **Operational Bottleneck**: Orders with multiple pizzas took disproportionately longer

## 📸 Screenshots
![Schema Diagram](/path-to-image/schema.png)  
*Database relationship diagram*

![Query Example](/path-to-image/query-sample.png)  
*Sample of analysis query structure*

## 🎓 Learnings
- **SQL Skills**: Advanced JOIN patterns, timestamp manipulation
- **Business Impact**: Identified 3 potential process improvements
- **Data Quality**: Importance of validation constraints

## 🛠️ Tools Used
- PostgreSQL
- VS Code
- Excalidraw (for diagrams)