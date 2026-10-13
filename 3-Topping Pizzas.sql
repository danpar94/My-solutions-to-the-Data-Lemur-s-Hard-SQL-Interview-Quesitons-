-- Interview question here: https://datalemur.com/questions/pizzas-topping-cost

CREATE TABLE pizza_toppings (
    topping_name VARCHAR(50) PRIMARY KEY,
    ingredient_cost DECIMAL(5, 2)
);

INSERT INTO pizza_toppings (topping_name, ingredient_cost) VALUES
('Pepperoni', 1.50),
('Grilled Chicken', 2.25),
('Extra Cheese', 2.00),
('Mushrooms', 0.80),
('Black Olives', 0.70),
('Pineapple', 0.90),
('Bacon', 1.75),
('Jalapenos', 0.60);

SELECT CONCAT(pt1.topping_name,',',pt2.topping_name,',',pt3.topping_name) AS pizza,
pt1.ingredient_cost + pt2.ingredient_cost + pt3.ingredient_cost AS total_cost
FROM pizza_toppings pt1
CROSS JOIN pizza_toppings pt2
CROSS JOIN pizza_toppings pt3
WHERE (pt1.topping_name < pt2.topping_name AND pt2.topping_name < pt3.topping_name)
ORDER BY total_cost DESC, 
pizza ASC
;