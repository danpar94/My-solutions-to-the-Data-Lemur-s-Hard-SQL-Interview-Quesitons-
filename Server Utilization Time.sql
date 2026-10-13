/*
Interview question here: https://datalemur.com/questions/total-utilization-time
*/

CREATE TABLE server_utilization (
    server_id INTEGER,
    status_time TIMESTAMP,
    session_status VARCHAR(10)
);

INSERT INTO server_utilization (server_id, status_time, session_status)
VALUES 
    (101, '2025-10-10 08:00:00', 'start'),
    (101, '2025-11-08 08:00:00', 'stop'),
    (102, '2025-12-16 08:00:00', 'start'),
    (102, '2026-01-15 08:00:00', 'stop'),
	(103, '2026-01-15 08:00:00', 'start'),
    (103, '2026-02-12 08:00:00', 'stop');

WITH cte AS(
SELECT *,
LEAD(status_time) OVER(PARTITION BY server_id ORDER BY status_time) AS lead_session_status
FROM server_utilization
), cte2 AS(
SELECT SUM(TIMESTAMPDIFF(HOUR,status_time,lead_session_status)) AS hours_per_server
FROM cte 
WHERE session_status = 'start'
GROUP BY server_id
)
SELECT ROUND(SUM(hours_per_server)/24*1.0) AS tot_uptime
FROM cte2;
