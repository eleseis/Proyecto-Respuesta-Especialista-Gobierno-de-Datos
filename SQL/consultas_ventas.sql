-- ===============================================
-- CREACIÓN DE TABLAS Y CARGA DE DATOS
-- ===============================================

-- 1. Crear tabla de clientes
DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(150),
    ciudad VARCHAR(100)
);

-- 2. Crear tabla de productos
DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(150),
    categoria VARCHAR(100),
    precio DECIMAL(10,2)
);

-- 3. Crear tabla de ventas
-- (Supuesto que existe una relación entre clientes y productos)
DROP TABLE IF EXISTS ventas;
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    fecha DATE,
    cantidad INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ===============================================
-- CARGA DE DATOS DESDE CSV
-- ===============================================

-- Para PostgreSQL:
-- COPY clientes FROM 'C:\Users\User\Desktop\Respuesta Ejercicio Gobierno de Datos\SQL/clientes.csv' DELIMITER ',' CSV HEADER;
-- COPY productos FROM 'C:\Users\User\Desktop\Respuesta Ejercicio Gobierno de Datos\SQL/productos.csv' DELIMITER ',' CSV HEADER;

-- Para MySQL:
-- LOAD DATA INFILE '/ruta/clientes.csv'
-- INTO TABLE clientes
-- FIELDS TERMINATED BY ','
-- IGNORE 1 LINES;

-- LOAD DATA INFILE '/ruta/productos.csv'
-- INTO TABLE productos
-- FIELDS TERMINATED BY ','
-- IGNORE 1 LINES;

-- ===============================================
-- CONSULTAS SOLICITADAS
-- ===============================================

-- 1. Clientes con más de 3 compras
SELECT 
    c.id_cliente,
    c.nombre,
    COUNT(v.id_venta) AS total_compras
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(v.id_venta) > 3
ORDER BY total_compras DESC;

-- 2. Top 5 de productos más vendidos
SELECT 
    p.id_producto,
    p.nombre_producto,
    SUM(v.cantidad) AS total_vendido
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre_producto
ORDER BY total_vendido DESC
LIMIT 5;

-- 3. Ventas totales por categoría de producto
SELECT 
    p.categoria,
    SUM(v.cantidad * p.precio) AS total_ventas
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto
GROUP BY p.categoria
ORDER BY total_ventas DESC;
