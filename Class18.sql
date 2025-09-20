USE sakila;

#1
DELIMITER $$$$

CREATE FUNCTION copies_in_store(p_film_id INT, p_film_title VARCHAR(255), p_store_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_count INT;

    #Si se pasa el ID
    IF p_film_id IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_count
        FROM inventory i
        WHERE i.film_id = p_film_id
          AND i.store_id = p_store_id;

    #Si se pasa el nombre
    ELSEIF p_film_title IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_count
        FROM inventory i
        JOIN film f ON f.film_id = i.film_id
        WHERE f.title = p_film_title
          AND i.store_id = p_store_id;
    ELSE
        SET v_count = 0;
    END IF;

    RETURN v_count;
END $$$$

DELIMITER ;

#Buscar por film_id
SELECT copies_in_store(1, NULL, 1);

#Buscar por título
SELECT copies_in_store(NULL, 'ACADEMY DINOSAUR', 1);


#2
DELIMITER $$$$

CREATE PROCEDURE customers_in_country(
    IN p_country VARCHAR(50),
    OUT p_customers TEXT
)
BEGIN
    DECLARE v_first VARCHAR(45);
    DECLARE v_last VARCHAR(45);
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_result TEXT DEFAULT '';

    -- Definir cursor
    DECLARE cur CURSOR FOR
        SELECT c.first_name, c.last_name
        FROM customer c
        JOIN address a ON c.address_id = a.address_id
        JOIN city ci ON a.city_id = ci.city_id
        JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = p_country;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_first, v_last;
        IF v_done = 1 THEN
            LEAVE read_loop;
        END IF;

        IF v_result = '' THEN
            SET v_result = CONCAT(v_first, ' ', v_last);
        ELSE
            SET v_result = CONCAT(v_result, ';', v_first, ' ', v_last);
        END IF;
    END LOOP;

    CLOSE cur;

    SET p_customers = v_result;
END $$$$

DELIMITER ;

CALL customers_in_country('Argentina', @clientes);
SELECT @clientes;


#3.1
DELIMITER $$$$

CREATE FUNCTION inventory_in_stock_v2(p_inventory_id INT) RETURNS BOOLEAN  #Ya existe una funcion en sakila con el nombre inventory_in_stock por eso le pongo el v2
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;   #Variable para contar cuántos alquileres tuvo esa copia
    DECLARE v_out     INT;   #Variable para ver si la copia sigue alquilada (no devuelta)

    #Verificamos si la copia alguna vez fue alquilada
    SELECT COUNT(*) INTO v_rentals
    FROM rental r
    WHERE r.inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
        RETURN TRUE;   #Si nunca fue alquilada, significa que está disponible
    END IF;

    #Si fue alquilada, vemos si todavía está alquilada (sin fecha de devolución)
    SELECT COUNT(*) INTO v_out
    FROM rental r
    WHERE r.inventory_id = p_inventory_id
      AND r.return_date IS NULL;

    IF v_out > 0 THEN
        RETURN FALSE;  #Si existe un alquiler sin devolución va a estar NO DISPONIBLE
    ELSE
        RETURN TRUE;   #Si todos los alquileres fueron devueltos va a estar DISPONIBLE
    END IF;
END $$$$

DELIMITER ;

#Ejemplo
SELECT inventory_in_stock_v2(1);  #Devuelve 1 (TRUE) o 0 (FALSE)


#3.2
DELIMITER $$$$

CREATE PROCEDURE film_in_stock(
    IN p_film_id INT,       #ID de la película
    IN p_store_id INT,      #ID de la tienda
    OUT p_film_count INT    #Cantidad de copias disponibles (se guarda en este parámetro de salida)
)
BEGIN
    #Seleccionamos las copias disponibles (lista de inventory_id)
    SELECT i.inventory_id
    FROM inventory i
    LEFT JOIN rental r
      ON i.inventory_id = r.inventory_id
      AND r.return_date IS NULL   #Nos interesa solo los alquileres que no fueron devueltos
    WHERE i.film_id = p_film_id   #Filtro por la película que nos pasaron
      AND i.store_id = p_store_id #Filtro por la tienda que nos pasaron
      AND r.rental_id IS NULL;    #La copia no está alquilada actualmente

    #Guardamos en la variable de salida la cantidad de copias encontradas
    SELECT COUNT(*)
    INTO p_film_count
    FROM inventory i
    LEFT JOIN rental r
      ON i.inventory_id = r.inventory_id
      AND r.return_date IS NULL
    WHERE i.film_id = p_film_id
      AND i.store_id = p_store_id
      AND r.rental_id IS NULL;
END $$$$

DELIMITER ;

#Ejemplo
CALL film_in_stock(1, 1, @cantidad);  #Película 1 en tienda 1
SELECT @cantidad;                     #Muestra la cantidad de copias disponibles