
-- Tabla de Dimensión: Tiempo
CREATE TABLE dim_tiempo (
    id_tiempo INT PRIMARY KEY,
    año INT,
    mes INT,
    dia INT,
    trimestre INT
);

-- Tabla de Dimensión: Libro
CREATE TABLE dim_libro (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100),
    autor VARCHAR(100),
    genero VARCHAR(50),
    precio_unitario DECIMAL(10, 2)
);

-- Tabla de Dimensión: Cliente
CREATE TABLE dim_cliente (
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    edad INT,
    genero CHAR(1),
    ciudad VARCHAR(100)
);

-- Tabla de Dimensión: Tienda
CREATE TABLE dim_tienda (
    id_tienda INT PRIMARY KEY,
    nombre_tienda VARCHAR(100),
    ciudad VARCHAR(100),
    pais VARCHAR(100)
);

-- Tabla de Hechos: Ventas de Libros
CREATE TABLE hechos_ventas_libros (
    id_venta INT PRIMARY KEY,
    id_tiempo INT,
    id_libro INT,
    id_cliente INT,
    id_tienda INT,
    cantidad INT,
    precio_total DECIMAL(10, 2),
    FOREIGN KEY (id_tiempo) REFERENCES dim_tiempo(id_tiempo),
    FOREIGN KEY (id_libro) REFERENCES dim_libro(id_libro),
    FOREIGN KEY (id_cliente) REFERENCES dim_cliente(id_cliente),
    FOREIGN KEY (id_tienda) REFERENCES dim_tienda(id_tienda)
);

-- Insertar datos en dim_tiempo
INSERT INTO dim_tiempo (id_tiempo, año, mes, dia, trimestre) VALUES
(1, 2023, 1, 15, 1),
(2, 2023, 2, 10, 1),
(3, 2023, 3, 5, 1);

-- Insertar datos en dim_libro
INSERT INTO dim_libro (id_libro, titulo, autor, genero, precio_unitario) VALUES
(1, 'Cien Años de Soledad', 'Gabriel García Márquez', 'Novela', 15.50),
(2, '1984', 'George Orwell', 'Distopía', 12.00),
(3, 'El Quijote', 'Miguel de Cervantes', 'Clásico', 18.75),
(4, 'Donde los Árboles Cantan', 'Laura Gallego', 'Fantasía', 9.99),
(5, 'Harry Potter y la Piedra Filosofal', 'J.K. Rowling', 'Fantasía', 14.50);

-- Insertar datos en dim_cliente
INSERT INTO dim_cliente (id_cliente, nombre_cliente, edad, genero, ciudad) VALUES
(1, 'Ana Martínez', 34, 'F', 'Madrid'),
(2, 'Carlos López', 28, 'M', 'Barcelona'),
(3, 'María Gómez', 45, 'F', 'Valencia'),
(4, 'José Ramírez', 51, 'M', 'Sevilla'),
(5, 'Lucía Fernández', 30, 'F', 'Zaragoza');

-- Insertar datos en dim_tienda
INSERT INTO dim_tienda (id_tienda, nombre_tienda, ciudad, pais) VALUES
(1, 'Librería Central', 'Madrid', 'España'),
(2, 'Libros del Sur', 'Barcelona', 'España'),
(3, 'Lecturas Vivas', 'Valencia', 'España');

-- Insertar datos en hechos_ventas_libros
INSERT INTO hechos_ventas_libros (id_venta, id_tiempo, id_libro, id_cliente, id_tienda, cantidad, precio_total) VALUES
(1, 1, 1, 1, 1, 2, 31.00),
(2, 1, 2, 2, 2, 1, 12.00),
(3, 1, 3, 3, 3, 1, 18.75),
(4, 2, 4, 4, 1, 3, 29.97),
(5, 2, 5, 5, 2, 1, 14.50),
(6, 2, 1, 1, 1, 2, 31.00),
(7, 3, 2, 2, 3, 2, 24.00),
(8, 3, 3, 3, 1, 1, 18.75),
(9, 3, 4, 4, 2, 2, 19.98),
(10, 3, 5, 5, 3, 3, 43.50);

--Consulta 1: Total de ventas (precio_total) por género de libro y mes

SELECT 
    l.genero,
    t.mes,
    SUM(h.precio_total) AS total_ventas
FROM 
    hechos_ventas_libros h
JOIN 
    dim_libro l ON h.id_libro = l.id_libro
JOIN 
    dim_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY 
    l.genero, t.mes
ORDER BY 
    t.mes, l.genero;
	
	-- Consulta 2: Cantidad total de libros vendidos por tienda y autor
	
	SELECT 
    ti.nombre_tienda,
    l.autor,
    SUM(h.cantidad) AS total_libros_vendidos
FROM 
    hechos_ventas_libros h
JOIN 
    dim_libro l ON h.id_libro = l.id_libro
JOIN 
    dim_tienda ti ON h.id_tienda = ti.id_tienda
GROUP BY 
    ti.nombre_tienda, l.autor
ORDER BY 
    ti.nombre_tienda, total_libros_vendidos DESC;
	
--Consulta 3: Ingresos totales por ciudad de cliente y trimestre

SELECT 
    c.ciudad,
    t.trimestre,
    SUM(h.precio_total) AS ingresos_totales
FROM 
    hechos_ventas_libros h
JOIN 
    dim_cliente c ON h.id_cliente = c.id_cliente
JOIN 
    dim_tiempo t ON h.id_tiempo = t.id_tiempo
GROUP BY 
    c.ciudad, t.trimestre
ORDER BY 
    c.ciudad, t.trimestre;
	
-- Consulta 4: Total de ventas de cada cliente (precio_total acumulado) y número de libros comprados

SELECT 
    c.nombre_cliente,
    SUM(h.precio_total) AS total_gasto,
    SUM(h.cantidad) AS total_libros_comprados
FROM 
    hechos_ventas_libros h
JOIN 
    dim_cliente c ON h.id_cliente = c.id_cliente
GROUP BY 
    c.nombre_cliente
ORDER BY 
    total_gasto DESC;




