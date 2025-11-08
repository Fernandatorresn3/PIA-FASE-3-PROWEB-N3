/* ============================================================
   Inserción de datos iniciales
   ============================================================ */

-- Insertar roles
INSERT INTO Roles (nombre_rol) VALUES 
('ROLE_USER'),
('ROLE_ADMIN');

-- Insertar estados de comentario
INSERT INTO Estados_Comentario (nombre_estado) VALUES 
('PENDIENTE'),
('APROBADO'),
('RECHAZADO');

-- Insertar algunas categorías iniciales
INSERT INTO Categorias (nombre_categoria) VALUES 
('Entradas'),
('Platos principales'),
('Postres'),
('Bebidas'),
('Ensaladas'),
('Sopas'),
('Vegetariano'),
('Vegano'),
('Sin gluten'),
('Repostería');

-- Insertar un usuario admin por defecto (contraseña: admin123)
-- Nota: Esta contraseña está hasheada con BCrypt
INSERT INTO Usuarios (nombre_usuario, email, contrasena, pais_residencia) VALUES 
('admin', 'admin@recipes.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'México');

-- Asignar rol de admin al usuario
INSERT INTO Usuario_Rol (id_usuario, id_rol) VALUES 
(1, 2);
