-- Sakila DB SQL Exercises 7:
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared 
-- in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names 
-- and email addresses of all Canadian customers. Use joins to retrieve this information.
-- 7d. Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films.
-- 7e. Display the most frequently rented movies in descending order.
-- 7f. Write a query to display how much business, in dollars, each store brought in.
-- 7g. Write a query to display for each store its store ID, city, and country.
-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
USE sakila;

-- 7a;
SELECT title FROM film
WHERE title LIKE "K%" OR title LIKE "Q%"
AND language_id IN (SELECT language_id FROM language
WHERE name = "English");

-- 7b;
SELECT first_name, last_name FROM actor
WHERE actor_id IN (SELECT actor_id FROM film_actor
WHERE film_id IN (SELECT film_id FROM film
WHERE title = "Alone Trip"));

-- 7c;
SELECT cust_address.first_name, cust_address.last_name, cust_address.email FROM city cit
LEFT JOIN (SELECT c.first_name, c.last_name, c.email, c.address_id, a.city_id FROM customer c
LEFT JOIN address a ON c.address_id = a.address_id) cust_address
ON cit.city_id = cust_address.city_id
WHERE cit.country_id IN (SELECT country_id FROM country
WHERE country = "Canada");

-- 7d;
SELECT title FROM film
WHERE film_id IN (SELECT film_id FROM film_category
WHERE category_id IN (SELECT category_id FROM category
WHERE name = "Family"));

-- 7e;
SELECT f.title, roll_up.total_rentals FROM (
SELECT merge_table.film_id, SUM(merge_table.rental_count) AS total_rentals FROM (
SELECT r.*, i.film_id FROM (
SELECT inventory_id, COUNT(inventory_id) AS rental_count FROM rental
GROUP BY inventory_id) r
LEFT JOIN inventory i
ON r.inventory_id = i.inventory_id) merge_table
GROUP BY merge_table.film_id) roll_up
LEFT JOIN film f
ON roll_up.film_id = f.film_id
ORDER BY roll_up.total_rentals DESC;

-- 7f;
SELECT s.store_id, staff_pay.total_charged FROM (
SELECT staff_id, SUM(amount) AS total_charged FROM payment
GROUP BY staff_id) staff_pay
LEFT JOIN staff s
ON staff_pay.staff_id = s.staff_id;

-- 7g. 
-- Write a query to display for each store its store ID, city, and country.
SELECT store_city.store_id, store_city.city, coun.country FROM (
SELECT store_add.*, c.city, c.country_id FROM (
SELECT s.store_id, s.address_id, a.city_id FROM store s
LEFT JOIN address a ON s.address_id = a.address_id) store_add
LEFT JOIN city c ON store_add.city_id = c.city_id) store_city
LEFT JOIN country coun
ON store_city.country_id = coun.country_id;

-- 7h;
SELECT c.name, w.category_sum FROM category c
LEFT JOIN (SELECT q.category_id, SUM(q.film_sum) AS category_sum FROM (
SELECT fc.category_id, film_roll_up.film_sum  FROM (
SELECT z.film_id, SUM(z.inventory_sum) AS film_sum FROM (
SELECT i.film_id, merge_y.inventory_sum FROM (
SELECT x.inventory_id, SUM(x.rental_sum) AS inventory_sum FROM (
SELECT rental_tot.*, r.inventory_id FROM (
SELECT rental_id, SUM(amount) AS rental_sum FROM payment
GROUP BY rental_id) rental_tot
LEFT JOIN rental r
ON rental_tot.rental_id = r.rental_id) x
GROUP BY x.inventory_id) merge_y
LEFT JOIN inventory i
ON merge_y.inventory_id = i.inventory_id) z
GROUP BY z.film_id) film_roll_up
LEFT JOIN film_category fc
ON film_roll_up.film_id = fc.film_id) q
GROUP BY q.category_id) w
ON c.category_id = w.category_id
ORDER BY w.category_sum DESC
LIMIT 5;