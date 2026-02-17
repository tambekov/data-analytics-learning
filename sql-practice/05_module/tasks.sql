-- 1
SELECT *
FROM
	listings
WHERE
	reviews_per_month < 150 AND
	review_scores_rating > (
		SELECT
			AVG(review_scores_rating)
		FROM
			listings
	)
ORDER BY
    reviews_per_month DESC,
    review_scores_rating DESC
LIMIT 1

-- 2
SELECT
	l.id,
	l.host_id,
	l.room_type,
	l.latitude,
	l.longitude,
	geoDistance(13.4050, 52.5200, l.latitude, l.longitude) AS distance
FROM	
	listings AS l
WHERE
	distance <
	(
        SELECT
            AVG(geoDistance(13.4050, 52.5200, l.latitude, l.longitude))
        FROM
            listings AS l
        WHERE room_type = 'Private room'
	)
ORDER BY
	distance DESC

-- 3
SELECT
	l.id,
	l.host_id,
	geoDistance(1.12, 43.43, l.latitude, l.longitude) AS distance_,
	toFloat32OrNull(replaceRegexpAll(l.price, '[$,]', '')) + toFloat32OrNull(replaceRegexpAll(l.cleaning_fee, '[$,]', '')) / 7 AS price_,
	amenities,
	l.last_review
FROM
	listings AS l
WHERE
	price_ > 150 AND
	distance_ < (
		SELECT
			AVG(geoDistance(1.12, 43.43, l.latitude, l.longitude))
		FROM listings AS l
	) AND
	multiSearchAnyCaseInsensitive(l.amenities, ['WiFi']) AND
	toDateOrNull(l.last_review) > DATE '2023-01-12'
ORDER BY
	price_ DESC

-- 4
WITH (
SELECT
	AVG(reviewers)
FROM (
	SELECT
		r.listing_id,
		uniqExact(r.reviewer_id) AS reviewers
	FROM
		`default`.reviews AS r
	INNER JOIN
		`default`.calendar_summary cs
			ON cs.listing_id  = r.listing_id 
	WHERE
		cs.available = 't'
	GROUP BY
		r.listing_id
)) AS avg_reviewers
SELECT
	uniqExact(r.reviewer_id) AS reviewers
FROM
	`default`.reviews AS r
INNER JOIN
	`default`.calendar_summary cs
		ON cs.listing_id = r.listing_id
WHERE
	cs.available = 't'
GROUP BY
	r.listing_id
HAVING
	reviewers > avg_reviewers

-- 5
SELECT
	CASE
		WHEN avg_rub < 5 THEN 'A'
		WHEN avg_rub < 10 THEN 'B'
		WHEN avg_rub < 20 THEN 'C'
		ELSE 'D'
	END AS segment_name,
	UserID
FROM
(
	SELECT
		c.UserID,
		AVG(c.Rub) AS avg_rub
	FROM
		`default`.checks AS c
	GROUP BY
		c.UserID
)
ORDER BY UserID

-- 6
SELECT
	segment_name,
	SUM(total) AS total
FROM
(
	SELECT
		CASE
			WHEN avg_rub < 5 THEN 'A'
			WHEN avg_rub < 10 THEN 'B'
			WHEN avg_rub < 20 THEN 'C'
			ELSE 'D'
		END AS segment_name,
		UserID,
		total
	FROM
	(
		SELECT
			c.UserID,
			AVG(c.Rub) AS avg_rub,
			SUM(c.Rub) AS total
		FROM
			`default`.checks AS c
		GROUP BY
			c.UserID	
	)
)
GROUP BY
	segment_name
ORDER BY
	total DESC

-- PART 2

-- 1
CREATE TABLE test.reviews(
	listing_id UInt32,
	id UInt32,
	date Datetime('Europe/Moscow'),
	reviewer_id UInt32,
	reviewer_name String,
	comments String
) ENGINE = MergeTree
ORDER BY (listing_id, id)

-- 2
ALTER TABLE test.reviews
MODIFY COLUMN date Date

-- 3
ALTER TABLE test_reviews
DELETE WHERE comments = '';

-- 4
ALTER TABLE test.reviews
ADD COLUMN price Float32 AFTER comments

-- 5
ALTER TABLE test.reviews
UPDATE price = price * 2
WHERE date > '2019-01-01'