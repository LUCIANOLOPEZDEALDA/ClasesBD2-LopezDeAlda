USE sakila;

#1
CREATE OR REPLACE VIEW list_of_customers AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS full_name, a.address, a.postal_code, a.phone ,ci.city ,co.country ,CASE WHEN c.active = 1 THEN 'active' ELSE 'inactive' END AS status, c.store_id
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

#2
CREATE OR REPLACE VIEW film_details AS
SELECT f.film_id, f.title, f.description, c.name AS category, f.rental_rate AS price, f.length, f.rating, GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id, f.title, f.description, category, f.rental_rate, f.length, f.rating;

#3
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT c.name AS category, COUNT(r.rental_id) AS total_rental
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

#4
CREATE OR REPLACE VIEW actor_information AS
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

#5
CREATE OR REPLACE VIEW actor_info AS
SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor_name, COUNT(fa.film_id) AS film_count
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, actor_name;

#CREATE VIEW actor_info AS
#Define la vista actor_info.

#SELECT a.actor_id, CONCAT(a.first_name, ' ', a.last_name) AS actor_name, COUNT(fa.film_id) AS film_count
#actor_id: el id del actor.
#actor_name: nombre completo generado concatenando first_name y last_name.
#film_count: cuenta cuántas películas tiene asociadas.

#FROM actor a
#La tabla principal es actor.

#LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
#Une cada actor con film_actor.
#Si un actor no actuó en ninguna película, aparecerá igualmente en la vista con film_count = 0 (porque LEFT JOIN mantiene la fila del lado izquierdo).

#GROUP BY a.actor_id, actor_name
#Agrupa los resultados por id y nombre para que COUNT(fa.film_id) cuente la cantidad de films por actor de forma correcta.

#6
#Definición:
#Una materialized view (vista materializada) es similar a una VIEW, pero:
#Almacena físicamente el resultado de la consulta en la base de datos.
#Se actualiza manualmente o automáticamente según configuración.

#Uso:
#Para mejorar performance en consultas complejas que no necesitan datos en tiempo real (por ej. reportes diarios).
#Evita calcular la consulta cada vez que se la utiliza.

#Alternativas:
#Crear tablas intermedias y actualizarlas con triggers o jobs programados si tu DBMS no soporta materialized views.

#DBMS donde existen:
#PostgreSQL: soporta materialized views nativamente con CREATE MATERIALIZED VIEW.
#Oracle: soporta materialized views para replicación y rendimiento.