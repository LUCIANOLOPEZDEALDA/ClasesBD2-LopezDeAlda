USE sakila;

#1
SELECT title, special_features 
FROM film 
WHERE rating = 'PG-13';

#2
SELECT length
FROM film;

#3
SELECT title, rental_rate, replacement_cost
FROM film
WHERE replacement_cost BETWEEN 20.00 AND 24.00;

#4
SELECT f.title, c.name AS category, f.rating
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
WHERE f.special_features LIKE '%Behind the Scenes%';


#5
SELECT a.first_name, a.last_name
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ZOOLANDER FICTION';

#6
SELECT a.address, c.city, co.country
FROM store s
INNER JOIN address a ON s.address_id = a.address_id
INNER JOIN city c ON a.city_id = c.city_id
INNER JOIN country co ON c.country_id = co.country_id
WHERE s.store_id = 1;

#7
SELECT f1.title AS film_1, f2.title AS film_2, f1.rating
FROM film f1
INNER JOIN film f2 ON f1.rating = f2.rating AND f1.film_id < f2.film_id
ORDER BY f1.rating;

#8
SELECT f.title, m.first_name AS manager_first_name, m.last_name AS manager_last_name
FROM inventory i
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN store s ON i.store_id = s.store_id
INNER JOIN staff m ON s.manager_staff_id = m.staff_id
WHERE i.store_id = 2;
