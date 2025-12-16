/* QUESTION 3: For each store and week, what is the total revenue, and how does 
it compare to the previous week in terms of percentage growth? */

-- STEP 1: CTE: Aggregate raw sales data into weekly totals per store
-- - Week starts on Monday
-- - Sum net revenue to get weekly total revenue per store

WITH weekly_totals AS
(
    SELECT
        store_id,
        CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date) AS week_start_monday,
        SUM(net_revenue) AS weekly_revenue
    FROM dbo.Sales
    GROUP BY
        store_id, 
        CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date)
)

-- STEP 2: OUTER QUERY: Calculate week-over-week revenue growth
-- - Use LAG window function to retrieve previous week's revenue per store
-- - Compute the percentage growth compared to the previous week
-- - Handle NULLs (first week) with COALESCE

SELECT
    w.store_id,
    w.week_start_monday,
    w.weekly_revenue,
    COALESCE(w.previous_revenue,0) as previous_revenue,
    COALESCE(
        ROUND((w.weekly_revenue - w.previous_revenue) * 100 / w.previous_revenue, 2),
        0
    ) AS WoW_growth_percentage
FROM
    -- STEP 2a: DERIVED TABLE: Window function layer
    -- - Calculate previous week's revenue using LAG
    (SELECT
        store_id,
        week_start_monday,
        weekly_revenue,
        LAG(weekly_revenue) OVER (PARTITION BY store_id ORDER BY week_start_monday) AS previous_revenue
     FROM weekly_totals
    ) AS w;


