/*
Interview question here: https://datalemur.com/questions/repeated-payments
*/

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    merchant_id INTEGER,
    credit_card_id INTEGER,
    amount INTEGER,
    transaction_timestamp DATETIME
);

INSERT INTO transactions (transaction_id, merchant_id, credit_card_id, amount, transaction_timestamp) VALUES
(1, 101, 5001, 230, '2026-06-01 10:30:00'),
(2, 102, 5002, 45, '2026-06-01 11:15:00'),
(3, 101, 5001, 230, '2026-06-01 10:33:00'),
(4, 103, 5001, 89, '2026-06-02 09:45:00'),
(5, 104, 5004, 310, '2026-06-02 14:20:00'),
(6, 104, 5004, 310, '2026-06-02 14:31:00'),
(7, 104, 5004, 310, '2026-06-02 14:31:30');

WITH cte AS (
SELECT *, 
LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp ASC) AS lag_ts
FROM transactions
)
SELECT COUNT(*) AS payment_count
FROM cte
WHERE TIMESTAMPDIFF(SECOND,lag_ts, transaction_timestamp) > 0
AND TIMESTAMPDIFF(SECOND, lag_ts, transaction_timestamp) < 600
;   