USE sakila;

#1
SELECT title
FROM film
WHERE film_id NOT IN (
    SELECT film_id
    FROM inventory
);

#2
SELECT f.title, i.inventory_id
FROM inventory i
JOIN film f ON i.film_id = f.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

#3
SELECT c.first_name,c.last_name,c.store_id,f.title,r.rental_date,r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY c.store_id, c.last_name;

#4
SELECT CONCAT(ci.city, ', ', co.country) AS location,CONCAT(m.first_name, ' ', m.last_name) AS manager,SUM(p.amount) AS total_sales
FROM store s
JOIN staff m ON s.manager_staff_id = m.staff_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id, location, manager;

#5
SELECT a.first_name,a.last_name,COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 1;
