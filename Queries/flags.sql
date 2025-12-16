/* QUESTION: For each store and week, what is the total revenue and online revenue, 
   and how have their week-over-week trends changed? */

-- STEP 1: CTE to calculate weekly totals per store
-- - Week starts on Monday
-- - Calculate total weekly revenue and total weekly online revenue

WITH weekly_totals AS
(
	SELECT
		store_id,
		CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date) AS week_start_monday,
		SUM(CASE WHEN channel = 'ONLINE' THEN net_revenue END) AS weekly_online_revenue,
		SUM(net_revenue) AS total_weekly_revenue
	FROM dbo.Sales
	GROUP BY
		store_id,
		CAST(DATEADD(WEEK, DATEDIFF(WEEK, 0, DATEADD(DAY, -1, date)), 0) AS date)
),

-- STEP 2: CTE to calculate percentages and week-over-week changes
-- - Compute online share percentage per week
-- - Use LAG to retrieve previous week's total revenue and online percentage
-- - Calculate WoW revenue growth % and WoW online share shift %

weekly_percentage AS
(
	SELECT
		w.store_id,
		w.week_start_monday,
		w.total_weekly_revenue,
		LAG(total_weekly_revenue) OVER (PARTITION BY store_id ORDER BY week_start_monday) AS previous_total_weekly_revenue,
		weekly_online_revenue,
		weekly_online_revenue / total_weekly_revenue * 100 AS online_sales_percentage,
		LAG(weekly_online_revenue / total_weekly_revenue * 100) OVER (PARTITION BY store_id ORDER BY week_start_monday) AS previous_online_sales_percentage,
		COALESCE(ROUND((total_weekly_revenue - LAG(total_weekly_revenue) OVER (PARTITION BY store_id ORDER BY week_start_monday)) / LAG(total_weekly_revenue) OVER (PARTITION BY store_id ORDER BY week_start_monday) * 100,2),0) AS WoW_revenue_growth_percentage,
		COALESCE(ROUND((weekly_online_revenue / total_weekly_revenue * 100) - (LAG(weekly_online_revenue / total_weekly_revenue * 100) OVER (PARTITION BY store_id ORDER BY week_start_monday)),2),0) AS online_share_shift_percent
	FROM weekly_totals AS w
)

-- STEP 3: Final SELECT
-- - Round numeric values for readability
-- - Flag trends as UP, DOWN, or No Change

SELECT
	store_id,
	week_start_monday,
	ROUND(total_weekly_revenue,2) AS total_weekly_revenue,
	CASE
		WHEN WoW_revenue_growth_percentage > 0 THEN 'UP'
		WHEN WoW_revenue_growth_percentage < 0 THEN 'DOWN'
		WHEN WoW_revenue_growth_percentage = 0 THEN 'No Change'
	END AS revenue_trend,
	ROUND(weekly_online_revenue,2) AS weekly_online_revenue,
	CASE
		WHEN online_share_shift_percent > 0 THEN 'UP'
		WHEN online_share_shift_percent < 0 THEN 'DOWN'
		WHEN online_share_shift_percent = 0 THEN 'No Change'
	END AS online_sales_trend
FROM weekly_percentage;
