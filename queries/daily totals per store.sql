/* QUESTION 1: For each store, what is the total revenue per day? */

-- STEP 1: Aggregate sales data by store and date
-- - SUM(net_revenue) calculates total revenue per store per day
-- - ROUND to 2 decimal places for cleaner presentation

SELECT
    date,
    store_id,
    ROUND(SUM(net_revenue), 2) AS daily_total_revenue
FROM dbo.Sales
GROUP BY 
    date,
    store_id
ORDER BY 
    store_id,
    date;
