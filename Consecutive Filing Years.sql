-- Interview question here: https://datalemur.com/questions/consecutive-filing-years

CREATE TABLE filed_taxes (
    filing_id INT,
    user_id INT,
    filing_date DATETIME,
    product VARCHAR(100)
);

INSERT INTO filed_taxes (filing_id, user_id, filing_date, product) VALUES
(1, 101, '2022-02-15', 'TurboTax Deluxe'),
(1, 101, '2023-01-11', 'TurboTax Premier'),
(1, 101, '2024-02-20', 'TurboTax Deluxe'),
(2, 102, '2022-02-18', 'H&R Block Desktop'),
(2, 102, '2023-01-19', 'TurboTax Premier'),
(3, 103, '2021-02-21', 'TurboTax Premier'),
(3, 103, '2022-02-21', 'TaxAct Free'),
(3, 103, '2023-02-20', 'TurboTax Premier'),
(4, 104, '2025-03-01', 'TaxAct Free'),
(5, 105, '2022-01-05', 'TurboTax Home & Business'),
(5, 105, '2023-04-05', 'TurboTax Home & Business'),
(5, 105, '2024-05-05', 'TurboTax Home & Business'),
(6, 106, '2025-03-10', 'FreeTaxUSA'),
(7, 107, '2025-03-12', 'TurboTax Online Deluxe');

WITH cte AS(
SELECT user_id, 
EXTRACT(YEAR FROM filing_date) AS year_,
LAG(EXTRACT(YEAR FROM filing_date)) OVER(PARTITION BY user_id ORDER BY EXTRACT(YEAR FROM filing_date))
as year_lag,
LEAD(EXTRACT(YEAR FROM filing_date)) OVER(PARTITION BY user_id ORDER BY EXTRACT(YEAR FROM filing_date))
as year_lead
FROM filed_taxes
WHERE product LIKE '%TurboTax%'
)
SELECT DISTINCT(user_id)
FROM cte 
WHERE year_ = year_lead - 1 AND year_ = year_lag + 1
ORDER BY 1 ASC
; 