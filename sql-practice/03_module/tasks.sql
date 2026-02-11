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