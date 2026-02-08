-- 3
SELECT
	user_id,
	uniqExact(buy_date) AS num_checks
FROM checks
GROUP BY user_id
ORDER BY num_checks DESC
LIMIT 10;

-- 4
SELECT
	user_id,
	SUM(rub) AS revenue,
	uniqExact(buy_date) AS num_checks
FROM checks
GROUP BY user_id
ORDER BY num_checks DESC
LIMIT 10;

-- 5
SELECT
	buy_date,
	MIN(rub) AS min_check,
	MAX(rub) AS max_check,
	AVG(rub) AS avg_check
FROM checks
GROUP BY buy_date
ORDER BY buy_date DESC
LIMIT 10;

-- 6
SELECT
	user_id,
	SUM(rub) AS revenue
FROM checks
GROUP BY user_id
HAVING revenue > 10_000
ORDER BY user_id DESC
LIMIT 10;

-- 7
SELECT
	country,	
	SUM(quantity * unit_price) AS revenue
FROM retail
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

-- 8
SELECT
	country,
	AVG(quantity) AS avg_quantity,
	AVG(unit_price) AS avg_unit_price
FROM retail
WHERE description != 'Manual'
GROUP BY country
ORDER BY avg_quantity DESC;

-- 9
SELECT 
	toStartOfMonth(invoice_date) AS date,
	SUM(quantity * unit_price) AS revenue
FROM retail
WHERE description != 'Manual'
GROUP BY date
ORDER BY revenue DESC
LIMIT 5;

-- 10
SELECT
	customer_id,
	AVG(unit_price) AS avg_unit_price
FROM default.retail
WHERE
	invoice_date = '2025-03-01' AND
	description != 'Manual'
GROUP BY customer_id
ORDER BY avg_unit_price DESC
LIMIT 10;

-- 11
SELECT
	invoice_date,
	MIN(quantity) AS min_q,
	MAX(quantity) AS max_q,
	AVG(quantity) AS avg_q
FROM default.retail
WHERE
	description != 'Manual' AND
	country = 'United Kingdom' AND
	quantity >= 0
GROUP BY
	invoice_date
ORDER BY
	invoice_date
