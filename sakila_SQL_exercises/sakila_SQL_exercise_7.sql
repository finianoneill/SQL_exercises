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