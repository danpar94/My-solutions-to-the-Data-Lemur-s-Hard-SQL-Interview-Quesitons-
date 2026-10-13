/*
Interview question here: https://datalemur.com/questions/yoy-growth-rate
 */

CREATE TABLE user_transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT NOT NULL,
    spend DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME NOT NULL
);


INSERT INTO user_transactions (transaction_id, product_id, spend, transaction_date) VALUES
(1, 101, 49.99, '2022-01-15 14:30:00'),
(2, 101, 60.50, '2021-01-16 09:15:22'),
(3, 102, 15.75, '2021-01-18 18:45:10'),
(4, 102, 20.99, '2022-01-20 11:05:45'),
(5, 103, 89.00, '2022-01-25 16:20:30'),
(6, 103, 49.99, '2021-02-01 10:11:00'),
(7, 104, 24.50, '2022-02-03 13:55:12'),
(8, 104, 30.00, '2021-02-05 20:01:33'),
(9, 105, 19.99, '2021-02-12 08:30:00'),
(10, 105, 15.75, '2022-04-12 19:40:15');

-- Without using LAG()

WITH cte AS(
SELECT product_id, 
SUM(spend) AS spend,
EXTRACT(YEAR FROM transaction_date) AS transaction_year
FROM user_transactions
GROUP BY product_id, EXTRACT(YEAR FROM transaction_date)
ORDER BY product_id, transaction_year ASC
)
SELECT c12.transaction_year,
c12.product_id,
c12.spend,
(SELECT spend FROM cte c22 WHERE c22.transaction_year = c12.transaction_year - 1
AND c22.product_id = c12.product_id) previous_year_spend,
ROUND(
(
(SELECT spend FROM cte c22 WHERE c22.transaction_year = c12.transaction_year
AND c22.product_id = c12.product_id)
-
(SELECT spend FROM cte c22 WHERE c22.transaction_year = c12.transaction_year - 1
AND c22.product_id = c12.product_id)
)/ ((SELECT spend FROM cte c22 WHERE c22.transaction_year = c12.transaction_year - 1
AND c22.product_id = c12.product_id)*1.0)*100.0,2)
 growth_rate
FROM cte c12;


/* Using LAG() */


WITH cte AS(
SELECT product_id, 
SUM(spend) AS spend,
EXTRACT(YEAR FROM transaction_date) AS transaction_year
FROM user_transactions
GROUP BY product_id, EXTRACT(YEAR FROM transaction_date)
ORDER BY product_id, transaction_year ASC
), 
cte2 AS(
SELECT transaction_year,
product_id,
spend,
LAG(spend) OVER(PARTITION BY product_id ORDER BY transaction_year ASC) AS previous_year_spend
FROM cte)
SELECT transaction_year,
product_id,
spend,
previous_year_spend,
ROUND(
((spend-previous_year_spend)/(previous_year_spend*1.0))*100.0
,2) AS yoy_rate
FROM cte2;
















 