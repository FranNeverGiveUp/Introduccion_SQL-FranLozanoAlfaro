/* Ejercicio 4
 Nivel de dificultad: Experto
 1. Crea una tabla llamada "Pedidos" con las columnas: "id" (entero, clave 
primaria), "id_usuario" (entero, clave foránea de la tabla "Usuarios") y 
"id_producto" (entero, clave foránea de la tabla "Productos").
 2. Inserta al menos tres registros en la tabla "Pedidos" que relacionen usuarios con 
productos.
 3. Realiza una consulta que muestre los nombres de los usuarios y los nombres de 
los productos que han comprado, incluidos aquellos que no han realizado 
ningún pedido (utiliza LEFT JOIN y COALESCE).
 4. Realiza una consulta que muestre los nombres de los usuarios que han 
realizado un pedido, pero también los que no han realizado ningún pedido 
(utiliza LEFT JOIN).
 5. Agrega una nueva columna llamada "cantidad" a la tabla "Pedidos" y actualiza 
los registros existentes con un valor (utiliza ALTER TABLE y UPDATE)*/

/*Punto 1*/
/*La tabla que se nos pide ahora crear de Pedidos la generamos en el Ejercicio 3
como tabla Compras para solucionar el Punto 5. Vamos a renombrar dicha tabla
de Compras a Pedidos*/
ALTER TABLE compras RENAME TO pedidos;
/*Las claves foráneas también se añadieron en el momento de crear Pedidos:*/
CREATE TABLE Compras (
	id SERIAL PRIMARY KEY,
	usuario_id INT NOT NULL,
	producto_id INT NOT NULL,
	cantidad INT NOT NULL,
	FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
	FOREIGN KEY (producto_id) REFERENCES productos(id)
);

/*Punto 2*/
/*Hecho en el ejercicio 3*/
INSERT INTO Compras (usuario_id, producto_id, cantidad)
VALUES (2, 1, 2),
		(2, 3, 3),
		(2, 5, 1),
		(3, 6, 2),
		(3, 10, 1),
		(4, 7, 1),
		(4, 9, 1);
		
/*Punto 3*/
/*Como actualmente todos los usuarios han realizado algún pedido, vamos a 
añadir a un par más de usuarios más que no tengan ningún pedido asociado*/
INSERT INTO Usuarios (nombre, edad, ciudad_id)
VALUES ('Mehmet', 54, 5),
		('Nicolas', 38, 4);
		
/*Consulta: Nombre de usuario, nombre de productos o sin productos*/
SELECT usuarios.nombre, COALESCE(productos.nombre, '//No hay pedido//') AS nombre_producto
FROM usuarios
LEFT JOIN pedidos
ON pedidos.usuario_id = usuarios.id
LEFT JOIN productos
ON pedidos.producto_id = productos.id
ORDER BY usuarios.nombre ASC;

/*Punto 4*/
/*Consulta: Nombre de usuarios con o sin pedido*/
SELECT usuarios.nombre, COUNT(pedidos.id) AS Num_pedidos 
FROM usuarios
LEFT JOIN pedidos
ON pedidos.usuario_id = usuarios.id
GROUP BY usuarios.nombre
ORDER BY usuarios.nombre ASC;

/*Punto 5*/
/*Como ya agregué esta columna en el ejercicio 3, primero la voy a eliminar.
Pero antes, me guardo los valores actuales de id y cantidad*/
/*(id, cantidad)
1	2
2	3
3	1
4	2
5	1
6	1
7	1*/
ALTER TABLE pedidos
DROP COLUMN cantidad;

/*Añadimos la columna*/
ALTER TABLE pedidos
ADD COLUMN cantidad DECIMAL;

/*Rellenamos la columna*/
UPDATE pedidos
SET cantidad = temporal.cantidades
FROM (VALUES 
	(1,	2),
	(2,	3),
	(3, 1),
	(4, 2),
	(5, 1),
	(6, 1),
	(7, 1)) AS temporal(id, cantidades)
WHERE temporal.id = pedidos.id;
/*Y ahora que tenemos valores de nuevo en la columna cantidad, la hacemos
NOT NULL*/
ALTER TABLE pedidos
ALTER COLUMN cantidad SET NOT NULL;