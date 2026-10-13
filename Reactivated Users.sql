/*
Interview question here: https://datalemur.com/questions/reactivated-users
*/

CREATE TABLE user_logins (
    user_id INT,
    login_date DATETIME
);

INSERT INTO user_logins (user_id, login_date) VALUES
(1, '2026-10-01 08:30:00'),
(2, '2026-11-02 09:15:00'),
(1, '2026-11-03 14:20:00'),
(3, '2026-10-04 18:45:00'),
(2, '2026-08-02 08:15:00'),
(2, '2026-09-05 07:10:00');


WITH cte AS(
SELECT user_id, 
EXTRACT(MONTH FROM login_date) AS mth
FROM user_logins
GROUP BY user_id, EXTRACT(MONTH FROM login_date)
),
cte2 AS (SELECT *,
LAG(mth) OVER(PARTITION BY user_id ORDER BY mth) AS pre_month
FROM cte
)
SELECT mth, 
SUM(CASE WHEN
    (mth != pre_month + 1 
    OR pre_month IS NULL) 
    AND mth != 1
    THEN 1 ELSE 0 END) AS react_users
FROM cte2
GROUP BY mth
ORDER BY mth
;  
