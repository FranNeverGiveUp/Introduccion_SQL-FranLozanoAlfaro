/* Ejercicio 1
 1. Crear una tabla llamada "Clientes" con las columnas: id (entero, clave primaria), 
nombre (texto) y email (texto).
 2. Insertar un nuevo cliente en la tabla "Clientes" con id=1, nombre="Juan" y 
email="
 juan@example.com".
 3. Actualizar el email del cliente con id=1 a "
 juan@gmail.com".
 4. Eliminar el cliente con id=1 de la tabla "Clientes".
 5. Crear una tabla llamada "Pedidos" con las columnas: id (entero, clave primaria), 
cliente_id (entero, clave externa referenciando a la tabla "Clientes"), producto 
(texto) y cantidad (entero).
 6. Insertar un nuevo pedido en la tabla "Pedidos" con id=1, cliente_id=1, 
producto="Camiseta" y cantidad=2.
 7. Actualizar la cantidad del pedido con id=1 a 3.
 8. Eliminar el pedido con id=1 de la tabla "Pedidos".
 9. Crear una tabla llamada "Productos" con las columnas: id (entero, clave 
primaria), nombre (texto) y precio (decimal).
 10. Insertar varios productos en la tabla "Productos" con diferentes valores.
 11. Consultar todos los clientes de la tabla "Clientes".
 12. Consultar todos los pedidos de la tabla "Pedidos" junto con los nombres de los 
clientes correspondientes.
 13. Consultar los productos de la tabla "Productos" cuyo precio sea mayor a $50.
 14. Consultar los pedidos de la tabla "Pedidos" que tengan una cantidad mayor o 
igual a 5.
 15. Consultar los clientes de la tabla "Clientes" cuyo nombre empiece con la letra 
"A".
16. Realizar una consulta que muestre el nombre del cliente y el total de pedidos 
realizados por cada cliente.
 17. Realizar una consulta que muestre el nombre del producto y la cantidad total de 
pedidos de ese producto.
 18. Agregar una columna llamada "fecha" a la tabla "Pedidos" de tipo fecha.
 19. Agregar una clave externa a la tabla "Pedidos" que haga referencia a la tabla 
"Productos" en la columna "producto".
 20. Realizar una consulta que muestre los nombres de los clientes, los nombres de 
los productos y las cantidades de los pedidos donde coincida la clave externa. */

/*Punto 1*/
CREATE TABLE Clientes(
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(255),
	email VARCHAR(255)
);

/*Punto 2*/
INSERT INTO Clientes(id, nombre, email)
VALUES (1, 'Juan', 'juan@example.com');

/*Punto 3*/
UPDATE Clientes
SET email = 'juan@gmail.com'
WHERE id = 1;

/*Punto 4*/
DELETE FROM Clientes
WHERE id = 1;

/*Punto 5*/
CREATE TABLE Pedidos(
	id SERIAL PRIMARY KEY,
	cliente_id INT NOT NULL, 
	producto VARCHAR(255) NOT NULL,
	cantidad INT NOT NULL,
	CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES clientes(id)
	/* He optado por generar la clave foránea generando la restricción
	explícitamente, pero también se podría generar la clave externa
	directamente a partir de FOREIGN KEY:
	FOREIGN KEY (cliente_id) REFERENCES clientes(id)*/
)

/*Punto 6*/
/*En el punto 4 se solicitó eliminar el único registro que tenía la tabla de
clientes. Lo vuelvo a crear para que exista el registro cliente.id =1*/
INSERT INTO Clientes(id, nombre, email)
VALUES (1, 'Juan', 'juan@gmail.com');

INSERT INTO Pedidos (id, cliente_id, producto, cantidad)
VALUES (1, 1, 'Camiseta', 2);

/*Punto 7*/
UPDATE Pedidos
SET cantidad = 3
WHERE id = 1;

/*Punto 8*/
DELETE FROM Pedidos
WHERE id = 1;

/*Punto 9*/
CREATE TABLE Productos(
	id SERIAL PRIMARY KEY,
	nombre VARCHAR(255) NOT NULL,
	precio DECIMAL NOT NULL
);

/*Punto 10*/
INSERT INTO Productos (nombre, precio)
VALUES ('Leche de fórmula Capricare 1', 32.95),
		('Biberón de cristal 150ml', 21.43),
		('Chupete Suavinex 0-3 meses', 12.21);

/*Punto 11*/
SELECT * FROM Clientes;

/*Punto 12*/
/* Nuevamente hay que volver a insertar un pedido en la tabla pedidos, dado
quen en el punto 8 se pidió eliminar el registro que teníamos en pedidos*/
INSERT INTO Pedidos (id, cliente_id, producto, cantidad)
VALUES (1, 1, 'Camiseta', 2);

