/* QUESTION 2: For each store, what is the total revenue per week?  */

-- STEP 1: Aggregate sales data by store and week
-- - Week starts on Monday
-- - Use DATEADD + DATEDIFF to align all dates to the start of the week (Monday)
-- - SUM(net_revenue) to calculate total weekly revenue per store
-- - ROUND to 2 decimal places for cleaner presentation

SELECT
    store_id,
    CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date) AS week_start_monday,
    ROUND(SUM(net_revenue), 2) AS weekly_revenue
FROM dbo.Sales
GROUP BY
    store_id, 
    CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date)
ORDER BY
    store_id,
    CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date);
