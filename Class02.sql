DROP DATABASE imdb;
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

CREATE TABLE film (
film_id INT(11) NOT NULL AUTO_INCREMENT,
 title VARCHAR(30) NOT NULL,
 description VARCHAR(60),
 release_year YEAR,
 CONSTRAINT film_pk PRIMARY KEY (film_id)
);

CREATE TABLE actor (
    actor_id INT(11) NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30)NOT NULL,
    CONSTRAINT actor_pk PRIMARY KEY (actor_id)
);

CREATE TABLE film_actor (
	actor_id INT(11) NOT NULL, 
	film_id INT(11) NOT NULL,
    CONSTRAINT film_actor_pk PRIMARY KEY (actor_id, film_id)
);

ALTER TABLE film 
 ADD last_update DATE
  AFTER release_year;
    
ALTER TABLE actor
 ADD last_update DATE
  AFTER actor_id;

ALTER TABLE film_actor 
 ADD CONSTRAINT fk_film_actor_actor 
  FOREIGN KEY (actor_id) 
   REFERENCES actor(actor_id);
   
ALTER TABLE film_actor
 ADD CONSTRAINT fk_film_actor_film 
  FOREIGN KEY (film_id) 
   REFERENCES film(film_id);

INSERT INTO actor (first_name, last_name) VALUES ('Robert', 'Downey Jr.'), ('Scarlett', 'Johansson'), ('Chris', 'Evans');

INSERT INTO film (title, description, release_year) VALUES ('Iron Man', 'A billionaire builds a suit to fight crime.', 2008), ('The Avengers', 'Superheroes team up to save the world.', 2012);

INSERT INTO film_actor (actor_id, film_id) VALUES (1, 1), (1, 2), (2, 2), (3, 2);

SELECT f.title AS pelicula, a.first_name AS nombre_actor, a.last_name AS apellido_actor
FROM film_actor fa
INNER JOIN film f ON fa.film_id = f.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id;