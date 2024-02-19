CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" TIMESTAMP
);

INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);
INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  


SET search_path TO pizza_runner
-- To progress with the data exploration, there is a need to clean the data tables. Tables such as 
-- customer_orders have null values in the exclusions while the extras column has NaN and null values.

-- To do this, the tables would be updated
-- Note that IS NULL function takes care of NaN values while others take care of null values

  
UPDATE customer_orders SET extras = '' WHERE extras IS NULL OR extras = 'null' OR extras LIKE 'null'
UPDATE customer_orders SET exclusions = '' WHERE exclusions = 'null'

SELECT * FROM customer_orders
ORDER BY order_id ASC;
-- The reason for using the ORDER BY function is to avoid clustering of blank rows to the bottom of
-- the table and rows with a value at the top of the table

-- Replacing NaN and null values in the runner_orders table
UPDATE runner_orders SET cancellation = '' WHERE cancellation IS NULL OR cancellation = 'null'
UPDATE runner_orders SET pickup_time = '' WHERE pickup_time = 'null'
UPDATE runner_orders SET distance = '' WHERE distance = 'null'
UPDATE runner_orders SET duration = '' WHERE duration = 'null'

-- Delete km from the distance column and converting the numbers into float datatype
UPDATE runner_orders 
	SET distance = 
	CASE WHEN distance LIKE '%km' THEN TRIM('km' FROM distance) ELSE distance END;
	
--changing to double precision datatype from varchar because I could not convert to float	
ALTER TABLE runner_orders
ALTER COLUMN distance TYPE double precision
USING NULLIF(distance, '')::double precision;	
	

SELECT * FROM runner_orders
ORDER BY order_id ASC;


-- Delete minutes and mins from the duration column and converting the numbers into float datatype
UPDATE runner_orders 
	SET duration = 
	CASE WHEN duration LIKE '%minutes'
		THEN TRIM('minutes' FROM duration)
	WHEN duration LIKE '%minute' 
		THEN TRIM('minute' FROM duration)
	WHEN duration LIKE '%mins' 
		THEN TRIM('mins' FROM duration) ELSE duration
	END;

--changing to double precision datatype from varchar because I could not convert to float	
ALTER TABLE runner_orders
ALTER COLUMN duration TYPE double precision
USING NULLIF(duration, '')::double precision;

SELECT * FROM runner_orders
ORDER BY order_id ASC;
          

-- Convert pickup_time from varchar datatype to datetime datatype
ALTER TABLE runner_orders
ALTER COLUMN pickup_time TYPE timestamp
USING NULLIF(pickup_time, '')::timestamp;

SELECT * FROM runner_orders
ORDER BY order_id ASC;

--While inspecting my data, I noticed oerder_id 8 with column distance had a null value
--which is not supposed to be so. Because of this, I had to manually input the value.
UPDATE runner_orders
SET distance = 23.4
WHERE order_id = 8;


SELECT * FROM runner_orders
ORDER BY order_id ASC;
--   A. Pizza Metrics

--How many pizzas were ordered?

SELECT COUNT(order_id) AS total_pizza_orders FROM customer_orders

--How many unique customer orders were made?

SELECT COUNT(DISTINCT customer_id) AS unique_pizza_orders FROM customer_orders

--How many successful orders were delivered by each runner?

SELECT runner_id, COUNT(duration) AS no_of_successful_orders FROM runner_orders
GROUP BY runner_id 
ORDER BY runner_id ASC;

--How many of each type of pizza was delivered?

SELECT c.customer_id, c.order_id, c.pizza_id, p.pizza_name, r.runner_id, r.distance, r.cancellation
FROM customer_orders c
JOIN pizza_names p 
ON c.pizza_id = p.pizza_id
JOIN runner_orders r 
ON c.order_id = r.order_id
ORDER BY c.order_id ASC;


SELECT p.pizza_name, COUNT(r.distance) AS no_delivered
FROM customer_orders c
JOIN pizza_names p 
ON c.pizza_id = p.pizza_id
JOIN runner_orders r 
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL
GROUP BY p.pizza_name;


--How many Vegetarian and Meatlovers were ordered by each customer?

