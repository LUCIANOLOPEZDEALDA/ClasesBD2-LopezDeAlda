USE sakila;

#1
CREATE TABLE employees (
    employeeNumber INT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    jobTitle VARCHAR(50) NOT NULL
);

INSERT INTO employees (employeeNumber, firstName, lastName, email, jobTitle)
VALUES (1, 'Juan', 'Pérez', NULL, 'Sales Rep');

#Da el siguente error:
#Error Code: 1048. Column 'email' cannot be null
#Porque email tiene la restricción NOT NULL. La base de datos no permite almacenar un valor nulo.

#2
INSERT INTO employees (employeeNumber, firstName, lastName, email, jobTitle)
VALUES
(1001, 'Ana', 'Gómez', 'ana@example.com', 'Manager'),
(1002, 'Luis', 'Martínez', 'luis@example.com', 'Sales Rep'),
(1003, 'Sofía', 'López', 'sofia@example.com', 'Sales Rep');

UPDATE employees SET employeeNumber = employeeNumber - 20;
#Todos los employeeNumber se restan 20.
#1001 → 981
#1002 → 982
#1003 → 983
#Si employeeNumber es clave primaria, y la operación produce valores duplicados, MySQL dará un error de clave duplicada y no actualizará. Si no hay duplicados, la operación se realiza sin problema.

UPDATE employees SET employeeNumber = employeeNumber + 20;
#Ahora todos se suman 20. Si el paso anterior se hizo, vuelven a sus valores originales.
#De nuevo, si al sumar 20 generás un número que ya existe como clave primaria, MySQL aborta la actualización.

#3
ALTER TABLE employees
ADD COLUMN age INT CHECK (age BETWEEN 16 AND 70);

#4
#En la base de datos Sakila, la integridad referencial entre film, actor y film_actor se da porque esta última es una tabla intermedia que vincula a las dos primeras en una 
#relación muchos a muchos: cada registro en film_actor contiene un actor_id y un film_id, que son claves foráneas hacia actor y film respectivamente, y juntos forman la 
#clave primaria compuesta, lo que asegura que solo se registren combinaciones válidas de actores y películas sin duplicados ni referencias inexistentes.

#5
ALTER TABLE employees
ADD COLUMN lastUpdate DATETIME,
ADD COLUMN lastUpdateUser VARCHAR(50);

DELIMITER $$
CREATE TRIGGER employee_insert_lastupdate
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = CURRENT_USER();
END;
$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER employee_update_lastupdate
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = CURRENT_USER();
END;
$$
DELIMITER ;

#6
SHOW TRIGGERS LIKE 'film';
#Al ejecutar este comando aparecen tres disparadores definidos sobre la tabla film: ins_film, upd_film, del_film

#ins_film (AFTER INSERT ON film)
DELIMITER $$
CREATE TRIGGER `ins_film` AFTER INSERT ON `film`
FOR EACH ROW
BEGIN
  INSERT INTO film_text (film_id, title, description)
  VALUES (NEW.film_id, NEW.title, NEW.description);
END
$$
DELIMITER ;
#Cuando se inserta una nueva película en la tabla film, este trigger automáticamente crea un registro correspondiente en film_text con el mismo film_id, el title 
#y la description. Así asegura que toda película nueva quede indexada para búsquedas de texto.

#upd_film (AFTER UPDATE ON film)
DELIMITER $$
CREATE TRIGGER `upd_film` AFTER UPDATE ON `film`
FOR EACH ROW
BEGIN
  IF (OLD.title != NEW.title) OR (OLD.description != NEW.description) THEN
    UPDATE film_text
      SET title = NEW.title,
          description = NEW.description
    WHERE film_id = NEW.film_id;
  END IF;
END
$$
DELIMITER ;
#Cuando se actualiza una película en film, este trigger verifica si el título o la descripción cambiaron. Si es así, actualiza los mismos campos en film_text, 
#manteniendo la coherencia entre ambas tablas.

#del_film (AFTER DELETE ON film)
DELIMITER $$
CREATE TRIGGER `del_film` AFTER DELETE ON `film`
FOR EACH ROW
BEGIN
  DELETE FROM film_text WHERE film_id = OLD.film_id;
END
$$
DELIMITER ;
#Cuando se elimina una película en film, este trigger borra automáticamente el registro correspondiente en film_text, evitando que queden datos huérfanos.
