/* ============================================================
   Script de población de datos de prueba para RecetasDB
   ============================================================ */

USE RecetasDB;

-- Insertar usuarios adicionales (contraseña para todos: password123)
INSERT INTO Usuarios (nombre_usuario, email, contrasena, foto_perfil_url, pais_residencia, estado_residencia, puesto_cocina, preferencia_categoria_receta) VALUES 
('Maria Garcia', 'maria@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', NULL, 'México', 'CDMX', 'Chef Profesional', 'Platos principales'),
('Juan Perez', 'juan@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', NULL, 'España', 'Madrid', 'Cocinero Aficionado', 'Postres'),
('Ana Martinez', 'ana@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', NULL, 'Argentina', 'Buenos Aires', 'Chef de Repostería', 'Repostería'),
('Carlos Ruiz', 'carlos@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', NULL, 'Colombia', 'Bogotá', 'Cocinero Casero', 'Sopas'),
('Laura Sanchez', 'laura@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', NULL, 'Chile', 'Santiago', 'Chef Profesional', 'Vegetariano');

-- Asignar rol de usuario a los nuevos usuarios
INSERT INTO Usuario_Rol (id_usuario, id_rol) VALUES 
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1);

-- Insertar recetas
INSERT INTO Recetas (id_usuario_admin, id_categoria, nombre_receta, descripcion_corta, ingredientes, pasos, ingredientes_text, pais_origen, puntuacion_promedio) VALUES 
(1, 1, 'Guacamole Tradicional', 'Delicioso guacamole mexicano con ingredientes frescos', 
'["3 aguacates maduros", "1 tomate", "1/2 cebolla", "1 limón", "Cilantro al gusto", "Sal y pimienta"]',
'["Cortar los aguacates por la mitad y quitar el hueso", "Machacar la pulpa del aguacate en un bowl", "Picar finamente el tomate, cebolla y cilantro", "Mezclar todos los ingredientes", "Agregar jugo de limón, sal y pimienta al gusto", "Servir inmediatamente"]',
'aguacates tomate cebolla limón cilantro sal pimienta', 'México', 4.5),

(1, 2, 'Tacos al Pastor', 'Auténticos tacos al pastor con piña', 
'["500g carne de cerdo", "1 piña", "Tortillas de maíz", "Cebolla", "Cilantro", "Limones", "Salsa"]',
'["Marinar la carne con especias", "Cortar la piña en rodajas", "Cocinar la carne en el trompo o sartén", "Calentar las tortillas", "Montar los tacos con carne, piña, cebolla y cilantro", "Servir con limón y salsa"]',
'carne cerdo piña tortillas cebolla cilantro limón salsa', 'México', 4.8),

(1, 3, 'Flan Napolitano', 'Postre clásico mexicano con caramelo', 
'["1 lata leche condensada", "1 lata leche evaporada", "5 huevos", "1 cucharada vainilla", "1 taza azúcar para caramelo"]',
'["Hacer el caramelo con el azúcar", "Licuar leche condensada, evaporada, huevos y vainilla", "Verter en el molde con caramelo", "Hornear a baño María 60 minutos a 180°C", "Dejar enfriar y refrigerar", "Desmoldar y servir"]',
'leche condensada leche evaporada huevos vainilla azúcar', 'México', 4.7),

(1, 4, 'Agua de Horchata', 'Refrescante bebida tradicional mexicana', 
'["1 taza arroz", "5 tazas agua", "1/2 taza azúcar", "1 rama canela", "1 cucharadita vainilla"]',
'["Remojar el arroz con canela durante 4 horas", "Licuar el arroz con agua", "Colar la mezcla", "Agregar azúcar y vainilla", "Refrigerar", "Servir con hielo"]',
'arroz agua azúcar canela vainilla', 'México', 4.3),

(1, 5, 'Ensalada César', 'Clásica ensalada con aderezo César casero', 
'["Lechuga romana", "Pan para crutones", "Queso parmesano", "Pollo a la parrilla", "Aderezo César"]',
'["Lavar y cortar la lechuga", "Hacer crutones con el pan", "Cocinar el pollo y cortarlo", "Preparar el aderezo César", "Mezclar todos los ingredientes", "Servir con queso parmesano rallado"]',
'lechuga pan queso parmesano pollo aderezo', 'Italia', 4.4),

(1, 6, 'Sopa de Tortilla', 'Tradicional sopa mexicana con totopos', 
'["6 tomates", "1/4 cebolla", "2 dientes ajo", "6 tazas caldo pollo", "Tortillas", "Aguacate", "Queso", "Crema"]',
'["Asar tomates, cebolla y ajo", "Licuar con caldo", "Freír tortillas en tiras", "Colar y hervir el caldo", "Servir con totopos, aguacate, queso y crema"]',
'tomates cebolla ajo caldo pollo tortillas aguacate queso crema', 'México', 4.6),

(1, 7, 'Pasta Primavera Vegetariana', 'Pasta con vegetales frescos de temporada', 
'["400g pasta", "Brócoli", "Zanahoria", "Calabacín", "Pimientos", "Aceite de oliva", "Ajo", "Queso parmesano"]',
'["Cocinar la pasta al dente", "Saltear los vegetales con ajo", "Mezclar pasta con vegetales", "Agregar aceite de oliva", "Servir con queso parmesano"]',
'pasta brócoli zanahoria calabacín pimientos aceite oliva ajo queso', 'Italia', 4.2),

(1, 8, 'Buddha Bowl Vegano', 'Bowl nutritivo con quinoa y vegetales', 
'["1 taza quinoa", "Garbanzos", "Espinacas", "Aguacate", "Zanahoria", "Hummus", "Semillas"]',
'["Cocinar la quinoa", "Asar los garbanzos", "Preparar los vegetales", "Montar el bowl con todos los ingredientes", "Agregar hummus y semillas"]',
'quinoa garbanzos espinacas aguacate zanahoria hummus semillas', 'Moderno', 4.5),