SELECT c.customer_id, p.pizza_name, COUNT(p.pizza_name) AS no_of_orders
FROM customer_orders c
JOIN pizza_names p 
ON c.pizza_id = p.pizza_id
GROUP BY 1, 2
ORDER BY 1 ASC;

--What was the maximum number of pizzas delivered in a single order?

SELECT c.order_id AS single_order, COUNT(r.pickup_time) AS max_no_pizza_delivered
FROM customer_orders c
JOIN runner_orders r
ON r.order_id = c.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY c.order_id
ORDER BY 2 DESC
LIMIT 1;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT c.customer_id,
SUM(CASE WHEN (c.exclusions != '' OR c.extras != '') THEN 1 ELSE 0 END) AS at_least_a_change,
SUM(CASE WHEN (c.exclusions = '' AND c.extras = '') THEN 1 ELSE 0 END) AS no_change,
COUNT (r.distance) AS no_of_deliveries
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.duration IS NOT NULL
GROUP BY 1;



SELECT c.customer_id, COUNT(r.duration) AS count_of_delivered_pizzas,
SUM(CASE WHEN c.exclusions != '' OR c.extras != '' THEN 1 ELSE 0 END) AS changes,
SUM(CASE WHEN c.exclusions = '' AND c.extras = '' THEN 1 ELSE 0 END) AS no_changes
FROM customer_orders c
JOIN runner_orders r
ON r.order_id = c.order_id
WHERE r.duration IS NOT NULL
GROUP BY c.customer_id
ORDER BY 2 DESC;

--How many pizzas were delivered that had both exclusions and extras?

SELECT c.customer_id, c.exclusions, c.extras, r.duration
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id


SELECT COUNT(r.duration)
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE c.exclusions != '' AND c.extras != '' AND r.duration IS NOT NULL

--What was the total volume of pizzas ordered for each hour of the day?

SELECT EXTRACT(HOUR FROM order_time) AS hour, COUNT(order_id) AS volume_ordered
FROM customer_orders
GROUP BY 1
ORDER BY 1 ASC;

--What was the volume of orders for each day of the week?

SELECT EXTRACT(DAY FROM order_time) AS day_of_the_week, COUNT(order_id) AS volume_ordered
FROM customer_orders
GROUP BY 1
ORDER BY 1 ASC;


--       RUNNER AND CUSTOMER EXPERIENCE

--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

SELECT DATE_PART('week', registration_date) AS week, COUNT(runner_id) AS runner_count
FROM runners
GROUP BY 1
ORDER BY 1 ASC;

SELECT EXTRACT(WEEK FROM registration_date) AS week, COUNT(runner_id) AS runner_count
FROM runners
GROUP BY 1
ORDER BY 1 ASC;

SELECT EXTRACT(WEEK FROM registration_date) AS Week, registration_date
FROM runners


--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT r.runner_id, c.order_time, r.pickup_time, DATE_PART('MINUTE', r.pickup_time - c.order_time) AS min_diff
FROM runner_orders r
JOIN customer_orders c
ON r.order_id = c.order_id
WHERE r.pickup_time IS NOT NULL
ORDER BY 1

SELECT r.runner_id, ROUND(AVG(DATE_PART('MINUTE', r.pickup_time - c.order_time))) AS min_diff
FROM runner_orders r
JOIN customer_orders c
ON r.order_id = c.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY 1
ORDER BY 1;

--Is there any relationship between the number of pizzas and how long the order takes to prepare?


--The same customer can call at a different time on the same day to make a new order (mmy thoughts)
SELECT c.customer_id, c.order_time,  
	DATE_PART('day', c.order_time) AS day_ordered,
	COUNT(c.customer_id),
	ROUND(AVG(DATE_PART('MINUTE', r.pickup_time - c.order_time))) AS min_diff
FROM customer_orders c
JOIN runner_orders r
ON r.order_id = c.order_id
WHERE r.pickup_time IS NOT NULL
GROUP BY 3, 1, 2
ORDER BY 1;


--What was the average distance travelled for each customer?

SELECT c.customer_id, ROUND(AVG(r.distance)) AS avg_distance_travelled
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL
GROUP BY 1
ORDER BY 1;

