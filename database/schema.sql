-- Database Creation
CREATE DATABASE IF NOT EXISTS recipes_db;
USE recipes_db;

-- Table: roles
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Table: usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE
);

-- Table: usuario_roles (Many-to-Many)
CREATE TABLE IF NOT EXISTS usuario_roles (
    usuario_id BIGINT NOT NULL,
    rol_id BIGINT NOT NULL,
    PRIMARY KEY (usuario_id, rol_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Table: categorias
CREATE TABLE IF NOT EXISTS categorias (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion VARCHAR(500)
);

-- Table: recetas
CREATE TABLE IF NOT EXISTS recetas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    ingredientes TEXT,
    instrucciones TEXT,
    tiempo_preparacion INT,
    porciones INT,
    imagen_url VARCHAR(500),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT NOT NULL,
    categoria_id BIGINT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL
);

-- Table: estados_comentario
CREATE TABLE IF NOT EXISTS estados_comentario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Table: comentarios
CREATE TABLE IF NOT EXISTS comentarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT NOT NULL,
    receta_id BIGINT NOT NULL,
    estado_id BIGINT NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estados_comentario(id)
);

-- Table: calificaciones
CREATE TABLE IF NOT EXISTS calificaciones (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    puntuacion INT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5),
    fecha_calificacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT NOT NULL,
    receta_id BIGINT NOT NULL,
    UNIQUE KEY unique_user_recipe (usuario_id, receta_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE
);

-- Table: recetas_destacadas
CREATE TABLE IF NOT EXISTS recetas_destacadas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    receta_id BIGINT NOT NULL,
    fecha_destacado DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (receta_id) REFERENCES recetas(id) ON DELETE CASCADE
);

-- Insert default roles
INSERT INTO roles (nombre) VALUES ('user'), ('admin') ON DUPLICATE KEY UPDATE nombre=nombre;

-- Insert default comment statuses
INSERT INTO estados_comentario (nombre) VALUES ('pendiente'), ('aprobado'), ('rechazado') ON DUPLICATE KEY UPDATE nombre=nombre;

-- Insert default categories
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Desayunos', 'Recetas para el desayuno'),
    ('Almuerzos', 'Recetas para el almuerzo'),
    ('Cenas', 'Recetas para la cena'),
    ('Postres', 'Recetas de postres y dulces'),
    ('Bebidas', 'Recetas de bebidas y cócteles'),
    ('Vegetariano', 'Recetas vegetarianas'),
    ('Saludable', 'Recetas saludables y nutritivas')
ON DUPLICATE KEY UPDATE nombre=nombre;
