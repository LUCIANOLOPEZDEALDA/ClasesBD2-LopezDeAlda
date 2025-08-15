USE sakila;

#1
SELECT 
  CONCAT(c.first_name, ' ', c.last_name) AS full_name,
  a.address,
  ci.city
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Argentina';

#2
SELECT 
  f.title,
  l.name AS language,
  CASE f.rating
    WHEN 'G' THEN 'General Audiences – All Ages Admitted'
    WHEN 'PG' THEN 'Parental Guidance Suggested – Some Material May Not Be Suitable for Children'
    WHEN 'PG-13' THEN 'Parents Strongly Cautioned – Some Material May Be Inappropriate for Children Under 13'
    WHEN 'R' THEN 'Restricted – Under 17 Requires Accompanying Parent or Adult Guardian'
    WHEN 'NC-17' THEN 'Adults Only – No One 17 and Under Admitted'
    ELSE 'Not Rated'
  END AS rating_description
FROM film f
JOIN language l ON f.language_id = l.language_id;

#3
-- Supongamos:
SET @first = 'Tom';
SET @last = 'Hanks';

SELECT DISTINCT f.title, f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name = @first AND a.last_name = @last;

#4
SELECT 
  f.title,
  CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
  CASE 
    WHEN r.return_date IS NOT NULL THEN 'Yes'
    ELSE 'No'
  END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE DATE_FORMAT(r.rental_date, '%m-%d') BETWEEN '05-01' AND '06-30';

#5
#Diferencias
#Funcionalmente hacen lo mismo.
#CAST es más portable (se puede usar en otros sistemas como PostgreSQL, SQL Server, etc.).
#CONVERT tiene más variantes en MySQL

#Ejemplos
#Convertir release_year a texto
SELECT 
  title,
  release_year,
  CAST(release_year AS CHAR) AS year_casted,
  CONVERT(release_year, CHAR) AS year_converted
FROM film
LIMIT 5;

#Convertir la duración (length) de una película a decimal
SELECT 
  title,
  length,
  CAST(length AS DECIMAL(5,2)) AS duration_decimal
FROM film
LIMIT 5;

#6
#NVL(a,b), No esta en Mysql, Devuelve a si no es NULL; si a es NULL, devuelve b.
#ISNULL(a), Si esta en Mysql, Devuelve 1 si a es NULL, 0 si no. (Función lógica, no devuelve el valor)
#IFNULL(a,b), Si esta en Mysql, Igual a NVL: si a es NULL, devuelve b.
#COALESCE(a, b, c, ...), Si esta en Mysql, 	Devuelve el primer valor no NULL de la lista.

#Ejemplos
#Mostrar email del cliente, o texto alternativo si no tiene
SELECT 
  first_name,
  last_name,
  IFNULL(email, 'Sin email') AS email_mostrado
FROM customer;

#Mostrar nombre del actor o una cadena por defecto
SELECT 
  first_name,
  COALESCE(last_name, 'SIN APELLIDO') AS apellido
FROM actor;