--What was the difference between the longest and shortest delivery times for all orders?

-- delivery time starts from the moment the pizza was ordered i.e., pickup time - order time plus duration

SELECT c.order_time, r.pickup_time, DATE_PART('MINUTE', r.pickup_time - c.order_time),
	r.duration, DATE_PART('MINUTE', r.pickup_time - c.order_time) + r.duration
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL

SELECT MAX(DATE_PART('MINUTE', r.pickup_time - c.order_time) + r.duration) 
	- MIN(DATE_PART('MINUTE', r.pickup_time - c.order_time) + r.duration) AS diff_in_delivery
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL

--What was the average speed for each runner for each delivery and do you notice any trend for these values?

--To get the speed of each runner, the distance would be divided by the duration. But the duration
--is in minutes, and it needs to be converted to hours so the speed can be gotten.

-- There are 8 different deliveries, so we need to find the average speed for each of those deliveries
-- Not just the average speed of the runners

SELECT c.order_id, c.customer_id, r.runner_id, r.distance, r.duration,
	duration/60 AS dur_in_hrs, 
	AVG(distance/(duration/60)) AS avg_speed
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
WHERE r.distance IS NOT NULL
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY 1, 2;


--What is the successful delivery percentage for each runner?

SELECT c.order_id, c.customer_id, r.runner_id, r.distance
FROM customer_orders c
JOIN runner_orders r
ON c.order_id = r.order_id
ORDER BY 1, 2;

SELECT t1.runner_id, t1.no_of_deliveries, t2.successful_deliveries, 
	CONCAT((t2.successful_deliveries/t1.no_of_deliveries * 100), '%') AS percent_deliveries
FROM 
	(SELECT r.runner_id, COUNT(c.order_id) AS no_of_deliveries
	FROM customer_orders c
	JOIN runner_orders r
	ON c.order_id = r.order_id
	GROUP BY 1) t1
JOIN
	(SELECT r.runner_id, COUNT(c.order_id) AS successful_deliveries
	FROM customer_orders c
	JOIN runner_orders r
	ON c.order_id = r.order_id
	WHERE r.distance IS NOT NULL
	GROUP BY 1) t2
ON t1.runner_id = t2.runner_id
ORDER BY t1.runner_id



--C. INGRIDIENTS OPTIMIZATION

--What are the standard ingredients for each pizza?

--create a temporary table
CREATE TEMP TABLE newtable (
  pizza_id INT,
  topping_id INT,
  topping_name TEXT
) ON COMMIT DROP;

INSERT INTO newtable
SELECT pr.pizza_id,
       CAST(value::double precision AS INT) AS topping_id,
       pt.topping_name
FROM pizza_recipes pr
CROSS JOIN LATERAL unnest(string_to_array(pr.toppings, ',')) AS value -- Unnest the array
JOIN pizza_toppings pt
ON value::double precision = pt.topping_id;

-- concatenate the toppings for each pizza_id using STRING_AGG
SELECT
  nt.pizza_id, pn.pizza_name,
  STRING_AGG(nt.topping_name, ', ') AS toppings_list
FROM newtable nt
JOIN pizza_names pn
ON pn.pizza_id = nt.pizza_id
GROUP BY 1, 2
ORDER BY 1;


-- Option 2, create a permanent table. Might not be best practice
CREATE TABLE toppingspivot (
  pizza_id INT NOT NULL,
  topping_id INT NOT NULL,
  topping_name TEXT NOT NULL
);

INSERT INTO toppingspivot
SELECT pr.pizza_id,
  CAST(value::double precision AS INT) AS topping_id,
  pt.topping_name
FROM pizza_recipes pr
CROSS JOIN LATERAL unnest(string_to_array(pr.toppings, ',')) AS value
JOIN pizza_toppings pt
ON value::double precision = pt.topping_id;

-- concatenate the toppings for each pizza_id using STRING_AGG
SELECT
  pizza_id,
  STRING_AGG(topping_name, ', ') AS toppings_list
FROM toppingspivot
GROUP BY pizza_id
ORDER BY pizza_id;