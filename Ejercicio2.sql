/* Ejercicio 2
 Nivel de dificultad: Fácil
 1. Crea una base de datos llamada "MiBaseDeDatos".
 2. Crea una tabla llamada "Usuarios" con las columnas: "id" (entero, clave 
primaria), "nombre" (texto) y "edad" (entero).
 3. Inserta dos registros en la tabla "Usuarios".
 4. Actualiza la edad de un usuario en la tabla "Usuarios".
 5. Elimina un usuario de la tabla "Usuarios".
 Nivel de dificultad: Moderado
 1. Crea una tabla llamada "Ciudades" con las columnas: "id" (entero, clave 
primaria), "nombre" (texto) y "pais" (texto).
 2. Inserta al menos tres registros en la tabla "Ciudades".
 3. Crea una foreign key en la tabla "Usuarios" que se relacione con la columna "id" 
de la tabla "Ciudades".
 4. Realiza una consulta que muestre los nombres de los usuarios junto con el 
nombre de su ciudad y país (utiliza un LEFT JOIN).
 5. Realiza una consulta que muestre solo los usuarios que tienen una ciudad 
asociada (utiliza un INNER JOIN).*/

/*Punto 2*/
CREATE TABLE Usuarios (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	edad INT NOT NULL
)

/*Punto 3*/
INSERT INTO Usuarios (nombre, edad)
VALUES ('Fran', 36),
		('Ana', 34);

/*Punto 4*/
UPDATE Usuarios
SET edad = 35
WHERE nombre = 'Ana';

/*Punto 5*/
DELETE FROM Usuarios
WHERE nombre = 'Fran';

/*Nivel de dificultad: Moderado*/
/*Punto 1*/
CREATE TABLE Ciudades (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	pais VARCHAR(255) NOT NULL
)

/*Punto 2*/
INSERT INTO Ciudades (nombre, pais)
VALUES ('Madrid', 'España'),
		('Roma', 'Italia'),
		('Berlín', 'Alemania');

/*Punto 3*/
/*Antes de poder generar la clave externa hay que crear una columna en la
tabla usuarios con el id de la ciudad (ciudad_id)*/
ALTER TABLE Usuarios
ADD COLUMN ciudad_id INT;

ALTER TABLE Usuarios
ADD CONSTRAINT fk_ciudad_id FOREIGN KEY (ciudad_id) REFERENCES Ciudades(id);

/*Punto 4*/
/*Primero vamos asignarle una ciudad al usuario actual de la tabla usuarios*/
UPDATE Usuarios
SET ciudad_id = 3
WHERE nombre = 'Ana';

SELECT
	usuarios.nombre,
	ciudades.nombre,
	ciudades.pais
FROM usuarios
LEFT JOIN ciudades
ON usuarios.ciudad_id = ciudades.id
ORDER BY usuarios.nombre ASC;

/*Punto 5*/
SELECT
	usuarios.nombre
FROM usuarios
INNER JOIN ciudades
ON usuarios.ciudad_id = ciudades.id
WHERE usuarios.ciudad_id IS NOT NULL
ORDER BY usuarios.nombre ASC;