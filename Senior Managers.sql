/*
Interview question here: https://datalemur.com/questions/senior-managers-reportees
*/

CREATE TABLE employees (
    emp_id INT,
    manager_id INT,
    manager_name VARCHAR(100)
);

-- Insert sample data into the table
INSERT INTO employees (emp_id, manager_id, manager_name) VALUES
(1, 101, 'Alice'),
(2, 101, 'Alice'),
(3, 102, 'Bob'),
(4, 103, 'Charlie'),
(103, 102, 'Bob'),
(6, 1001, 'Rick'),
(7, 1002, 'Paul'),
(1002, 102, 'Bob'),
(102, 104, 'Eric'),
(5, 102, 'Bob'),
(1001, 105, 'Jane')
;

WITH cte AS(
SELECT *
FROM employees
WHERE emp_id NOT IN (SELECT manager_id FROM employees WHERE manager_id IS NOT NULL)
),
cte2 AS(
SELECT emp_id AS manager1, manager_id AS manager2, manager_name
FROM employees
WHERE emp_id IN (SELECT manager_id FROM cte WHERE manager_id IS NOT NULL)
), cte3 AS(
SELECT *
FROM cte2 
WHERE manager1 NOT IN (SELECT manager2 FROM cte2 WHERE manager2 IS NOT NULL)
)
SELECT manager_id, manager_name AS senior_name, COUNT(emp_id) AS direct_reports
FROM employees
WHERE manager_id IN (SELECT manager2 FROM cte3)
GROUP BY manager_id, manager_name
ORDER BY direct_reports DESC;  
