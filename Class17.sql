USE sakila;

#1
#Usando IN
#Tiempo de ejecucion antes de indice: 0.00074950
#Tiempo de ejecucion despues de indice: 0.00035050
SELECT address_id, address, district, postal_code
FROM address
WHERE postal_code IN ('52137', '32814', '28012');

#Usando NOT IN
#Tiempo de ejecucion antes de indice: 0.00071750
#Tiempo de ejecucion despues de indice: 0.00020100
SELECT address_id, address, district, postal_code
FROM address
WHERE postal_code NOT IN ('52137', '32814', '28012');

#Con join a city y country 
#Tiempo de ejecucion antes de indice: 0.00075800
#Tiempo de ejecucion despues de indice: 0.00050075
SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code IN ('52137', '32814');

#Para medir el tiempo de ejecucion antes del indice
SET profiling = 1;
#Consultas anteriores
SHOW PROFILES;

#Indice para postal_code
CREATE INDEX idx_postal_code ON address(postal_code);

#Para medir el tiempo de ejecucion despues del indice
SET profiling = 1;
#Consultas anteriores
SHOW PROFILES;

#Antes del índice: MySQL tenía que revisar todas las filas porque postal_code no estaba indexado.
#Después del índice: MySQL accede directamente a las filas que coinciden, acelerando la búsqueda.
#Conclusión: el uso de índices mejora el rendimiento, sobre todo cuando la condición es selectiva (pocos valores de postal_code).

#2
#Búsqueda por first_name
#Tiempo de ejecucion: 0.00037525
SET profiling = 1;
SELECT * FROM actor WHERE first_name = 'NICK';
SHOW PROFILES;

#Búsqueda por last_name
#Tiempo de ejecucion: 0.00036250
SET profiling = 1;
SELECT * FROM actor WHERE last_name = 'WAHLBERG';
SHOW PROFILES;

#En Sakila, existe un índice en la columna last_name, por eso esa consulta es rápida.
#En cambio, first_name no está indexado, entonces MySQL tiene que revisar todas las filas de la tabla.
#Conclusión: buscar por last_name es más eficiente gracias al índice. Buscar por first_name es más lento porque no tiene índice.

#3
#Usando LIKE en film.description
#Tiempo de ejecucion: 0.00217400
SET profiling = 1;
SELECT film_id, title, description
FROM film
WHERE description LIKE '%amazing%';
SHOW PROFILES;

#Usando FULLTEXT con film_text.description
#Tiempo de ejecucion: 0.00174325
Alter table film
add FULLTEXT(description);

SET profiling = 1;
SELECT film_id, title, description
FROM film
WHERE MATCH (description) AGAINST('amazing');
SHOW PROFILES;

#LIKE: hace coincidencia literal de cadenas → es lento, porque revisa fila por fila.
#MATCH ... AGAINST: usa un índice FULLTEXT → es mucho más rápido y devuelve resultados ordenados por relevancia.
#Conclusión: para búsquedas de texto grande, lo ideal es FULLTEXT. LIKE solo sirve en casos muy simples