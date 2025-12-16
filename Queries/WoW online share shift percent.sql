/*QUESTION 4: For each store and week, how much of the total revenue comes from online sales, 
and how has the online revenue share changed compared to the previous week?*/

-- STEP 1: CTE: Aggregate raw sales data into weekly totals per store
-- - Week starts on Monday
-- - Calculate total weekly revenue
-- - Calculate total weekly ONLINE revenue

WITH weekly_totals AS
	(SELECT
		store_id,
		CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date) AS week_start_monday,
		SUM(CASE 
			WHEN channel = 'ONLINE' THEN net_revenue END) AS weekly_online_revenue,
		SUM(net_revenue) AS total_weekly_revenue
	FROM dbo.Sales
	GROUP BY
		store_id,
		CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date))

-- STEP 2: OUTER QUERY: Calculate weekly online revenue percentage
-- - Compute ONLINE share of total revenue
-- - Use LAG to retrieve previous week's online percentage per store

SELECT
	w.store_id,
	w.week_start_monday,
	ROUND(w.weekly_online_revenue,2) AS weekly_online_revenue,
	ROUND(w.total_weekly_revenue,2) AS total_weekly_revenue,
	ROUND(w.online_sales_percentage,2) AS online_sales_percentage,
	COALESCE(ROUND(w.previous_online_sales_percentage,2),0) AS previous_online_sales_percentage,
	COALESCE(ROUND(w.online_sales_percentage - w.previous_online_sales_percentage,2),0) as online_share_shift_percent
FROM
	-- STEP 2a: DERIVED TABLE: Window function layer
    -- - Calculate current week's online percentage
    -- - Pull previous week's online percentage using LAG
	(SELECT
		store_id,
		week_start_monday,
		weekly_online_revenue,
		total_weekly_revenue,
		weekly_online_revenue / total_weekly_revenue * 100 AS online_sales_percentage,
		LAG(weekly_online_revenue / total_weekly_revenue * 100) OVER
			(PARTITION BY store_id ORDER BY week_start_monday) as previous_online_sales_percentage
	FROM weekly_totals) AS w;