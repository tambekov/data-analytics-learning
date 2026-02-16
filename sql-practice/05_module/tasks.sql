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