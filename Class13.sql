USE sakila;

#1
INSERT INTO customer
(store_id, first_name, last_name, email, address_id, active, create_date)
VALUES
(1,'Luciano','LopezDeAlda','l.lopezdealda@gmail.com',
  (
    SELECT a.address_id
    FROM address a
    JOIN city c ON a.city_id = c.city_id
    JOIN country co ON c.country_id = co.country_id
    WHERE co.country = 'United States'
    ORDER BY a.address_id DESC
    LIMIT 1
  ),1,'2025-07-16 10:30:00'
);

#2
INSERT INTO rental
(rental_date, inventory_id, customer_id, staff_id)
VALUES
('2025-07-16 15:00:00',
  (
    SELECT inventory_id
    FROM inventory
    JOIN film ON inventory.film_id = film.film_id
    WHERE film.title = 'CHILL LUCK'
    ORDER BY inventory_id DESC
    LIMIT 1
  ),
  (
    SELECT customer_id
    FROM customer
    ORDER BY customer_id DESC
    LIMIT 1
  ),
  (
    SELECT staff_id
    FROM staff
    WHERE store_id = 2
    LIMIT 1
  )
);

#3
UPDATE film
SET release_year = 2001
WHERE rating = 'G';

UPDATE film
SET release_year = 2002
WHERE rating = 'PG';

UPDATE film
SET release_year = 2003
WHERE rating = 'PG-13';

UPDATE film
SET release_year = 2004
WHERE rating = 'R';

UPDATE film
SET release_year = 2005
WHERE rating = 'NC-17';

#4
SELECT rental_id
FROM rental
WHERE return_date IS NULL
ORDER BY rental_date DESC
LIMIT 1;

UPDATE rental
SET return_date = '2025-07-16 16:30:00'
WHERE rental_id = (
  SELECT rental_id FROM (
    SELECT rental_id
    FROM rental
    WHERE return_date IS NULL
    ORDER BY rental_date DESC
    LIMIT 1
  ) AS temp
);

#5
#Primero eliminar los payments relacionados
DELETE FROM payment
WHERE rental_id IN (
  SELECT rental_id
  FROM rental
  WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id = 1
  )
);

#Segundo eliminar rental relacionados
DELETE FROM rental
WHERE inventory_id IN (
  SELECT inventory_id
  FROM inventory
  WHERE film_id = 1
);

#Tercero eliminar inventario relacionado
DELETE FROM inventory
WHERE film_id = 1;

#Cuarto eliminar film_actor relacionado
DELETE FROM film_actor
WHERE film_id = 1;

#Quinto eliminar film_category relacionado
DELETE FROM film_category
WHERE film_id = 1;

#Sexto eliminar la pelicula
DELETE FROM film_category
WHERE film_id = 1;

#6
SELECT inventory_id
FROM inventory
WHERE inventory_id NOT IN (
  SELECT inventory_id
  FROM rental
  WHERE return_date IS NULL
)
LIMIT 1;

INSERT INTO rental
(rental_date, inventory_id, customer_id, staff_id)
VALUES
('2025-07-16 11:45:00',10,
  (
    SELECT customer_id
    FROM customer
    ORDER BY customer_id DESC
    LIMIT 1
  ),
  (
    SELECT staff_id
    FROM staff
    ORDER BY staff_id DESC
    LIMIT 1
  )
);

INSERT INTO payment
(customer_id, staff_id, rental_id, amount, payment_date)
VALUES
(
  (
    SELECT customer_id
    FROM customer
    ORDER BY customer_id DESC
    LIMIT 1
  ),
  (
    SELECT staff_id
    FROM staff
    ORDER BY staff_id DESC
    LIMIT 1
  ),
  (
    SELECT rental_id
    FROM rental
    ORDER BY rental_id DESC
    LIMIT 1
  ),5.99,'2025-07-16 12:00:00'
);
