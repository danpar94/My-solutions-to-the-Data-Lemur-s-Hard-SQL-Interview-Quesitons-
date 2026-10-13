/*
Interview question here: https://datalemur.com/questions/long-calls-growth
*/

CREATE TABLE callers (
    policy_holder_id INT,
    case_id VARCHAR(36),
    call_category VARCHAR(50),
    call_date TIMESTAMP,
    call_duration_secs INT
);

INSERT INTO callers (policy_holder_id, case_id, call_category, call_date, call_duration_secs) VALUES
(412, '1', 'claims assistance', '2023-01-10 09:15:22', 512),
(412, '2', 'benefits', '2023-01-15 14:22:05', 340),
(412, '6', 'benefits', '2023-01-17 14:20:00', 295),
(881, '3', 'member portal', '2023-02-15 11:05:40', 890),
(503, '4', 'provider network', '2023-03-18 16:45:12', 425),
(119, '5', 'claims assistance', '2023-04-20 08:30:5',302),
(119, '7', 'benefits', '2023-04-26 18:30:00',305);

WITH cte AS(
SELECT EXTRACT(YEAR FROM call_date) AS yr,
EXTRACT(MONTH FROM call_date) AS mth, 
COUNT(*) AS num_of_calls
FROM callers
WHERE call_duration_secs > 300
GROUP BY EXTRACT(YEAR FROM call_date), EXTRACT(MONTH FROM call_date)
), cte2 AS(
SELECT yr,
mth,
num_of_calls,
LAG(num_of_calls) OVER(ORDER BY yr ASC, mth ASC) AS prec_num_of_calls
FROM cte
)
SELECT yr,
mth,
ROUND((-prec_num_of_calls + num_of_calls)/(prec_num_of_calls*1.0)*100,1) long_calls_growth_pct
FROM cte2;