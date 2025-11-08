/* ============================================================
   Creación de la base de datos
   ============================================================ */
DROP DATABASE IF EXISTS RecetasDB;
CREATE DATABASE IF NOT EXISTS RecetasDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE RecetasDB;


/* ============================================================
   Nuevas Tablas de Lógica
   ============================================================ */

CREATE TABLE Roles (
	id_rol INT AUTO_INCREMENT PRIMARY KEY,
	nombre_rol VARCHAR(50) NOT NULL UNIQUE -- 'usuario', 'admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Estados_Comentario (
	id_estado INT AUTO_INCREMENT PRIMARY KEY,
	nombre_estado VARCHAR(50) NOT NULL UNIQUE -- 'Pendiente', 'Aprobado', 'Eliminado'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   Tabla: Usuarios
   ============================================================ */
CREATE TABLE Usuarios (
	id_usuario INT AUTO_INCREMENT PRIMARY KEY,
	nombre_usuario VARCHAR(80) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	contrasena VARCHAR(255) NOT NULL,
	foto_perfil_url VARCHAR(255),
	pais_residencia VARCHAR(100),
	estado_residencia VARCHAR(100),
	puesto_cocina VARCHAR(100),
	preferencia_categoria_receta VARCHAR(100),
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_usuario_nombre ON Usuarios(nombre_usuario);


/* ============================================================
   Tabla: Usuario_Rol
   ============================================================ */
CREATE TABLE Usuario_Rol (
	id_usuario_rol INT AUTO_INCREMENT PRIMARY KEY,
	id_usuario INT NOT NULL,
	id_rol INT NOT NULL,
	
	CONSTRAINT fk_usuariorol_usuario FOREIGN KEY (id_usuario)
		REFERENCES Usuarios(id_usuario)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_usuariorol_rol FOREIGN KEY (id_rol)
		REFERENCES Roles(id_rol)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT unique_usuario_rol UNIQUE (id_usuario, id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   Tabla: Categorias
   ============================================================ */
CREATE TABLE Categorias (
	id_categoria INT AUTO_INCREMENT PRIMARY KEY,
	nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   Tabla: Recetas
   ============================================================ */
CREATE TABLE Recetas (
	id_receta INT AUTO_INCREMENT PRIMARY KEY,
	id_usuario_admin INT NOT NULL,
	id_categoria INT NOT NULL,
	nombre_receta VARCHAR(70) NOT NULL,
	descripcion_corta VARCHAR(200),
	ingredientes JSON NOT NULL,
	pasos JSON NOT NULL,
	ingredientes_text TEXT,
	pais_origen VARCHAR(100),
	image_url VARCHAR(255),
	puntuacion_promedio FLOAT NOT NULL DEFAULT 0,
	fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_recetas_admin FOREIGN KEY (id_usuario_admin)
		REFERENCES Usuarios(id_usuario)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_recetas_categoria FOREIGN KEY (id_categoria)
		REFERENCES Categorias(id_categoria)
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_recetas_categoria ON Recetas(id_categoria);
CREATE INDEX idx_recetas_puntuacion ON Recetas(puntuacion_promedio);
CREATE INDEX idx_recetas_fecha ON Recetas(fecha_creacion);
CREATE FULLTEXT INDEX ft_recetas_busqueda
	ON Recetas(nombre_receta, descripcion_corta, ingredientes_text);


/* ============================================================
   Tabla: Comentarios
   ============================================================ */
CREATE TABLE Comentarios (
	id_comentario INT AUTO_INCREMENT PRIMARY KEY,
	id_receta INT NOT NULL,
	id_usuario INT NOT NULL,
	id_estado INT NOT NULL,
	contenido_comentario VARCHAR(500) NOT NULL,
	fecha_comentario DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_comentario_receta FOREIGN KEY (id_receta)
		REFERENCES Recetas(id_receta)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_comentario_usuario FOREIGN KEY (id_usuario)
		REFERENCES Usuarios(id_usuario)
		ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_comentario_estado FOREIGN KEY (id_estado)
		REFERENCES Estados_Comentario(id_estado)
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


/* ============================================================
   Tabla: Calificaciones
   ============================================================ */
CREATE TABLE Calificaciones (
	id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
	id_receta INT NOT NULL,
	id_usuario INT NOT NULL,
	puntuacion TINYINT NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_calificacion_receta FOREIGN KEY (id_receta)
		REFERENCES Recetas(id_receta)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_calificacion_usuario FOREIGN KEY (id_usuario)
		REFERENCES Usuarios(id_usuario)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT uq_calificacion_unica UNIQUE (id_receta, id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_calificaciones_receta ON Calificaciones(id_receta);


/* ============================================================
   Tabla: Recetas_Destacadas
   ============================================================ */
CREATE TABLE Recetas_Destacadas (
	id_usuario INT NOT NULL,
	id_receta INT NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (id_usuario, id_receta),
	
	CONSTRAINT fk_destacado_usuario FOREIGN KEY (id_usuario)
		REFERENCES Usuarios(id_usuario)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_destacado_receta FOREIGN KEY (id_receta)
		REFERENCES Recetas(id_receta)
		ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE INDEX idx_destacadas_usuario ON Recetas_Destacadas(id_usuario);
CREATE INDEX idx_destacadas_receta ON Recetas_Destacadas(id_receta);