CREATE DATABASE IF NOT EXISTS bookstore CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bookstore;

--  Usuarios
CREATE TABLE usuarios (
    usuarioId INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    correo VARCHAR(100) UNIQUE,
    clave VARCHAR(255),
    tipo ENUM('cliente', 'admin') DEFAULT 'cliente',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    creadoEn DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Libros
CREATE TABLE libros (
    libroId INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255),
    autor VARCHAR(255),
    genero VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2),
    imagenUrl VARCHAR(255),
    destacado BOOLEAN DEFAULT 0,
    creadoEn DATETIME DEFAULT CURRENT_TIMESTAMP
);

--  Carrito (temporal por sesión)
CREATE TABLE carrito (
    carritoId INT AUTO_INCREMENT PRIMARY KEY,
    usuarioId INT,
    libroId INT,
    cantidad INT DEFAULT 1,
    agregadoEn DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuarioId) REFERENCES usuarios(usuarioId),
    FOREIGN KEY (libroId) REFERENCES libros(libroId)
);

-- Transacciones
CREATE TABLE transacciones (
    transaccionId INT AUTO_INCREMENT PRIMARY KEY,
    usuarioId INT,
    total DECIMAL(10,2),
    estado ENUM('pagado', 'fallido') DEFAULT 'pagado',
    metodoPago VARCHAR(50),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuarioId) REFERENCES usuarios(usuarioId)
);

--  Detalle de Transacciones
CREATE TABLE transaccion_detalle (
    detalleId INT AUTO_INCREMENT PRIMARY KEY,
    transaccionId INT,
    libroId INT,
    cantidad INT,
    precioUnitario DECIMAL(10,2),
    FOREIGN KEY (transaccionId) REFERENCES transacciones(transaccionId),
    FOREIGN KEY (libroId) REFERENCES libros(libroId)
);

-- Usuario Admin de prueba
INSERT INTO usuarios (nombre, correo, clave, tipo)
VALUES ('Admin', 'admin@libros.com', SHA2('admin123', 256), 'admin');


--  Usuarios de prueba
INSERT INTO usuarios (nombre, correo, clave, tipo) VALUES
('Admin', 'admin@libros.com', SHA2('admin123', 256), 'admin'),
('Juan Pérez', 'juan@correo.com', SHA2('juan123', 256), 'cliente'),
('Ana Torres', 'ana@correo.com', SHA2('ana123', 256), 'cliente');

--  Libros de prueba
INSERT INTO libros (titulo, autor, genero, descripcion, precio, imagenUrl, destacado) VALUES
('El Alquimista', 'Paulo Coelho', 'Ficción', 'Un joven pastor en busca de su leyenda personal.', 300.00, 'img/el-alquimista.jpg', 1),
('1984', 'George Orwell', 'Distopía', 'Una crítica al totalitarismo y el control social.', 250.00, 'img/1984.jpg', 1),
('Cien Años de Soledad', 'Gabriel García Márquez', 'Realismo Mágico', 'La historia de la familia Buendía en Macondo.', 400.00, 'img/cien-anos.jpg', 0),
('El Principito', 'Antoine de Saint-Exupéry', 'Fábula', 'Un niño que vive en un pequeño planeta y viaja por el universo.', 200.00, 'img/el-principito.jpg', 1),
('Don Quijote de la Mancha', 'Miguel de Cervantes', 'Clásico', 'La aventura del caballero Don Quijote y Sancho Panza.', 500.00, 'img/don-quijote.jpg', 0),
('La Sombra del Viento', 'Carlos Ruiz Zafón', 'Misterio', 'Un libro olvidado que cambia la vida del joven Daniel.', 350.00, 'img/sombra-viento.jpg', 0),
('Los Juegos del Hambre', 'Suzanne Collins', 'Ciencia Ficción', 'Una sociedad distópica donde adolescentes deben luchar.', 320.00, 'img/juegos-hambre.jpg', 1),
('Orgullo y Prejuicio', 'Jane Austen', 'Romance', 'El amor entre Elizabeth Bennet y el Sr. Darcy.', 275.00, 'img/orgullo-prejuicio.jpg', 0);

--  Carrito de ejemplo para Juan (usuarioId = 2)
INSERT INTO carrito (usuarioId, libroId, cantidad) VALUES
(2, 1, 1),
(2, 4, 2);

--  Transacción simulada para Ana (usuarioId = 3)
INSERT INTO transacciones (usuarioId, total, estado, metodoPago) VALUES
(3, 950.00, 'pagado', 'paypal');

--  Detalles de transacción
INSERT INTO transaccion_detalle (transaccionId, libroId, cantidad, precioUnitario) VALUES
(1, 2, 1, 250.00),
(1, 3, 1, 400.00),
(1, 4, 1, 200.00),
(1, 8, 1, 100.00);