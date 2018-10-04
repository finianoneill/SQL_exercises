-- Sakila DB SQL Exercises 8:
-- 8a. In your new role as an executive, you would like to have an easy way of 
-- viewing the Top five genres by gross revenue. Use the solution from the problem 
-- above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
-- 8b. How would you display the view that you created in 8a?
-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
USE sakila;

-- 8a;
CREATE VIEW top_five_genres AS
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

-- 8b;
SELECT * FROM top_five_genres;

-- 8c;
DROP VIEW top_five_genres;