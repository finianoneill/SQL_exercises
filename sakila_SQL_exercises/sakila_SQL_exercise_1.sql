-- Sakila DB SQL Exercises 1:
-- 1a. Display the first and last names of all actors from the table actor.
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
USE sakila;

-- 1a;
SELECT first_name, last_name FROM actor;

-- 1b;
SELECT (UPPER(CONCAT(first_name, " ", last_name))) AS actor_name FROM actor;