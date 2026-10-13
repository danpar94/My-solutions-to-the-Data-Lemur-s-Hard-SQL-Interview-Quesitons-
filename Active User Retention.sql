-- Interview question here: https://datalemur.com/questions/user-retention

CREATE TABLE IF NOT EXISTS user_actions ( 
	user_id INT NOT NULL,
	event_id INT NOT NULL,
	event_type TEXT NOT NULL,
	event_date DATETIME 
); 

INSERT INTO user_actions (user_id, event_id, event_type, event_date) VALUES
(101, 501, 'sign-in', '2022-07-01 08:30:00'),
(102, 502, 'like', '2022-07-01 09:15:22'),
(101, 503, 'comment', '2022-07-01 10:05:40'),
(103, 504, 'sign-in', '2022-08-02 11:20:11'),
(104, 505, 'like', '2022-06-02 12:45:00'),
(102, 506, 'comment', '2022-06-03 14:10:55'),
(105, 507, 'sign-in', '2022-07-03 16:00:30');


WITH cte AS(
SELECT user_id, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY event_date ASC) AS row_num,
event_date
FROM user_actions
WHERE EXTRACT(YEAR FROM event_date) = 2022
AND EXTRACT(MONTH FROM event_date) IN (6,7)
AND event_type IS NOT NULL
),
cte2 AS (
SELECT c1.user_id, event_date
FROM cte c1
WHERE c1.row_num IN (SELECT MAX(c2.row_num) FROM cte c2 WHERE c2.user_id = c1.user_id)
OR  c1.row_num IN (SELECT MIN(c2.row_num) FROM cte c2 WHERE c2.user_id = c1.user_id)
), cte3 AS(
SELECT 7 AS month, user_id
FROM cte2
GROUP BY user_id
HAVING SUM(EXTRACT(MONTH FROM event_date)) = 13)
SELECT month, COUNT(user_id) AS num_users_july
FROM cte3
GROUP BY(month)
;