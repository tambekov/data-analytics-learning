-- 3
SELECT
    ev.DeviceID AS device_id,
    ev.AppPlatform AS app_platform,
    ev.EventDate AS event_date,
    ev.events AS events,
    dv.UserID AS user_id
FROM
    events AS ev
LEFT JOIN
    devices AS dv
        ON dv.DeviceID = ev.DeviceID
ORDER BY
    DeviceID DESC;

-- 4
SELECT
    i.Source as source_platform,
    COUNT(*) AS purchases
FROM installs AS i
INNER JOIN
    devices AS d
        ON i.DeviceID = d.DeviceID
INNER JOIN
    checks AS c
        ON c.UserID = d.UserID
GROUP BY
    i.Source
ORDER BY
    purchases DESC;

-- 5
SELECT
    i.Source AS source_platform,
    uniqExact(c.UserID) AS users
FROM
    installs AS i
INNER JOIN
    devices AS d
        ON i.DeviceID = d.DeviceID
INNER JOIN
    checks AS c
        ON d.UserID = c.UserID
GROUP BY i.Source

-- 6
SELECT
    i.Source AS source,
    SUM(c.Rub) AS total,
    MAX(c.Rub) AS max_order,
    AVG(c.Rub) AS avg_order,
    MIN(c.Rub) AS min_order
FROM
    installs AS i
INNER JOIN
    devices AS d
        ON i.DeviceID = d.DeviceID
INNER JOIN
    checks AS c
        ON c.UserID = d.UserID
GROUP BY
    i.Source;

-- 7
SELECT
    *
FROM
    devices AS d
JOIN
    checks AS c
        ON d.UserID = c.UserID
WHERE
    toStartOfMonth(CAST(c.BuyDate AS Date)) = Date '2024-03-01'
LIMIT 1

-- 8
SELECT
    i.Source AS source_,
    i.Platform AS platform_,
    AVG(events) AS avg_events
FROM
    installs AS i
INNER JOIN
    events AS e
        ON i.DeviceID = e.DeviceID
GROUP BY
    i.Source,
    i.Platform
ORDER BY
    avg_events DESC;

-- 9
SELECT
    i.Platform AS platform_,
    uniqExact(i.DeviceID) as unique_device_ids
FROM
    installs AS i
LEFT SEMI JOIN
    events AS e
        ON i.DeviceID = e.DeviceID
GROUP BY
    i.Platform

-- 10
SELECT
   uniqExact(e.DeviceID) / uniqExact(i.DeviceID)
FROM
    installs AS i
LEFT JOIN
    events AS e
        ON i.DeviceID = e.DeviceID


-- 11
SELECT
    e.DeviceID
FROM
    events AS e
LEFT ANTI JOIN
    devices AS d
        ON d.DeviceID = e.DeviceID
ORDER BY
    e.DeviceID DESC
LIMIT 10;