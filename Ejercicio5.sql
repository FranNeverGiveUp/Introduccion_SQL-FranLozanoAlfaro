 /* Ejercicio 5
 1. Crea una tabla llamada "Clientes" con las columnas id (entero) y nombre 
(cadena de texto).
 2. Inserta un cliente con id=1 y nombre='John' en la tabla "Clientes".
 3. Actualiza el nombre del cliente con id=1 a 'John Doe' en la tabla "Clientes".
 3
 Ejercicios
4. Elimina el cliente con id=1 de la tabla "Clientes".
 5. Lee todos los clientes de la tabla "Clientes".
 6. Crea una tabla llamada "Pedidos" con las columnas id (entero) y cliente_id 
(entero).
 7. Inserta un pedido con id=1 y cliente_id=1 en la tabla "Pedidos".
 8. Actualiza el cliente_id del pedido con id=1 a 2 en la tabla "Pedidos".
 9. Elimina el pedido con id=1 de la tabla "Pedidos".
 10. Lee todos los pedidos de la tabla "Pedidos".
 11. Crea una tabla llamada "Productos" con las columnas id (entero) y nombre 
(cadena de texto).
 12. Inserta un producto con id=1 y nombre='Camisa' en la tabla "Productos".
 13. Actualiza el nombre del producto con id=1 a 'Pantalón' en la tabla "Productos".
 14. Elimina el producto con id=1 de la tabla "Productos".
 15. Lee todos los productos de la tabla "Productos".
 16. Crea una tabla llamada "DetallesPedido" con las columnas pedido_id (entero) y 
producto_id (entero).
 17. Inserta un detalle de pedido con pedido_id=1 y producto_id=1 en la tabla 
"DetallesPedido".
 18. Actualiza el producto_id del detalle de pedido con pedido_id=1 a 2 en la tabla 
"DetallesPedido".
 19. Elimina el detalle de pedido con pedido_id=1 de la tabla "DetallesPedido".
 20. Lee todos los detalles de pedido de la tabla "DetallesPedido".
 21. Realiza una consulta para obtener todos los clientes y sus pedidos 
correspondientes utilizando un inner join.
 22. Realiza una consulta para obtener todos los clientes y sus pedidos 
correspondientes utilizando un left join.
 23. Realiza una consulta para obtener todos los productos y los detalles de pedido 
correspondientes utilizando un inner join.
 24. Realiza una consulta para obtener todos los productos y los detalles de pedido 
correspondientes utilizando un left join.
 4
 Ejercicios
25. Crea una nueva columna llamada "telefono" de tipo cadena de texto en la tabla 
"Clientes".
 26. Modifica la columna "telefono" en la tabla "Clientes" para cambiar su tipo de 
datos a entero.
 27. Elimina la columna "telefono" de la tabla "Clientes".
 28. Cambia el nombre de la tabla "Clientes" a "Usuarios".
 29. Cambia el nombre de la columna "nombre" en la tabla "Usuarios" a 
"nombre_completo".
 30. Agrega una restricción de clave primaria a la columna "id" en la tabla "Usuarios".*/

/*Punto 1*/
CREATE TABLE Clientes (
	id INT PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL
)

/*Punto 2*/
INSERT INTO Clientes (id, nombre)
VALUES (1, 'John');

/*Punto 3*/
UPDATE Clientes
SET nombre = 'John Doe'
WHERE id = 1;

/*Punto 4*/
DELETE FROM Clientes
WHERE id = 1;

/*Punto 5*/
SELECT nombre
FROM Clientes;

/*Punto 6*/
CREATE TABLE Pedidos (
	id INT PRIMARY KEY,
	cliente_id INT NOT NULL
);

/*Punto 7*/
INSERT INTO Pedidos (id, cliente_id)
VALUES (1, 1);

/*Punto 8*/
UPDATE Pedidos
SET cliente_id = 2
WHERE id =1;

/*Punto 9*/
DELETE FROM Pedidos
WHERE id = 1;

/*Punto 10*/
SELECT *
FROM Pedidos;

/*Punto 11*/
CREATE TABLE Productos (
	id INT PRIMARY KEY,
	nombre VARCHAR(255)
);

/*Punto 12*/
INSERT INTO Productos (id, nombre)
VALUES (1, 'Camisa')

/*Punto 13*/
UPDATE Productos
SET nombre = 'Pantalón'
WHERE id = 1;

/*Punto 14*/
DELETE FROM Productos
WHERE id = 1;

/*Punto 15*/
SELECT nombre
FROM Productos;

/*Punto 16*/
CREATE TABLE DetallesPedido (
	pedido_id INT PRIMARY KEY,
	producto_id INT NOT NULL
);

/*Punto 17*/
INSERT INTO DetallesPedido (pedido_id, producto_id)
VALUES (1, 1);

/*Punto 18*/
UPDATE DetallesPedido
SET producto_id = 2
WHERE pedido_id = 1;

/*Punto 19*/
DELETE FROM DetallesPedido
WHERE pedido_id = 1;

/*Punto 20*/
SELECT *
FROM DetallesPedido;

/*Punto 21*/
/*Antes tenemos que generar la clave externa en Pedidos con Clientes*/
ALTER TABLE Pedidos
ADD FOREIGN KEY (cliente_id) REFERENCES Clientes(id);

SELECT Clientes.nombre, Pedidos.id as Id_pedido
FROM Clientes
INNER JOIN Pedidos
ON pedidos.cliente_id = clientes.id
ORDER BY clientes.nombre ASC;

/*Punto 22*/
SELECT Clientes.nombre, Pedidos.id as Id_pedido
FROM Clientes
LEFT JOIN Pedidos
ON pedidos.cliente_id = clientes.id
ORDER BY clientes.nombre ASC;

/*Punto 23*/
/*Antes tenemos que generar la clave externa en DetallesPedido con Productos*/
ALTER TABLE DetallesPedido
ADD FOREIGN KEY (producto_id) REFERENCES productos(id);

SELECT Productos.nombre, DetallesPedido.pedido_id
FROM Productos
INNER JOIN DetallesPedido
ON DetallesPedido.producto_id = Productos.id
ORDER BY Productos.nombre ASC;

/*Punto 24*/
SELECT Productos.nombre, DetallesPedido.pedido_id
FROM Productos
LEFT JOIN DetallesPedido
ON DetallesPedido.producto_id = Productos.id
ORDER BY Productos.nombre ASC;

/*Punto 25*/
ALTER TABLE Clientes
ADD COLUMN telefono VARCHAR(255);

/*Punto 26*/
ALTER TABLE Clientes
ALTER COLUMN telefono TYPE INT USING telefono::INTEGER;

/*Punto 27*/
ALTER TABLE Clientes
DROP COLUMN telefono;

/*Punto 28*/
ALTER TABLE Clientes RENAME TO Usuarios;

/*Punto 29*/
ALTER TABLE Usuarios
RENAME COLUMN nombre TO Usuarios;

/*Punto 30*/
/*Como el campo id ya posee una restricción de clave primaria, la vamos a
eliminar junto con su relación de índice en la columna a partir de CASCADE.
Después la volvemos a añadir*/
ALTER TABLE Usuarios
DROP CONSTRAINT clientes_pkey CASCADE;

ALTER TABLE Usuarios
ADD CONSTRAINT id_pkey PRIMARY KEY (id);