USE sakila;

#1
#Creo el usuario data_analyst
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY '47709712';

#2
#Le doy permisos de SELECT, UPDATE y DELETE
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

#3
#Me logueo con la cuenta data_analyst y intento crear una tabla
CREATE TABLE tabla_analista (
    id INT PRIMARY KEY,
    name VARCHAR(50)
);
#Da el siguiente error porque no le di permisos de CREATE
#Error Code: 1142. CREATE command denied to user 'data_analyst'@'localhost' for table 'tabla_analista'

#4
#Actualizo el nombre de una pelicula
UPDATE sakila.film
SET title = 'SUPER ACADEMIA DE DINOSAURIOS'
WHERE title = 'ACADEMY DINOSAUR';

#5
#Le sacamos el privilegio de UPDATE a data_analyst
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';
FLUSH PRIVILEGES;

#6
#Me logueo de nuevo con la cuenta data_analyst y intento actualizar una tabla
UPDATE sakila.film
SET title = 'ACADEMY DRAGON 2'
WHERE title = 'ACADEMY DRAGON';
#Da el siguiente error porque le sacamos el privilegio de UPDATE
#Error Code: 1142. UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'