SELECT
	pedidos.id as Id_Pedido,
	pedidos.cliente_id as Id_cliente,
	clientes.id as Id_cliente_pedidos,
	clientes.nombre as Cliente,
	pedidos.producto as Producto,
	pedidos.cantidad as Cantidad
FROM Public.Pedidos pedidos
LEFT JOIN Public.Clientes clientes
ON pedidos.cliente_id = clientes.id;

/*Punto 13*/
/*Primero insertamos un par de productos en productos superiores a 50 euros*/
INSERT INTO Productos (nombre, precio)
VALUES ('Mochila de porteo Stokke', 149.95),
		('Carrito de bebé Jane', 429.95);
		
SELECT * FROM Productos
WHERE precio > 50;

/*Punto 14*/
SELECT * FROM pedidos
WHERE cantidad > 5;

/*Punto 15*/
SELECT nombre FROM clientes
WHERE nombre LIKE 'A%';

/*Punto 16*/
INSERT INTO Pedidos (cliente_id, producto, cantidad)
VALUES (1, 'Pares de calcetines', 7),
		(1, 'Chaqueta', 1),
		(1, 'Set x6 ropa interior', 2);

SELECT
	nombre as Cliente,
	COUNT(pedidos.id) as Total_pedidos
FROM Public.clientes clientes
LEFT JOIN Public.pedidos pedidos
ON pedidos.cliente_id = clientes.id
GROUP BY clientes.nombre;

/*Punto 17*/
/*Primero hay que añadir una columna a la tabla pedidos con un id de producto*/
ALTER TABLE Public.Pedidos
ADD COLUMN producto_id INT;

/*Generamos la clave externa entre pedidos y productos*/
ALTER TABLE Public.Pedidos
ADD CONSTRAINT fk_producto_id FOREIGN KEY (producto_id) REFERENCES Public.Productos(id);

/*Actualizar el listado de productos en la tabla productos con aquellos
productos que hemos ido añadiendo previamente a la tabla de pedidos y
rellenar el campo de product_id:
'Camiseta'
'Pantalón'
'Pares de calcetines'
'Chaqueta'
'Set x6 ropa interior'
'Pares de calcetines'*/
INSERT INTO Productos (nombre, precio)
VALUES ('Camiseta', 17.70),
		('Pantalón', 19.90),
		('Pares de calcetines', 1.99),
		('Chaqueta', 39.40),
		('Set x6 ropa interior', 17.87);

UPDATE Public.Pedidos pedidos
SET producto_id = productos.id
FROM Public.Productos productos
WHERE pedidos.producto = productos.nombre;

/*Hacemos el campo producto_id NOT NULL en pedidos*/
ALTER TABLE Pedidos
ALTER COLUMN producto_id SET NOT NULL;

SELECT productos.nombre as Nombre_producto,
		COUNT(pedidos.id) as Num_total_pedidos
FROM Public.Productos productos
INNER JOIN Public.Pedidos pedidos
ON pedidos.producto_id = productos.id
GROUP BY Nombre_producto;

/*Punto 18*/
ALTER TABLE Pedidos
ADD COLUMN fecha DATE;

UPDATE Pedidos
SET fecha = '11-11-1111'
WHERE fecha IS NULL;

ALTER TABLE Pedidos
ALTER COLUMN fecha SET NOT NULL;

/*Punto 19  - Agregar una clave externa a la tabla "Pedidos" que haga referencia
a la tabla "Productos" en la columna "producto".*/
/*No es correcto realizarlo así, dado que en una tabla de pedidos pueden haber
más de 1 pedido con el mismo valor en el campo "producto", de modo que no es
un campo válido para añadir una clave externa a la tabla pedidos que la relacione
con la tabla producto. En su defecto, para la resolución del punto 17, se añadió
el campo producto_id en la tabla de pedidos y se añadió la clave en este campo*/
ALTER TABLE Public.Pedidos
ADD CONSTRAINT fk_producto_id FOREIGN KEY (producto_id) REFERENCES Public.Productos(id);

/*Punto 20*/
/*El enunciado es bastante ambiguo*/
/*Consulta: Nombres de los clientes (en tabla clientes)
			Nombres de los productos (en tabla pedidos)
			Cantidades de los pedidos (también en tabla pedidos)*/
SELECT clientes.nombre, pedidos.producto, pedidos.cantidad
FROM Public.Clientes clientes
LEFT JOIN Public.Pedidos pedidos
ON clientes.id = pedidos.cliente_id
GROUP BY nombre, producto, cantidad;