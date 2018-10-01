-- Sakila DB SQL Exercises 4:
-- 4a. List the last names of actors, as well as how many actors have that last name.
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
-- 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
USE sakila;

-- 4a;
SELECT last_name, COUNT(last_name) AS last_name_count FROM actor
GROUP BY last_name;

-- 4b;
SELECT count.* FROM
(SELECT last_name, COUNT(last_name) AS last_name_count FROM actor
GROUP BY last_name) count
WHERE count.last_name_count > 1;

-- 4c;
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d;
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";