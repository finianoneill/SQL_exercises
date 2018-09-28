-- Sakila DB SQL Exercises 3:
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a 
-- column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference 
-- between it and `VARCHAR` are significant).
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
USE sakila;

-- 3a;
ALTER TABLE actor
ADD description BLOB;

-- 3b;
ALTER TABLE actor
DROP COLUMN description;