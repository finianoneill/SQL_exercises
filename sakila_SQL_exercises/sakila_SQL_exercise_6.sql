-- Sakila DB SQL Exercises 6:
-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`:
-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use 
-- tables `staff` and `payment`.
-- 6c. List each film and the number of actors who are listed for that film. Use tables 
-- `film_actor` and `film`. Use inner join.
-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total 
-- paid by each customer. List the customers alphabetically by last name:
USE sakila;

-- 6a;
SELECT s.first_name, s.last_name, a.address
FROM staff s
LEFT JOIN address a ON s.address_id = a.address_id;

-- 6b;
SELECT s.first_name, s.last_name, sum_charge.total_amount_aug_2005
FROM staff s
LEFT JOIN (SELECT staff_id, SUM(amount) AS total_amount_aug_2005
FROM payment
WHERE payment_date >= '2005-05-01 00:00:00' AND payment_date < '2005-06-01 00:00:00'
GROUP BY staff_id) sum_charge
ON s.staff_id = sum_charge.staff_id;

-- 6c;
SELECT f.title, actor_sum.actor_count FROM film f
LEFT JOIN (SELECT film_id, SUM(actor_id) AS actor_count 
FROM film_actor
GROUP BY film_id) actor_sum
ON f.film_id = actor_sum.film_id;

-- 6d;
SELECT COUNT(inventory_id) AS hunchback_count FROM inventory
WHERE film_id IN (SELECT film_id FROM film
WHERE title = "Hunchback Impossible");

-- 6e;
SELECT c.first_name, c.last_name, sum_pay.total FROM customer c
LEFT JOIN (SELECT customer_id, SUM(amount) AS total FROM payment
GROUP BY customer_id) sum_pay
ON c.customer_id = sum_pay.customer_id
ORDER BY c.last_name;