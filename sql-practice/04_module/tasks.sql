-- 1
SELECT
	toStartOfMonth(l.host_since) AS month,
	uniqExact(l.host_id) AS hosts
FROM
	listings AS l
GROUP BY
	l.host_since
ORDER BY
	hosts DESC

-- 2
SELECT
	l.host_is_superhost AS is_superhost,
	AVG(l.host_response_rate_)
FROM
(
	SELECT
		DISTINCT sub_l.host_id,
		sub_l.host_is_superhost,
		toInt32OrNull(replaceAll(sub_l.host_response_rate, '%', '')) AS host_response_rate_
	FROM listings AS sub_l
) AS l
GROUP BY
	l.host_is_superhost ;

-- 3
SELECT
	l.host_id,
	AVG(toFloat32OrNull(replaceRegexpAll(l.price, '[$,]', ''))) AS avg_price,
	groupArray(l.id) AS ids
FROM
	listings AS l
GROUP BY
	l.host_id
ORDER BY
	avg_price DESC,
	host_id DESC

-- 4
SELECT
	MAX(toFloat32OrNull(replaceRegexpAll(l.price, '[$,]', ''))) AS max_price, 
	MIN(toFloat32OrNull(replaceRegexpAll(l.price, '[$,]', ''))) AS min_price,
	max_price - min_price AS diff_between_min_max
FROM	
	listings AS l
GROUP BY
	l.host_id
ORDER BY
	diff_between_min_max DESC;

-- 5
SELECT
	l.room_type AS room_type_,
	AVG(toFloat64OrNull(replaceRegexpAll(l.price, '[$,]', ''))) AS avg_price,
	AVG(toFloat64OrNull(replaceRegexpAll(l.security_deposit, '[$,]', ''))) AS avg_sec_deposit,
	AVG(toFloat64OrNull(replaceRegexpAll(l.cleaning_fee, '[$,]', ''))) AS avg_cleaning_fee
FROM
	listings AS l
GROUP BY
	l.room_type
ORDER BY
	avg_sec_deposit DESC

-- 6
SELECT
	l.neighbourhood_cleansed,
	AVG(toFloat32OrNull(replaceRegexpAll(l.price, '[$,]', ''))) AS avg_price
FROM
	listings AS l
GROUP BY
	l.neighbourhood_cleansed
ORDER BY
	avg_price

-- 7
SELECT
	l.neighbourhood_cleansed,
	AVG(toFloat32OrNull(l.square_feet)) AS avg_square_feet
FROM
	listings l 
WHERE
	l.room_type = 'Entire home/apt'
GROUP BY
	l.neighbourhood_cleansed
ORDER BY
	avg_square_feet DESC;

-- 8
SELECT
	l.id,
	l.room_type,
	l.latitude,
	l.longitude,
	geoDistance(13.4050, 52.5200, l.latitude, l.longitude) distance_to_berlin
FROM
	listings AS l
WHERE
	l.room_type = 'Private room'
ORDER BY 
	distance_to_berlin
LIMIT 5;
