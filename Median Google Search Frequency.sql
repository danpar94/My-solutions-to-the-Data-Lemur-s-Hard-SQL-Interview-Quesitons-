/* 
Interview question here: https://datalemur.com/questions/median-search-freq
*/

CREATE TABLE search_frequency (
    searches INT,
    num_users INT
);


INSERT INTO search_frequency (searches, num_users) VALUES
(1, 4),
(2, 1),
(3, 2),
(4, 2),
(5,2),
(6,5),
(7,4);

WITH cte AS(
SELECT *,
SUM(num_users) OVER(ORDER BY searches ASC) roll_sum_users
FROM search_frequency
),
cte2 AS(
SELECT 1 AS col1, MIN(searches) AS s1
FROM cte
WHERE roll_sum_users >= FLOOR((SELECT MAX(roll_sum_users) FROM cte)/2)
),
cte3 AS(
SELECT 1 AS col1, MIN(searches) AS s1
FROM cte
WHERE roll_sum_users >= FLOOR((SELECT MAX(roll_sum_users) FROM cte)/2) + 1
)
SELECT CASE
WHEN MOD((SELECT MAX(roll_sum_users) FROM cte),2) = 0 THEN ROUND((cte2.s1 + cte3.s1)/2*1.0,1)
ELSE (SELECT MIN(searches) FROM cte WHERE roll_sum_users >= FLOOR((SELECT MAX(roll_sum_users) FROM cte)/2)+1)
END  AS median
FROM cte2
JOIN cte3
  ON cte2.col1 = cte3.col1
; 