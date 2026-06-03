-- ================================================
-- PROJECT: Superstore Sales Performance Analysis
-- DATABASE: superstore_db
-- AUTHOR: Misba Khatoon
-- DATE: May 2026
-- ================================================


-- ================================================
-- PHASE 1: DATA QUALITY CHECKS
-- ================================================

-- 1.1 Total Row Count
SELECT COUNT(*) AS total_rows FROM superstore;


-- 1.2 Null Value Check
SELECT 
    COUNT(*) - COUNT(row_id) AS null_row_id,
    COUNT(*) - COUNT(order_id) AS null_order_id,
    COUNT(*) - COUNT(order_date) AS null_order_date,
    COUNT(*) - COUNT(ship_date) AS null_ship_date,
    COUNT(*) - COUNT(ship_mode) AS null_ship_mode,
    COUNT(*) - COUNT(customer_id) AS null_customer_id,
    COUNT(*) - COUNT(customer_name) AS null_customer_name,
    COUNT(*) - COUNT(segment) AS null_segment,
    COUNT(*) - COUNT(city) AS null_city,
    COUNT(*) - COUNT(state) AS null_state,
    COUNT(*) - COUNT(region) AS null_region,
    COUNT(*) - COUNT(product_id) AS null_product_id,
    COUNT(*) - COUNT(category) AS null_category,
    COUNT(*) - COUNT(sub_category) AS null_sub_category,
    COUNT(*) - COUNT(sales) AS null_sales,
    COUNT(*) - COUNT(quantity) AS null_quantity,
    COUNT(*) - COUNT(discount) AS null_discount,
    COUNT(*) - COUNT(profit) AS null_profit
FROM superstore;


-- 1.3 Duplicate Row Check
SELECT 
    order_id, product_id, customer_id,
    COUNT(*) AS duplicate_count
FROM superstore
GROUP BY order_id, product_id, customer_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 10;


-- 1.4 True Duplicate Count
SELECT COUNT(*) as true_duplicates
FROM superstore s1
WHERE EXISTS (
    SELECT 1 FROM superstore s2
    WHERE s1.order_id = s2.order_id
    AND s1.product_id = s2.product_id
    AND s1.customer_id = s2.customer_id
    AND s1.sales = s2.sales
    AND s1.quantity = s2.quantity
    AND s1.profit = s2.profit
    AND s1.row_id > s2.row_id
);


-- 1.5 Remove True Duplicates
DELETE FROM superstore
WHERE row_id IN (
    SELECT s1.row_id
    FROM superstore s1
    WHERE EXISTS (
        SELECT 1 FROM superstore s2
        WHERE s1.order_id = s2.order_id
        AND s1.product_id = s2.product_id
        AND s1.customer_id = s2.customer_id
        AND s1.sales = s2.sales
        AND s1.quantity = s2.quantity
        AND s1.profit = s2.profit
        AND s1.row_id > s2.row_id
    )
);


-- 1.6 Invalid Sales Check
SELECT COUNT(*) AS invalid_sales
FROM superstore
WHERE sales <= 0;


-- 1.7 Invalid Date Check
SELECT COUNT(*) AS invalid_dates
FROM superstore
WHERE ship_date < order_date;


-- 1.8 Statistical Summary
SELECT
    ROUND(MIN(sales),2) AS min_sales,
    ROUND(MAX(sales),2) AS max_sales,
    ROUND(AVG(sales),2) AS avg_sales,
    ROUND(MIN(profit),2) AS min_profit,
    ROUND(MAX(profit),2) AS max_profit,
    ROUND(AVG(profit),2) AS avg_profit,
    ROUND(MIN(discount),2) AS min_discount,
    ROUND(MAX(discount),2) AS max_discount,
    ROUND(AVG(discount),2) AS avg_discount
FROM superstore;

-- ================================================
-- PHASE 2: BUSINESS ANALYSIS QUERIES
-- ================================================

------------------------------------------
-- SECTION 2.1 — Revenue & Profit Overview
------------------------------------------

-- 2.1.1 Overall Business Performance Summary
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore;


-- 2.1.2 Yearly Performance Trend
SELECT
    EXTRACT(YEAR FROM order_date) AS year,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY year;



-- 2.1.3 Monthly Sales Trend
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    ROUND(SUM(sales), 2) AS monthly_revenue,
    ROUND(SUM(profit), 2) AS monthly_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

----------------------------------------------
 -- SECTION 2.2 — Regional Performance
-----------------------------------------------

-- 2.2.1 Sales and Profit by Region
SELECT
    region,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY total_revenue DESC;


-- 2.2.2 Top 5 States by Revenue
SELECT
    state,
    region,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY state, region
ORDER BY total_revenue DESC
LIMIT 5;

-- 2.2.3 Bottom 5 States by Profit (Loss Making States)
SELECT
    state,
    region,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY state, region
ORDER BY total_profit ASC
LIMIT 5;

-------------------------------------
-- SECTION 2.3 — Product Performance
-------------------------------------

-- 2.3.1 Performance by Product Category
SELECT
    category,
    COUNT(DISTINCT product_id) AS total_products,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category
ORDER BY total_revenue DESC;


-- 2.3.2 Performance by Sub Category
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category, sub_category
ORDER BY total_profit DESC;

-- 2.3.3 Loss Making Sub-Categories (Critical Business Insight)
SELECT
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- 2.3.4 Top 10 Most Profitable Products
SELECT
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(quantity) AS units_sold
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_profit DESC
LIMIT 10;

------------------------------------
-- SECTION 2.4 — Customer Analysis
------------------------------------

-- 2.4.1 Performance by Customer Segment
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(sales)/COUNT(DISTINCT customer_id), 2) AS avg_revenue_per_customer
FROM superstore
GROUP BY segment
ORDER BY total_revenue DESC;

-- 2.4.2 Top 10 Most Valuable Customers
SELECT
    customer_name,
    segment,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY customer_name, segment
ORDER BY total_revenue DESC
LIMIT 10;


-----------------------------------------
-- SECTION 2.5 — Discount Impact Analysis
------------------------------------------

-- 2.5.1 Discount Impact on Profitability
SELECT
    CASE
        WHEN discount = 0 THEN '0% - No Discount'
        WHEN discount <= 0.10 THEN '1-10% Discount'
        WHEN discount <= 0.20 THEN '11-20% Discount'
        WHEN discount <= 0.30 THEN '21-30% Discount'
        WHEN discount <= 0.50 THEN '31-50% Discount'
        ELSE 'Above 50% Discount'
    END AS discount_range,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY discount_range
ORDER BY avg_profit DESC;

-- 2.5.2 Shipping Mode Performance
SELECT
    ship_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(ship_date - order_date), 1) AS avg_shipping_days,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY ship_mode
ORDER BY total_orders DESC;
