/*Ejercicio 3
1. Crea una tabla llamada "Productos" con las columnas: "id" (entero, clave 
primaria), "nombre" (texto) y "precio" (numérico).
 2. Inserta al menos cinco registros en la tabla "Productos".
 3. Actualiza el precio de un producto en la tabla "Productos".
 4. Elimina un producto de la tabla "Productos".
 5. Realiza una consulta que muestre los nombres de los usuarios junto con los 
nombres de los productos que han comprado (utiliza un INNER JOIN con la 
tabla "Productos").*/

/*Punto 1*/
CREATE TABLE Productos (
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	precio DECIMAL NOT NULL
)

/*Punto 2*/
INSERT INTO Productos (nombre, precio)
VALUES ('Leche de fórmula Capricare 1',	32.95),
		('Biberón de cristal 150ml', 21.43),
		('Chupete Suavinex 0-3 meses', 12.21),
		('Mochila de porteo Stokke', 149.95),
		('Carrito de bebé Jane', 429.95),
		('Camiseta', 17.70),
		('Pantalón', 19.90),
		('Pares de calcetines', 1.99),
		('Chaqueta', 39.40),
		('Set x6 ropa interior', 17.87);
		
/*Punto 3*/
UPDATE Productos
SET precio = 16.49
WHERE nombre = 'Set x6 ropa interior';

/*Punto 4*/
DELETE FROM Productos
WHERE nombre = 'Pares de calcetines';

/*Punto 5*/
/*La tabla de usuarios no puede tener id's de usuario repetidos, por lo que
todos los productos comprados por un usuario han de registrarse en otra
tabla que llamaremos compras. Creamos la tabla y la clave foránea con usuarios
y con la tabla productos*/
CREATE TABLE Compras (
	id SERIAL PRIMARY KEY,
	usuario_id INT NOT NULL,
	producto_id INT NOT NULL,
	cantidad INT NOT NULL,
	FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
	FOREIGN KEY (producto_id) REFERENCES productos(id)
);
/*Vamos a añadir a un par de usuarios más*/
INSERT INTO usuarios (nombre, edad, ciudad_id)
VALUES ('Claudia', 22, 3),
		('Carlos', 25, 3);

/*Vamos a añadir algunos productos comprados para cada usuario en compras*/
INSERT INTO Compras (usuario_id, producto_id, cantidad)
VALUES (2, 1, 2),
		(2, 3, 3),
		(2, 5, 1),
		(3, 6, 2),
		(3, 10, 1),
		(4, 7, 1),
		(4, 9, 1);

/*Nombres de usuario y productos que han comprado*/
SELECT usuarios.nombre, productos.nombre
FROM usuarios
INNER JOIN compras
ON usuarios.id = compras.usuario_id 
INNER JOIN productos
ON compras.producto_id = productos.id
GROUP BY usuarios.nombre, productos.nombre
ORDER BY usuarios.nombre ASC, productos.nombre ASC;