(1, 9, 'Pan Sin Gluten', 'Pan casero sin gluten esponjoso', 
'["2 tazas harina sin gluten", "1 cucharada levadura", "1 cucharada azúcar", "1 taza agua tibia", "2 huevos", "3 cucharadas aceite", "1 cucharadita sal"]',
'["Mezclar harina, levadura, azúcar y sal", "Agregar agua, huevos y aceite", "Amasar hasta integrar", "Dejar reposar 1 hora", "Hornear 35 minutos a 180°C"]',
'harina sin gluten levadura azúcar agua huevos aceite sal', 'Moderno', 4.1),

(1, 10, 'Brownies de Chocolate', 'Brownies húmedos y deliciosos', 
'["200g chocolate", "150g mantequilla", "3 huevos", "1 taza azúcar", "1 taza harina", "1 cucharadita vainilla", "Nueces"]',
'["Derretir chocolate con mantequilla", "Batir huevos con azúcar", "Mezclar chocolate con huevos", "Agregar harina y vainilla", "Añadir nueces", "Hornear 25 minutos a 180°C"]',
'chocolate mantequilla huevos azúcar harina vainilla nueces', 'Estados Unidos', 4.9),

(1, 2, 'Enchiladas Verdes', 'Enchiladas bañadas en salsa verde', 
'["12 tortillas", "500g pollo", "Salsa verde", "Crema", "Queso", "Cebolla"]',
'["Cocinar y desmenuzar el pollo", "Calentar las tortillas", "Rellenar con pollo", "Bañar con salsa verde", "Gratinar con queso", "Servir con crema"]',
'tortillas pollo salsa verde crema queso cebolla', 'México', 4.7),

(1, 3, 'Tres Leches', 'Pastel esponjoso empapado en tres leches', 
'["5 huevos", "1 taza azúcar", "1 taza harina", "Leche condensada", "Leche evaporada", "Crema para batir"]',
'["Batir huevos con azúcar", "Incorporar harina", "Hornear el bizcocho", "Mezclar las tres leches", "Empapar el pastel", "Decorar con crema batida"]',
'huevos azúcar harina leche condensada leche evaporada crema', 'México', 4.8);

-- Insertar comentarios
INSERT INTO Comentarios (id_receta, id_usuario, id_estado, contenido_comentario) VALUES 
(1, 2, 2, '¡Excelente receta! El guacamole quedó perfecto.'),
(1, 3, 2, 'Me encantó, lo hice para una reunión y todos quedaron fascinados.'),
(2, 2, 2, 'Los mejores tacos al pastor que he probado, gracias por compartir.'),
(2, 4, 2, 'La marinación de la carne es clave, quedó deliciosa.'),
(3, 3, 2, 'El flan quedó súper cremoso, mi familia lo amó.'),
(3, 5, 1, 'Estoy intentando hacer esta receta, se ve deliciosa.'),
(4, 4, 2, 'Perfecta para el calor, muy refrescante.'),
(5, 5, 2, 'La ensalada césar casera es mucho mejor que la del restaurante.'),
(6, 2, 2, 'La sopa de tortilla es mi favorita, esta receta es auténtica.'),
(7, 6, 2, 'Perfecta para los vegetarianos de la familia.'),
(8, 6, 2, 'Bowl muy completo y nutritivo, me encantó.'),
(10, 3, 2, 'Los brownies quedaron perfectos, húmedos y chocolatosos.'),
(11, 4, 2, 'Las enchiladas verdes son mi platillo favorito.'),
(12, 5, 2, 'El tres leches quedó esponjosito y delicioso.');

-- Insertar calificaciones
INSERT INTO Calificaciones (id_receta, id_usuario, puntuacion) VALUES 
(1, 2, 5),
(1, 3, 4),
(1, 4, 5),
(2, 2, 5),
(2, 3, 5),
(2, 4, 5),
(3, 3, 5),
(3, 4, 4),
(3, 5, 5),
(4, 2, 4),
(4, 4, 5),
(5, 3, 4),
(5, 5, 5),
(6, 2, 5),
(6, 4, 4),
(7, 5, 4),
(7, 6, 4),
(8, 6, 5),
(8, 5, 4),
(9, 4, 4),
(10, 2, 5),
(10, 3, 5),
(10, 4, 5),
(11, 4, 5),
(11, 5, 4),
(12, 3, 5),
(12, 5, 5);

-- Actualizar puntuación promedio de recetas
UPDATE Recetas SET puntuacion_promedio = (
    SELECT AVG(puntuacion) FROM Calificaciones WHERE Calificaciones.id_receta = Recetas.id_receta
) WHERE id_receta IN (SELECT DISTINCT id_receta FROM Calificaciones);

-- Insertar recetas destacadas
INSERT INTO Recetas_Destacadas (id_usuario, id_receta) VALUES 
(2, 1),
(2, 2),
(2, 10),
(3, 3),
(3, 10),
(3, 12),
(4, 2),
(4, 6),
(5, 5),
(5, 8),
(6, 7),
(6, 8);

-- Verificar datos insertados
SELECT 'Usuarios registrados:' as Info, COUNT(*) as Total FROM Usuarios
UNION ALL
SELECT 'Recetas creadas:', COUNT(*) FROM Recetas
UNION ALL
SELECT 'Comentarios:', COUNT(*) FROM Comentarios
UNION ALL
SELECT 'Calificaciones:', COUNT(*) FROM Calificaciones
UNION ALL
SELECT 'Recetas destacadas:', COUNT(*) FROM Recetas_Destacadas;
