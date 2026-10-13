/*
Interview question here: https://datalemur.com/questions/prime-warehouse-storage
*/

CREATE TABLE inventory (
    item_id INT PRIMARY KEY,
    item_type VARCHAR(100),
    item_category VARCHAR(100),
    square_footage DECIMAL(10, 2)
);


INSERT INTO inventory (item_id, item_type, item_category, square_footage) VALUES
(5812, 'prime_eligible', 'microwave', 44.50),
(9931, 'not_prime', 'bookshelf', 52.00),
(6420, 'prime_eligible', 'air purifier', 45.20),
(1184, 'not_prime', 'desk', 48.50),
(7393, 'prime_eligible', 'blender', 41.50);

WITH cte AS(
SELECT item_type, 
SUM(square_footage) AS tot_sq,
COUNT(*) AS num_of_items
FROM inventory
GROUP BY item_type
)
SELECT item_type,
CASE
WHEN item_type = 'prime_eligible' THEN FLOOR(500000/tot_sq)*num_of_items
WHEN item_type != 'prime_eligible' THEN 
FLOOR
(
  (
  500000 -(SELECT FLOOR(500000/tot_sq)*tot_sq 
          FROM cte 
          WHERE item_type = 'prime_eligible')
  ) 
  /tot_sq
)
*num_of_items
END AS tot_count
FROM cte
;