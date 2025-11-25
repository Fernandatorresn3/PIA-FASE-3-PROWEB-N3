/* ============================================================
   Script de población de datos de prueba para RecetasDB
   Versión exhaustiva para pruebas en producción
   
   PREREQUISITO: Ejecutar primero data.sql para datos iniciales
   ============================================================ */

USE RecetasDB;

-- ============================================================
-- LIMPIAR SOLO DATOS DE PRUEBA (mantener datos iniciales)
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM Recetas_Destacadas;
DELETE FROM Calificaciones;
DELETE FROM Comentarios;
DELETE FROM Recetas;
DELETE FROM Usuario_Rol WHERE id_usuario > 1;
DELETE FROM Usuarios WHERE id_usuario > 1; -- Mantener solo el admin principal

SET FOREIGN_KEY_CHECKS = 1;

-- Resetear auto_increment
ALTER TABLE Usuarios AUTO_INCREMENT = 2;
ALTER TABLE Recetas AUTO_INCREMENT = 1;
ALTER TABLE Comentarios AUTO_INCREMENT = 1;
ALTER TABLE Calificaciones AUTO_INCREMENT = 1;

-- ============================================================
-- NOTA: Los datos base ya deben existir (ejecutados por data.sql):
-- - Roles: ROLE_USER, ROLE_ADMIN
-- - Estados: PENDIENTE, APROBADO, RECHAZADO
-- - Categorías: Las 10 categorías iniciales
-- - Usuario admin con id=1
-- ============================================================

-- ============================================================
-- USUARIOS (20 usuarios con todos los campos poblados)
-- ============================================================
-- Contraseña para todos: password123 
-- Hash BCrypt: $2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje

INSERT INTO Usuarios (nombre_usuario, email, contrasena, foto_perfil_url, pais_residencia, estado_residencia, puesto_cocina, preferencia_categoria_receta) VALUES 
-- Usuarios regulares
('Maria Garcia', 'maria.garcia@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=1', 'México', 'Ciudad de México', 'Chef Ejecutiva', 'Platos principales'),
('Juan Perez', 'juan.perez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=12', 'España', 'Madrid', 'Cocinero Aficionado', 'Postres'),
('Ana Martinez', 'ana.martinez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=5', 'Argentina', 'Buenos Aires', 'Chef de Repostería', 'Repostería'),
('Carlos Ruiz', 'carlos.ruiz@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=13', 'Colombia', 'Bogotá', 'Cocinero Casero', 'Sopas'),
('Laura Sanchez', 'laura.sanchez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=9', 'Chile', 'Santiago', 'Chef Profesional', 'Vegetariano'),
('Roberto Fernandez', 'roberto.fernandez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=14', 'Perú', 'Lima', 'Sous Chef', 'Platos principales'),
('Sofia Lopez', 'sofia.lopez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=10', 'Uruguay', 'Montevideo', 'Chef Pastelera', 'Postres'),
('Diego Torres', 'diego.torres@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=15', 'México', 'Guadalajara', 'Chef de Partida', 'Entradas'),
('Valentina Morales', 'valentina.morales@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=20', 'Venezuela', 'Caracas', 'Chef Vegetariana', 'Vegetariano'),
('Javier Gomez', 'javier.gomez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=33', 'España', 'Barcelona', 'Chef de Cocina Molecular', 'Platos principales'),
('Isabella Ramirez', 'isabella.ramirez@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=23', 'Ecuador', 'Quito', 'Chef Vegana', 'Vegano'),
('Miguel Herrera', 'miguel.herrera@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=51', 'México', 'Monterrey', 'Parrillero Profesional', 'Platos principales'),
('Camila Diaz', 'camila.diaz@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=29', 'Costa Rica', 'San José', 'Chef de Ensaladas', 'Ensaladas'),
('Andres Silva', 'andres.silva@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=52', 'Brasil', 'São Paulo', 'Chef Internacional', 'Platos principales'),
('Lucia Castro', 'lucia.castro@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=27', 'Paraguay', 'Asunción', 'Chef de Repostería', 'Repostería'),
('Fernando Vargas', 'fernando.vargas@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=56', 'Bolivia', 'La Paz', 'Chef Tradicional', 'Sopas'),
('Daniela Rojas', 'daniela.rojas@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=31', 'Panamá', 'Ciudad de Panamá', 'Bartender y Chef', 'Bebidas'),
('Gabriel Medina', 'gabriel.medina@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=59', 'República Dominicana', 'Santo Domingo', 'Chef Caribeño', 'Platos principales'),
('Natalia Ortiz', 'natalia.ortiz@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=32', 'Nicaragua', 'Managua', 'Chef Sin Gluten', 'Sin gluten'),
('Ricardo Mendoza', 'ricardo.mendoza@example.com', '$2a$10$h0tEsoNRTwaCC4HEddRn6OrLUjQuWfHxS6MqptMIGe0SyzEGIvqje', 'https://i.pravatar.cc/150?img=60', 'Honduras', 'Tegucigalpa', 'Chef de Cocina Fusión', 'Platos principales');

-- ============================================================
-- ASIGNAR ROLES (18 usuarios regulares, 3 admins adicionales)
-- ============================================================
-- Usuarios regulares (ROLE_USER)
INSERT INTO Usuario_Rol (id_usuario, id_rol) VALUES 
(2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1), (9, 1), (10, 1),
(11, 1), (12, 1), (13, 1), (14, 1), (15, 1), (16, 1), (17, 1), (18, 1), (19, 1);

-- Usuarios con rol de administrador adicional (además de ROLE_USER)
INSERT INTO Usuario_Rol (id_usuario, id_rol) VALUES 
(2, 2),  -- Maria Garcia también es admin
(20, 1), -- Ricardo Mendoza usuario regular
(20, 2), -- Ricardo Mendoza también es admin
(21, 1), -- Natalia Ortiz usuario regular
(21, 2); -- Natalia Ortiz también es admin

-- ============================================================
-- RECETAS (30 recetas exhaustivas con todos los campos)
-- ============================================================
INSERT INTO Recetas (id_usuario_admin, id_categoria, nombre_receta, descripcion_corta, ingredientes, pasos, ingredientes_text, pais_origen, image_url, puntuacion_promedio) VALUES 
-- Entradas (Categoría 1)
(1, 1, 'Guacamole Tradicional', 'Delicioso guacamole mexicano con ingredientes frescos y naturales', 
'["3 aguacates Hass maduros", "1 tomate rojo mediano", "1/2 cebolla blanca", "1 limón verde", "1/4 taza cilantro fresco picado", "1 chile serrano", "1/2 cucharadita sal de mar", "1/4 cucharadita pimienta negra"]',
'["Cortar los aguacates por la mitad y quitar el hueso con cuidado", "Extraer la pulpa con una cuchara y colocar en un bowl amplio", "Machacar la pulpa del aguacate con un tenedor hasta obtener la textura deseada", "Picar finamente el tomate, cebolla, cilantro y chile serrano", "Mezclar todos los ingredientes cortados con el aguacate", "Agregar jugo de limón recién exprimido", "Sazonar con sal y pimienta al gusto", "Mezclar suavemente para integrar", "Servir inmediatamente con totopos o chips"]',
'aguacates tomate cebolla limón cilantro chile sal pimienta', 'México', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c', 4.5),

(2, 1, 'Bruschetta Italiana', 'Clásica entrada italiana con tomate y albahaca fresca sobre pan tostado', 
'["1 barra pan italiano", "4 tomates maduros", "3 dientes ajo", "1/4 taza albahaca fresca", "3 cucharadas aceite oliva virgen extra", "2 cucharadas vinagre balsámico", "Sal marina", "Pimienta negra recién molida"]',
'["Precalentar el horno a 200°C", "Cortar el pan en rebanadas de 1.5 cm de grosor", "Tostar las rebanadas en el horno durante 5-7 minutos hasta dorar", "Picar los tomates en cubos pequeños", "Picar finamente la albahaca fresca", "Pelar y picar un diente de ajo muy fino", "Mezclar tomates, albahaca y ajo picado", "Agregar aceite de oliva y vinagre balsámico", "Sazonar con sal y pimienta", "Frotar las tostadas con ajo crudo", "Colocar la mezcla sobre las tostadas", "Servir inmediatamente"]',
'pan italiano tomates ajo albahaca aceite oliva vinagre balsámico sal pimienta', 'Italia', 'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f', 0),

(1, 1, 'Ceviche Peruano', 'Fresco ceviche de pescado con el toque peruano auténtico', 
'["500g corvina fresca", "10 limones peruanos", "1 cebolla morada", "1 ají limo", "Cilantro fresco", "1 camote", "1 choclo", "Sal", "Pimienta"]',
'["Cortar el pescado en cubos de 2 cm", "Cortar la cebolla en juliana fina", "Picar el ají limo y cilantro", "Exprimir los limones y colar el jugo", "Colocar el pescado en un bowl", "Agregar sal y pimienta", "Verter el jugo de limón sobre el pescado", "Mezclar suavemente y dejar marinar 5 minutos", "Agregar cebolla, ají y cilantro", "Mezclar nuevamente", "Cocinar camote y choclo por separado", "Servir el ceviche acompañado de camote y choclo"]',
'corvina limones cebolla morada ají cilantro camote choclo sal pimienta', 'Perú', 'https://images.unsplash.com/photo-1608897013039-887f21d8c804', 0),

-- Platos Principales (Categoría 2)
(1, 2, 'Tacos al Pastor', 'Auténticos tacos al pastor con piña caramelizada y especias tradicionales', 
'["1kg carne de cerdo", "1 piña natural", "12 tortillas de maíz", "1 cebolla blanca", "1 taza cilantro fresco", "4 limones", "Achiote", "Chile guajillo", "Comino", "Orégano", "Sal"]',
'["Preparar la marinada con chiles, achiote y especias", "Cortar la carne en láminas delgadas", "Marinar la carne durante 4 horas o toda la noche", "Cortar la piña en rodajas de 1 cm", "Cocinar la carne marinada en comal o sartén a fuego alto", "Caramelizar las rodajas de piña", "Calentar las tortillas en el comal", "Cortar la carne cocinada en trozos pequeños", "Picar cebolla y cilantro finamente", "Montar los tacos con carne, piña, cebolla y cilantro", "Servir con limón y salsa al gusto"]',
'carne cerdo piña tortillas cebolla cilantro limón achiote chile guajillo comino orégano sal', 'México', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47', 4.8),

(2, 2, 'Paella Valenciana', 'Auténtica paella valenciana con pollo, conejo y verduras frescas', 
'["500g arroz bomba", "400g pollo", "300g conejo", "200g judías verdes", "150g garrofón", "3 tomates", "Azafrán", "Pimentón", "Aceite oliva", "Sal", "Agua o caldo"]',
'["Calentar aceite en la paellera", "Dorar el pollo y conejo troceados", "Añadir las judías verdes cortadas", "Incorporar el garrofón", "Rallar el tomate y agregarlo", "Añadir pimentón y remover rápido", "Agregar agua o caldo caliente", "Añadir azafrán y sal", "Cuando hierva, distribuir el arroz uniformemente", "Cocinar a fuego fuerte 10 minutos", "Bajar el fuego y cocinar 8 minutos más", "Dejar reposar 5 minutos antes de servir"]',
'arroz pollo conejo judías verdes garrofón tomates azafrán pimentón aceite oliva sal', 'España', 'https://images.unsplash.com/photo-1534080564583-6be75777b70a', 0),

(1, 2, 'Enchiladas Verdes', 'Enchiladas bañadas en salsa verde de tomatillo con crema y queso', 
'["12 tortillas de maíz", "600g pechuga de pollo", "500g tomatillos", "2 chiles serranos", "1/2 cebolla", "2 dientes ajo", "1 taza crema mexicana", "200g queso fresco", "Cilantro", "Aceite", "Sal"]',
'["Cocinar las pechugas de pollo en agua con sal", "Desmenuzar el pollo una vez cocido", "Quitar cáscara a los tomatillos y lavar", "Cocer tomatillos con chiles, cebolla y ajo", "Licuar los ingredientes cocidos con cilantro", "Freír la salsa en aceite caliente", "Pasar las tortillas por aceite caliente", "Rellenar cada tortilla con pollo", "Enrollar las tortillas y colocar en un refractario", "Bañar completamente con salsa verde caliente", "Espolvorear queso fresco desmoronado", "Gratinar en el horno 10 minutos", "Servir con crema mexicana"]',
'tortillas pollo tomatillos chiles cebolla ajo crema queso cilantro aceite sal', 'México', 'https://images.unsplash.com/photo-1599974982760-ac92c8022fda', 4.7),

(14, 2, 'Feijoada Brasileña', 'Tradicional guiso brasileño con frijoles negros y carnes variadas', 
'["500g frijoles negros", "300g carne de cerdo", "200g chorizo", "150g tocino", "100g carne seca", "1 cebolla", "4 dientes ajo", "2 hojas laurel", "Naranja", "Arroz blanco", "Col rizada", "Farofa"]',
'["Remojar los frijoles durante toda la noche", "Cocinar los frijoles con agua fresca", "Dorar todas las carnes por separado", "Picar cebolla y ajo finamente", "Sofreír cebolla y ajo", "Agregar las carnes al sofrito", "Añadir los frijoles semicocidos", "Incorporar hojas de laurel", "Cocinar a fuego lento 2 horas", "Servir con arroz blanco", "Acompañar con col rizada salteada", "Decorar con rodajas de naranja"]',
'frijoles negros carne cerdo chorizo tocino carne seca cebolla ajo laurel naranja arroz col farofa', 'Brasil', 'https://images.unsplash.com/photo-1623855244345-2f8c8b98c9e2', 0),

-- Postres (Categoría 3)
(1, 3, 'Flan Napolitano', 'Postre clásico mexicano con caramelo oscuro y textura cremosa', 
'["1 lata (397g) leche condensada", "1 lata (354ml) leche evaporada", "5 huevos grandes", "1 cucharada extracto vainilla", "1 taza azúcar blanca para caramelo", "1/4 taza agua"]',
'["Precalentar el horno a 180°C", "Preparar el caramelo: calentar azúcar con agua en una olla", "Mover constantemente hasta obtener caramelo dorado oscuro", "Verter el caramelo en el molde de flan y cubrir el fondo", "Inclinar el molde para distribuir el caramelo por las paredes", "Licuar leche condensada, leche evaporada, huevos y vainilla", "Licuar durante 2 minutos hasta integrar completamente", "Verter la mezcla cuidadosamente en el molde con caramelo", "Colocar el molde en una charola con agua caliente (baño María)", "Hornear 60 minutos o hasta que al insertar un palillo salga limpio", "Dejar enfriar completamente a temperatura ambiente", "Refrigerar mínimo 4 horas o toda la noche", "Desmoldar pasando un cuchillo por las orillas", "Invertir en un plato hondo para servir"]',
'leche condensada leche evaporada huevos vainilla azúcar agua', 'México', 'https://images.unsplash.com/photo-1551879400-111a9087cd86', 4.7),

(3, 3, 'Tres Leches', 'Pastel esponjoso empapado en tres leches con crema batida', 
'["5 huevos separados", "1 taza azúcar", "1 taza harina de trigo", "1 cucharadita polvo hornear", "1 lata leche condensada", "1 lata leche evaporada", "1 taza leche entera", "1 cucharadita vainilla", "2 tazas crema para batir", "3 cucharadas azúcar glass"]',
'["Precalentar horno a 180°C y engrasar molde", "Batir las yemas con 3/4 taza de azúcar hasta blanquear", "En otro bowl, batir las claras a punto de nieve", "Agregar 1/4 taza azúcar gradualmente a las claras", "Mezclar las yemas con las claras suavemente", "Cernir harina con polvo de hornear", "Incorporar la harina a la mezcla con movimientos envolventes", "Verter en el molde y hornear 30-35 minutos", "Dejar enfriar completamente", "Mezclar las tres leches con vainilla", "Picar el pastel con un tenedor", "Verter la mezcla de leches lentamente sobre el pastel", "Refrigerar 4 horas para que absorba", "Batir la crema con azúcar glass", "Cubrir el pastel con crema batida", "Decorar al gusto y servir frío"]',
'huevos azúcar harina polvo hornear leche condensada leche evaporada leche entera vainilla crema azúcar glass', 'México', 'https://images.unsplash.com/photo-1621303837174-89787a7d4729', 4.8),

(3, 3, 'Brownies de Chocolate', 'Brownies húmedos y chocolatosos con nueces crujientes', 
'["200g chocolate oscuro", "150g mantequilla sin sal", "3 huevos grandes", "1 taza azúcar", "1 taza harina de trigo", "1/3 taza cocoa en polvo", "1 cucharadita extracto vainilla", "1/2 cucharadita sal", "1 taza nueces picadas"]',
'["Precalentar el horno a 180°C", "Engrasar y enharinar un molde cuadrado de 20x20 cm", "Derretir el chocolate con la mantequilla a baño María", "Remover constantemente hasta obtener mezcla homogénea", "Dejar enfriar ligeramente", "Batir los huevos con el azúcar hasta duplicar volumen", "Agregar la mezcla de chocolate a los huevos batidos", "Incorporar el extracto de vainilla", "Cernir la harina, cocoa y sal", "Integrar los ingredientes secos con movimientos envolventes", "Añadir las nueces picadas y mezclar", "Verter la mezcla en el molde preparado", "Hornear 25-30 minutos (centro ligeramente húmedo)", "Dejar enfriar completamente antes de cortar", "Cortar en cuadros y servir"]',
'chocolate mantequilla huevos azúcar harina cocoa vainilla sal nueces', 'Estados Unidos', 'https://images.unsplash.com/photo-1607920591413-4ec007e70023', 4.9),

(7, 3, 'Tiramisu Casero', 'Elegante postre italiano con capas de café y mascarpone', 
'["500g queso mascarpone", "6 huevos", "1 taza azúcar", "2 tazas café expreso fuerte", "3 cucharadas licor amaretto", "300g galletas savoiardi", "Cocoa en polvo", "Chocolate oscuro rallado"]',
'["Preparar café expreso y dejar enfriar", "Agregar amaretto al café", "Separar yemas y claras de huevo", "Batir yemas con azúcar hasta blanquear", "Agregar mascarpone a las yemas batidas", "Batir claras a punto de nieve", "Incorporar claras al mascarpone con movimientos envolventes", "Remojar rápidamente las galletas en café", "Formar primera capa de galletas en molde", "Cubrir con capa de crema de mascarpone", "Repetir capas alternadas", "Terminar con capa de crema", "Espolvorear cocoa en polvo", "Refrigerar mínimo 6 horas", "Decorar con chocolate rallado antes de servir"]',
'mascarpone huevos azúcar café amaretto galletas savoiardi cocoa chocolate', 'Italia', 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9', 0),

-- Bebidas (Categoría 4)
(1, 4, 'Agua de Horchata', 'Refrescante bebida tradicional mexicana de arroz y canela', 
'["1 taza arroz blanco", "5 tazas agua purificada", "1/2 taza azúcar blanca", "1 raja canela de 10cm", "1 cucharadita extracto vainilla", "Hielo"]',
'["Lavar el arroz hasta que el agua salga clara", "Colocar arroz en un bowl con agua", "Agregar la raja de canela", "Remojar durante 4-6 horas o toda la noche", "Licuar el arroz con el agua de remojo durante 2 minutos", "Licuar hasta obtener una mezcla muy fina", "Colar la mezcla usando manta de cielo o colador fino", "Presionar bien para extraer todo el líquido", "Agregar azúcar al líquido colado", "Incorporar el extracto de vainilla", "Mezclar hasta disolver completamente el azúcar", "Refrigerar hasta que esté bien fría", "Servir con hielo abundante"]',
'arroz agua azúcar canela vainilla hielo', 'México', 'https://images.unsplash.com/photo-1556881286-fc6915169721', 4.3),

(17, 4, 'Mojito Cubano', 'Refrescante cóctel cubano con menta fresca y ron blanco', 
'["60ml ron blanco", "30ml jugo de limón", "2 cucharaditas azúcar blanca", "10 hojas menta fresca", "Agua mineral con gas", "Hielo triturado", "1 rodaja limón"]',
'["Lavar las hojas de menta fresca", "Colocar menta y azúcar en un vaso alto", "Machacar suavemente para liberar aceites", "Agregar jugo de limón recién exprimido", "Mezclar para disolver el azúcar", "Llenar el vaso con hielo triturado", "Verter el ron blanco", "Completar con agua mineral", "Revolver suavemente de abajo hacia arriba", "Decorar con hojas de menta", "Agregar rodaja de limón en el borde", "Servir con popote"]',
'ron limón azúcar menta agua mineral hielo', 'Cuba', 'https://images.unsplash.com/photo-1551538827-9c037cb4f32a', 0),

-- Ensaladas (Categoría 5)
(1, 5, 'Ensalada César', 'Clásica ensalada César con aderezo casero y crutones crujientes', 
'["2 lechugas romanas", "150g pan del día anterior", "150g pechuga de pollo", "100g queso parmesano", "3 anchoas", "2 dientes ajo", "1 huevo", "1 limón", "1 cucharadita mostaza Dijon", "1/2 taza aceite oliva", "Sal", "Pimienta negra"]',
'["Precalentar horno a 180°C para los crutones", "Cortar el pan en cubos de 2cm", "Mezclar pan con aceite, ajo y sal", "Hornear 10 minutos hasta dorar", "Sazonar y cocinar el pollo a la parrilla", "Dejar reposar y cortar en tiras", "Lavar y secar la lechuga romana", "Cortar lechuga en trozos del tamaño de un bocado", "Preparar aderezo: machacar anchoas y ajo", "Agregar yema de huevo y mostaza", "Emulsionar agregando aceite lentamente", "Agregar jugo de limón", "Sazonar con sal y pimienta", "Mezclar lechuga con aderezo", "Agregar crutones y pollo", "Rallar queso parmesano sobre la ensalada", "Servir inmediatamente"]',
'lechuga romana pan pollo queso parmesano anchoas ajo huevo limón mostaza aceite oliva sal pimienta', 'Italia', 'https://images.unsplash.com/photo-1546793665-c74683f339c1', 4.4),

(13, 5, 'Ensalada Griega', 'Fresca ensalada mediterránea con queso feta y aceitunas', 
'["4 tomates maduros", "1 pepino grande", "1 pimiento verde", "1 cebolla morada", "200g queso feta", "1 taza aceitunas kalamata", "Orégano seco", "Aceite oliva virgen extra", "Sal marina", "Pimienta"]',
'["Lavar todos los vegetales", "Cortar tomates en gajos grandes", "Pelar y cortar pepino en medias lunas", "Cortar pimiento en tiras", "Cortar cebolla en aros finos", "Colocar vegetales en ensaladera", "Agregar aceitunas kalamata", "Cortar queso feta en cubos", "Distribuir el queso sobre la ensalada", "Espolvorear orégano seco generosamente", "Rociar con aceite de oliva", "Sazonar con sal y pimienta", "Mezclar suavemente", "Servir a temperatura ambiente"]',
'tomates pepino pimiento cebolla queso feta aceitunas orégano aceite oliva sal pimienta', 'Grecia', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe', 0),

-- Sopas (Categoría 6)
(1, 6, 'Sopa de Tortilla', 'Tradicional sopa mexicana con totopos crujientes y aguacate', 
'["6 tomates rojos grandes", "1/4 cebolla blanca", "2 dientes ajo", "6 tazas caldo de pollo", "6 tortillas de maíz", "1 aguacate", "150g queso fresco", "1/2 taza crema mexicana", "2 chiles pasilla secos", "Cilantro fresco", "Aceite vegetal", "Sal"]',
'["Asar los tomates, cebolla y ajo en el comal", "Dejar que se tuesten uniformemente", "Licuar los ingredientes asados con un poco de caldo", "Colar la mezcla para obtener consistencia suave", "Calentar aceite en una olla grande", "Freír la salsa de tomate colada", "Agregar el resto del caldo de pollo caliente", "Sazonar con sal al gusto", "Dejar hervir a fuego medio 15 minutos", "Cortar tortillas en tiras delgadas", "Freír las tiras hasta que estén crujientes", "Freír los chiles pasilla brevemente", "Cortar aguacate en cubos", "Desmoronar el queso fresco", "Servir la sopa caliente en platos hondos", "Agregar totopos, aguacate, queso y crema", "Decorar con chile pasilla frito y cilantro"]',
'tomates cebolla ajo caldo pollo tortillas aguacate queso crema chiles pasilla cilantro aceite sal', 'México', 'https://images.unsplash.com/photo-1613844237701-8f3664fc2eff', 4.6),

(4, 6, 'Ajiaco Colombiano', 'Sopa tradicional colombiana con tres tipos de papa y pollo', 
'["4 pechugas de pollo", "3 tipos de papa (criolla, sabanera, pastusa)", "2 mazorcas tiernas", "1 taza guascas", "1 cebolla larga", "3 dientes ajo", "Cilantro", "Alcaparras", "Crema de leche", "Aguacate", "Sal", "Comino"]',
'["Cocinar las pechugas de pollo con sal", "Desmenuzar el pollo cocido", "Reservar el caldo de cocción", "Pelar y cortar las papas según su tipo", "Cortar mazorcas en rodajas", "Picar cebolla y ajo finamente", "Sofreír cebolla y ajo en aceite", "Agregar el caldo de pollo", "Añadir las papas más duras primero", "Cocinar 15 minutos", "Agregar papas más blandas", "Incorporar las mazorcas", "Añadir las guascas", "Cocinar hasta que espese", "Agregar el pollo desmenuzado", "Servir caliente", "Acompañar con alcaparras, crema y aguacate"]',
'pollo papas mazorca guascas cebolla ajo cilantro alcaparras crema aguacate sal comino', 'Colombia', 'https://images.unsplash.com/photo-1547592166-23ac45744acd', 0),

-- Vegetariano (Categoría 7)
(1, 7, 'Pasta Primavera Vegetariana', 'Pasta fresca con vegetales de temporada salteados', 
'["400g pasta penne", "1 brócoli", "2 zanahorias", "1 calabacín", "1 pimiento rojo", "1 pimiento amarillo", "200g champiñones", "3 dientes ajo", "1/2 taza aceite de oliva", "100g queso parmesano", "Albahaca fresca", "Sal", "Pimienta"]',
'["Poner a hervir agua con sal para la pasta", "Lavar y cortar brócoli en floretes", "Pelar y cortar zanahorias en rodajas", "Cortar calabacín en medias lunas", "Cortar pimientos en tiras", "Laminar los champiñones", "Picar ajo finamente", "Cocinar pasta al dente según instrucciones", "Escurrir y reservar 1 taza del agua de cocción", "Calentar aceite en sartén grande", "Saltear ajo hasta dorar", "Agregar zanahorias primero", "Añadir brócoli y champiñones", "Incorporar calabacines y pimientos", "Saltear 5-7 minutos", "Agregar la pasta escurrida", "Mezclar agregando agua de cocción si es necesario", "Sazonar con sal y pimienta", "Rallar queso parmesano", "Decorar con albahaca fresca", "Servir inmediatamente"]',
'pasta penne brócoli zanahorias calabacín pimientos champiñones ajo aceite oliva queso parmesano albahaca sal pimienta', 'Italia', 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9', 4.2),

(9, 7, 'Curry de Verduras', 'Aromático curry vegetariano con leche de coco', 
'["2 papas", "1 coliflor", "2 zanahorias", "1 taza chícharos", "1 pimiento rojo", "1 cebolla", "3 dientes ajo", "1 trozo jengibre", "400ml leche de coco", "2 cucharadas pasta curry", "1 cucharadita cúrcuma", "1 cucharadita comino", "Cilantro", "Aceite", "Sal"]',
'["Pelar y cortar papas en cubos", "Cortar coliflor en floretes", "Pelar y cortar zanahorias", "Picar cebolla, ajo y jengibre", "Calentar aceite en olla grande", "Sofreír cebolla hasta transparentar", "Agregar ajo y jengibre", "Añadir pasta de curry", "Incorporar cúrcuma y comino", "Agregar papas y zanahorias", "Cocinar 5 minutos", "Añadir coliflor y pimiento", "Verter leche de coco", "Agregar agua si es necesario", "Cocinar 20 minutos", "Añadir chícharos", "Cocinar 5 minutos más", "Decorar con cilantro", "Servir con arroz basmati"]',
'papas coliflor zanahorias chícharos pimiento cebolla ajo jengibre leche coco curry cúrcuma comino cilantro aceite sal', 'India', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe', 0),

-- Vegano (Categoría 8)
(1, 8, 'Buddha Bowl Vegano', 'Bowl nutritivo y colorido con quinoa y vegetales asados', 
'["1 taza quinoa", "1 lata (400g) garbanzos", "2 tazas espinacas frescas", "1 aguacate", "1 zanahoria", "1 remolacha", "1/2 taza hummus", "2 cucharadas tahini", "Semillas de girasol", "Semillas de calabaza", "Limón", "Aceite oliva", "Sal", "Pimienta", "Comino"]',
'["Enjuagar la quinoa bajo agua fría", "Cocinar quinoa en agua con sal (proporción 1:2)", "Escurrir y enjuagar los garbanzos", "Secar garbanzos con papel absorbente", "Mezclar garbanzos con aceite y especias", "Asar garbanzos en horno a 200°C por 25 minutos", "Pelar y cortar remolacha y zanahoria", "Asar vegetales con aceite, sal y pimienta", "Lavar las espinacas", "Cortar aguacate en láminas", "Preparar aderezo con tahini y limón", "Montar el bowl: base de quinoa", "Distribuir espinacas en una sección", "Colocar garbanzos asados", "Agregar vegetales asados", "Añadir láminas de aguacate", "Colocar una porción de hummus", "Espolvorear semillas", "Rociar con aderezo de tahini", "Servir a temperatura ambiente"]',
'quinoa garbanzos espinacas aguacate zanahoria remolacha hummus tahini semillas girasol semillas calabaza limón aceite oliva sal pimienta comino', 'Moderno', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c', 4.5),

(11, 8, 'Tacos Veganos de Jackfruit', 'Innovadores tacos veganos con jackfruit desmenuzado', 
'["2 latas jackfruit en salmuera", "12 tortillas de maíz", "1 cebolla morada", "2 tomates", "1 aguacate", "Cilantro", "2 limones", "2 cucharadas salsa BBQ vegana", "Comino", "Pimentón", "Ajo en polvo", "Aceite", "Sal"]',
'["Escurrir y enjuagar el jackfruit", "Desmenuzar el jackfruit con las manos", "Calentar aceite en sartén", "Saltear jackfruit con especias", "Agregar salsa BBQ", "Cocinar 15 minutos removiendo", "Picar cebolla finamente", "Cortar tomates en cubos", "Picar cilantro", "Hacer pico de gallo con tomate, cebolla y cilantro", "Cortar aguacate en láminas", "Calentar tortillas", "Rellenar con jackfruit", "Agregar pico de gallo", "Añadir aguacate", "Servir con limón"]',
'jackfruit tortillas cebolla tomates aguacate cilantro limones salsa BBQ comino pimentón ajo aceite sal', 'Fusión', 'https://images.unsplash.com/photo-1595295333158-4742f28fbd85', 0),

-- Sin Gluten (Categoría 9)
(1, 9, 'Pan Sin Gluten', 'Pan casero sin gluten esponjoso y delicioso', 
'["2 tazas harina sin gluten", "1 cucharada levadura seca", "1 cucharada azúcar", "1 taza agua tibia", "2 huevos grandes", "3 cucharadas aceite de oliva", "1 cucharadita sal", "1 cucharadita goma xantana", "1 cucharada vinagre de manzana"]',
'["Verificar que el agua esté tibia (no caliente)", "Disolver azúcar y levadura en agua tibia", "Dejar reposar 10 minutos hasta que espume", "Batir los huevos en un bowl grande", "Agregar aceite de oliva a los huevos", "Incorporar el vinagre de manzana", "Mezclar harina sin gluten con sal y goma xantana", "Agregar la mezcla de levadura a los huevos", "Incorporar gradualmente los ingredientes secos", "Mezclar hasta obtener masa homogénea", "La masa será más líquida que masa tradicional", "Verter en molde engrasado", "Cubrir y dejar reposar 1 hora en lugar cálido", "Precalentar horno a 180°C", "Hornear 35-40 minutos", "El pan debe sonar hueco al golpear", "Dejar enfriar completamente antes de cortar"]',
'harina sin gluten levadura azúcar agua huevos aceite oliva sal goma xantana vinagre', 'Moderno', 'https://images.unsplash.com/photo-1509440159596-0249088772ff', 4.1),

(19, 9, 'Pizza Sin Gluten', 'Deliciosa pizza con masa sin gluten crujiente', 
'["2 tazas harina sin gluten", "1 cucharadita levadura", "1 cucharadita azúcar", "3/4 taza agua tibia", "2 cucharadas aceite oliva", "1 cucharadita sal", "1 cucharadita goma xantana", "Salsa de tomate", "Queso mozzarella", "Ingredientes al gusto"]',
'["Mezclar levadura con azúcar y agua tibia", "Dejar activar 10 minutos", "Mezclar harina con sal y goma xantana", "Agregar aceite y mezcla de levadura", "Amasar hasta obtener masa suave", "Dejar reposar 30 minutos cubierta", "Precalentar horno a 220°C", "Extender la masa sobre papel pergamino", "Formar círculo de 30cm", "Pre-hornear la masa 10 minutos", "Sacar del horno", "Untar salsa de tomate", "Agregar queso mozzarella", "Añadir ingredientes favoritos", "Hornear 15 minutos más", "Servir caliente"]',
'harina sin gluten levadura azúcar agua aceite oliva sal goma xantana salsa tomate queso mozzarella', 'Italia', 'https://images.unsplash.com/photo-1513104890138-7c749659a591', 0),

-- Repostería (Categoría 10)
(3, 10, 'Cheesecake de Fresa', 'Elegante cheesecake con base de galleta y fresas frescas', 
'["300g galletas María", "100g mantequilla derretida", "600g queso crema", "1 taza azúcar", "3 huevos", "1 cucharadita vainilla", "1 taza crema ácida", "500g fresas frescas", "1/2 taza mermelada de fresa", "Jugo de 1 limón"]',
'["Triturar las galletas hasta polvo fino", "Mezclar galletas con mantequilla derretida", "Presionar en el fondo de molde desmoldable", "Refrigerar mientras prepara el relleno", "Precalentar horno a 160°C", "Batir queso crema hasta suavizar", "Agregar azúcar gradualmente", "Incorporar huevos uno por uno", "Añadir vainilla y crema ácida", "Verter sobre la base de galletas", "Hornear 50 minutos a baño María", "El centro debe verse ligeramente tembloroso", "Apagar horno y dejar dentro 1 hora", "Refrigerar completamente (mínimo 6 horas)", "Lavar y cortar fresas", "Calentar mermelada con jugo de limón", "Decorar con fresas", "Glasear con mermelada", "Servir bien frío"]',
'galletas mantequilla queso crema azúcar huevos vainilla crema ácida fresas mermelada limón', 'Estados Unidos', 'https://images.unsplash.com/photo-1533134486753-c833f0ed4866', 0),

(15, 10, 'Macarons Franceses', 'Delicados macarons franceses con relleno de ganache', 
'["200g azúcar glass", "200g almendra molida", "150g azúcar blanca", "4 claras de huevo", "Colorante alimentario", "200g chocolate", "200ml crema para batir"]',
'["Tamizar azúcar glass y almendra juntas", "Tamizar tres veces para textura fina", "Batir claras a punto de nieve", "Agregar azúcar gradualmente", "Batir hasta obtener merengue brillante", "Agregar colorante al merengue", "Incorporar almendra y azúcar glass", "Hacer movimientos envolventes (macaronage)", "La mezcla debe caer en listón", "Colocar en manga pastelera", "Formar círculos de 3cm en charola", "Dejar reposar 30 minutos", "Formar costra en la superficie", "Precalentar horno a 150°C", "Hornear 12-15 minutos", "Deben formarse pieds o pies", "Dejar enfriar completamente", "Calentar crema sin hervir", "Verter sobre chocolate", "Formar ganache suave", "Rellenar macarons con ganache", "Refrigerar 24 horas antes de servir"]',
'azúcar glass almendra azúcar claras colorante chocolate crema', 'Francia', 'https://images.unsplash.com/photo-1558312657-e0f6d0ea7e6c', 0);

-- ============================================================
-- COMENTARIOS (60 comentarios distribuidos en las recetas)
-- ============================================================
INSERT INTO Comentarios (id_receta, id_usuario, id_estado, contenido_comentario, fecha_comentario) VALUES 
-- Comentarios para Guacamole (id_receta: 1)
(1, 2, 2, '¡Excelente receta! El guacamole quedó perfecto para mi fiesta mexicana.', '2025-11-20 14:30:00'),
(1, 3, 2, 'Me encantó, lo hice para una reunión y todos quedaron fascinados con el sabor.', '2025-11-21 09:15:00'),
(1, 5, 2, 'La proporción de limón es perfecta, no queda ni muy ácido ni muy suave.', '2025-11-22 18:45:00'),
(1, 8, 1, 'Estoy preparándolo ahora mismo, se ve delicioso. ¿Puedo agregar más chile?', '2025-11-23 12:00:00'),

-- Comentarios para Bruschetta (id_receta: 2)
(2, 4, 2, 'Auténtico sabor italiano, tal como lo comí en Roma. Gracias por compartir.', '2025-11-19 16:20:00'),
(2, 6, 2, 'Los crutones quedaron perfectos, crujientes por fuera y suaves por dentro.', '2025-11-20 11:30:00'),
(2, 9, 1, '¿Puedo sustituir el vinagre balsámico por otro tipo de vinagre?', '2025-11-22 15:45:00'),

-- Comentarios para Ceviche (id_receta: 3)
(3, 7, 2, 'El mejor ceviche que he probado fuera de Perú. ¡Excelente!', '2025-11-18 13:00:00'),
(3, 10, 2, 'El punto de cocción con limón es perfecto. Muy fresco y delicioso.', '2025-11-21 17:30:00'),
(3, 12, 2, 'Seguí la receta al pie de la letra y quedó increíble.', '2025-11-23 10:15:00'),

-- Comentarios para Tacos al Pastor (id_receta: 4)
(4, 2, 2, 'Los mejores tacos al pastor que he probado, la marinación es clave.', '2025-11-17 19:45:00'),
(4, 4, 2, 'La marinación de la carne hace toda la diferencia, quedó deliciosa y jugosa.', '2025-11-18 20:30:00'),
(4, 6, 2, 'Perfectos para una reunión familiar. Hice el doble de la receta.', '2025-11-20 12:00:00'),
(4, 11, 2, 'La combinación con piña caramelizada es espectacular.', '2025-11-22 16:45:00'),
(4, 13, 1, 'Estoy marinando la carne ahora, espero que quede tan bien como en las fotos.', '2025-11-24 08:30:00'),

-- Comentarios para Paella (id_receta: 5)
(5, 3, 2, 'Auténtica paella valenciana. Mis abuelos españoles aprobarían esta receta.', '2025-11-16 14:20:00'),
(5, 8, 2, 'El arroz quedó en su punto perfecto, ni muy seco ni muy húmedo.', '2025-11-19 13:45:00'),
(5, 14, 3, 'No me gustó mucho, prefiero otras versiones.', '2025-11-20 18:00:00'),

-- Comentarios para Enchiladas Verdes (id_receta: 6)
(6, 2, 2, 'La sopa de tortilla es mi favorita, esta receta es muy auténtica.', '2025-11-15 12:30:00'),
(6, 5, 2, 'Las enchiladas verdes son mi platillo favorito mexicano. ¡Perfectas!', '2025-11-18 19:15:00'),
(6, 9, 2, 'La salsa verde quedó con el punto exacto de picante.', '2025-11-21 11:00:00'),
(6, 16, 2, 'Hice esta receta para mi familia y todos pidieron más.', '2025-11-23 15:30:00'),

-- Comentarios para Feijoada (id_receta: 7)
(7, 14, 2, 'Como brasileño, puedo confirmar que esta feijoada es auténtica. ¡Excelente!', '2025-11-17 13:00:00'),
(7, 8, 2, 'Platillo contundente y delicioso. Perfecto para el fin de semana.', '2025-11-20 14:45:00'),

-- Comentarios para Flan Napolitano (id_receta: 8)
(8, 3, 2, 'El flan quedó súper cremoso y suave, mi familia lo amó.', '2025-11-14 16:00:00'),
(8, 7, 2, 'Perfecto balance entre dulzor y textura. Lo haré de nuevo.', '2025-11-17 10:30:00'),
(8, 10, 2, 'El caramelo tiene el amargor perfecto que contrasta con la crema.', '2025-11-20 18:15:00'),
(8, 15, 2, 'Mi postre mexicano favorito. Esta receta es infalible.', '2025-11-22 09:45:00'),

-- Comentarios para Tres Leches (id_receta: 9)
(9, 2, 2, 'El tres leches quedó esponjosito y perfectamente húmedo.', '2025-11-13 15:30:00'),
(9, 5, 2, 'La receta perfecta para celebraciones. Siempre es un éxito.', '2025-11-16 12:00:00'),
(9, 12, 2, 'Las proporciones de las leches son perfectas.', '2025-11-19 17:45:00'),
(9, 17, 1, '¿Cuánto tiempo debo dejarlo en el refrigerador mínimo?', '2025-11-23 11:30:00'),

-- Comentarios para Brownies (id_receta: 10)
(10, 3, 2, 'Los brownies quedaron perfectos, húmedos y chocolatosos como me gustan.', '2025-11-12 14:15:00'),
(10, 6, 2, 'Increíblemente fudgy. La mejor receta de brownies que he probado.', '2025-11-15 16:30:00'),
(10, 9, 2, 'El secreto está en no sobre-hornearlos. Quedan perfectos.', '2025-11-18 13:00:00'),
(10, 13, 2, 'Agregué chips de chocolate extra y quedaron aún mejor.', '2025-11-21 19:15:00'),

-- Comentarios para Tiramisu (id_receta: 11)
(11, 7, 2, 'Elegante y delicioso. Perfecto para cenas especiales.', '2025-11-16 20:00:00'),
(11, 10, 2, 'El amaretto le da un toque especial que no había probado antes.', '2025-11-19 15:45:00'),

-- Comentarios para Agua de Horchata (id_receta: 12)
(12, 4, 2, 'Perfecta para el calor, muy refrescante y con sabor auténtico.', '2025-11-11 11:30:00'),
(12, 8, 2, 'La canela le da un sabor increíble. Mucho mejor que la comprada.', '2025-11-14 16:00:00'),
(12, 11, 2, 'Refrescante y no demasiado dulce. Perfecta.', '2025-11-17 13:30:00'),

-- Comentarios para Mojito (id_receta: 13)
(13, 17, 2, 'El mojito perfecto. Las proporciones son exactas.', '2025-11-15 21:00:00'),
(13, 5, 2, 'Muy refrescante, ideal para el verano.', '2025-11-18 19:30:00'),

-- Comentarios para Ensalada César (id_receta: 14)
(14, 5, 2, 'La ensalada césar casera es mucho mejor que la del restaurante.', '2025-11-10 13:00:00'),
(14, 8, 2, 'El aderezo casero hace toda la diferencia.', '2025-11-13 12:15:00'),
(14, 12, 2, 'Los crutones caseros son el toque especial de esta receta.', '2025-11-16 18:45:00'),

-- Comentarios para Ensalada Griega (id_receta: 15)
(15, 13, 2, 'Fresca y saludable. La como casi todos los días.', '2025-11-12 14:30:00'),
(15, 6, 2, 'El queso feta auténtico hace la diferencia.', '2025-11-15 11:00:00'),

-- Comentarios para Sopa de Tortilla (id_receta: 16)
(16, 2, 2, 'Reconfortante y deliciosa. Perfecta para días fríos.', '2025-11-09 12:00:00'),
(16, 7, 2, 'Los totopos crujientes son esenciales en esta receta.', '2025-11-12 17:30:00'),
(16, 14, 2, 'El chile pasilla frito le da un sabor ahumado increíble.', '2025-11-16 13:15:00'),

-- Comentarios para Ajiaco (id_receta: 17)
(17, 4, 2, 'Como colombiano, confirmo que este ajiaco es auténtico.', '2025-11-11 15:00:00'),
(17, 10, 2, 'Las guascas son difíciles de conseguir pero valen totalmente la pena.', '2025-11-14 19:45:00'),

-- Comentarios para Pasta Primavera (id_receta: 18)
(18, 6, 2, 'Perfecta para los vegetarianos de la familia. Todos quedaron contentos.', '2025-11-08 18:00:00'),
(18, 9, 2, 'Saludable y deliciosa. La preparo semanalmente.', '2025-11-11 12:30:00'),
(18, 15, 2, 'Los vegetales al dente son clave en esta receta.', '2025-11-15 14:15:00'),

-- Comentarios para Curry de Verduras (id_receta: 19)
(19, 9, 2, 'Aromático y reconfortante. Mi curry favorito.', '2025-11-10 16:45:00'),
(19, 11, 2, 'La leche de coco le da una cremosidad perfecta.', '2025-11-13 13:00:00'),

-- Comentarios para Buddha Bowl (id_receta: 20)
(20, 6, 2, 'Bowl muy completo y nutritivo. Perfecto para el almuerzo.', '2025-11-07 12:00:00'),
(20, 11, 2, 'Los garbanzos asados son mi parte favorita.', '2025-11-10 14:30:00'),
(20, 18, 2, 'Colorido, nutritivo y delicioso. ¿Qué más se puede pedir?', '2025-11-14 11:15:00');

-- ============================================================
-- CALIFICACIONES (100+ calificaciones distribuidas)
-- ============================================================
INSERT INTO Calificaciones (id_receta, id_usuario, puntuacion, created_at) VALUES 
-- Calificaciones para receta 1 (Guacamole)
(1, 2, 5, '2025-11-20 14:35:00'),
(1, 3, 4, '2025-11-21 09:20:00'),
(1, 4, 5, '2025-11-21 15:00:00'),
(1, 5, 5, '2025-11-22 18:50:00'),
(1, 7, 4, '2025-11-23 10:00:00'),

-- Calificaciones para receta 2 (Bruschetta)
(2, 4, 5, '2025-11-19 16:25:00'),
(2, 6, 5, '2025-11-20 11:35:00'),
(2, 8, 4, '2025-11-21 13:00:00'),

-- Calificaciones para receta 3 (Ceviche)
(3, 7, 5, '2025-11-18 13:10:00'),
(3, 10, 5, '2025-11-21 17:35:00'),
(3, 12, 5, '2025-11-23 10:20:00'),
(3, 15, 4, '2025-11-23 16:00:00'),

-- Calificaciones para receta 4 (Tacos al Pastor)
(4, 2, 5, '2025-11-17 19:50:00'),
(4, 3, 5, '2025-11-18 11:00:00'),
(4, 4, 5, '2025-11-18 20:35:00'),
(4, 6, 5, '2025-11-20 12:10:00'),
(4, 8, 5, '2025-11-21 14:00:00'),
(4, 11, 5, '2025-11-22 16:50:00'),
(4, 13, 4, '2025-11-23 19:00:00'),

-- Calificaciones para receta 5 (Paella)
(5, 3, 5, '2025-11-16 14:25:00'),
(5, 8, 5, '2025-11-19 13:50:00'),
(5, 10, 4, '2025-11-20 16:00:00'),
(5, 12, 4, '2025-11-22 11:30:00'),

-- Calificaciones para receta 6 (Enchiladas Verdes)
(6, 2, 5, '2025-11-15 12:35:00'),
(6, 5, 5, '2025-11-18 19:20:00'),
(6, 9, 5, '2025-11-21 11:10:00'),
(6, 16, 4, '2025-11-23 15:35:00'),
(6, 18, 5, '2025-11-24 09:00:00'),

-- Calificaciones para receta 7 (Feijoada)
(7, 14, 5, '2025-11-17 13:10:00'),
(7, 8, 4, '2025-11-20 14:50:00'),
(7, 11, 4, '2025-11-22 16:00:00'),

-- Calificaciones para receta 8 (Flan Napolitano)
(8, 3, 5, '2025-11-14 16:10:00'),
(8, 4, 4, '2025-11-16 10:00:00'),
(8, 5, 5, '2025-11-17 18:00:00'),
(8, 7, 5, '2025-11-17 10:35:00'),
(8, 10, 5, '2025-11-20 18:20:00'),
(8, 15, 4, '2025-11-22 09:50:00'),

-- Calificaciones para receta 9 (Tres Leches)
(9, 2, 5, '2025-11-13 15:40:00'),
(9, 5, 5, '2025-11-16 12:10:00'),
(9, 6, 5, '2025-11-18 14:00:00'),
(9, 12, 5, '2025-11-19 17:50:00'),
(9, 14, 4, '2025-11-21 11:00:00'),

-- Calificaciones para receta 10 (Brownies)
(10, 2, 5, '2025-11-12 18:00:00'),
(10, 3, 5, '2025-11-12 14:20:00'),
(10, 4, 5, '2025-11-13 16:00:00'),
(10, 6, 5, '2025-11-15 16:35:00'),
(10, 9, 5, '2025-11-18 13:10:00'),
(10, 13, 5, '2025-11-21 19:20:00'),
(10, 16, 5, '2025-11-23 10:30:00'),

-- Calificaciones para receta 11 (Tiramisu)
(11, 7, 5, '2025-11-16 20:10:00'),
(11, 10, 5, '2025-11-19 15:50:00'),
(11, 15, 4, '2025-11-22 13:00:00'),

-- Calificaciones para receta 12 (Agua de Horchata)
(12, 4, 4, '2025-11-11 11:40:00'),
(12, 8, 5, '2025-11-14 16:10:00'),
(12, 11, 4, '2025-11-17 13:35:00'),
(12, 13, 4, '2025-11-20 10:00:00'),

-- Calificaciones para receta 13 (Mojito)
(13, 17, 5, '2025-11-15 21:10:00'),
(13, 5, 5, '2025-11-18 19:35:00'),
(13, 9, 4, '2025-11-21 20:00:00'),

-- Calificaciones para receta 14 (Ensalada César)
(14, 5, 5, '2025-11-10 13:10:00'),
(14, 8, 4, '2025-11-13 12:20:00'),
(14, 12, 5, '2025-11-16 18:50:00'),
(14, 14, 4, '2025-11-19 11:30:00'),

-- Calificaciones para receta 15 (Ensalada Griega)
(15, 13, 5, '2025-11-12 14:35:00'),
(15, 6, 4, '2025-11-15 11:10:00'),
(15, 10, 4, '2025-11-18 16:00:00'),

-- Calificaciones para receta 16 (Sopa de Tortilla)
(16, 2, 5, '2025-11-09 12:10:00'),
(16, 4, 4, '2025-11-11 15:00:00'),
(16, 7, 5, '2025-11-12 17:35:00'),
(16, 14, 5, '2025-11-16 13:20:00'),
(16, 16, 4, '2025-11-20 09:00:00'),

-- Calificaciones para receta 17 (Ajiaco)
(17, 4, 5, '2025-11-11 15:10:00'),
(17, 10, 5, '2025-11-14 19:50:00'),
(17, 12, 4, '2025-11-18 12:00:00'),

-- Calificaciones para receta 18 (Pasta Primavera)
(18, 6, 4, '2025-11-08 18:10:00'),
(18, 9, 4, '2025-11-11 12:40:00'),
(18, 11, 4, '2025-11-14 15:00:00'),
(18, 15, 5, '2025-11-15 14:20:00'),

-- Calificaciones para receta 19 (Curry de Verduras)
(19, 9, 5, '2025-11-10 16:50:00'),
(19, 11, 5, '2025-11-13 13:10:00'),
(19, 13, 4, '2025-11-17 11:00:00'),

-- Calificaciones para receta 20 (Buddha Bowl)
(20, 6, 5, '2025-11-07 12:10:00'),
(20, 11, 4, '2025-11-10 14:40:00'),
(20, 18, 5, '2025-11-14 11:20:00'),
(20, 19, 5, '2025-11-16 13:30:00'),

-- Calificaciones adicionales distribuidas
(1, 9, 4, '2025-11-23 15:00:00'),
(2, 10, 5, '2025-11-22 14:00:00'),
(3, 6, 5, '2025-11-20 16:30:00'),
(4, 14, 5, '2025-11-24 13:00:00'),
(5, 6, 4, '2025-11-17 10:30:00'),
(6, 7, 5, '2025-11-19 14:00:00'),
(7, 6, 4, '2025-11-21 10:30:00'),
(8, 6, 5, '2025-11-18 11:30:00'),
(9, 8, 5, '2025-11-17 15:00:00'),
(10, 5, 5, '2025-11-14 13:30:00'),
(11, 3, 4, '2025-11-18 09:00:00'),
(12, 5, 4, '2025-11-16 12:30:00'),
(13, 3, 5, '2025-11-19 20:00:00'),
(14, 6, 4, '2025-11-12 11:30:00'),
(15, 9, 4, '2025-11-17 14:00:00'),
(16, 8, 5, '2025-11-13 12:30:00'),
(17, 6, 4, '2025-11-15 11:00:00'),
(18, 5, 5, '2025-11-10 15:00:00'),
(19, 5, 4, '2025-11-12 16:00:00'),
(20, 9, 5, '2025-11-11 13:30:00');

-- ============================================================
-- ACTUALIZAR PUNTUACIÓN PROMEDIO DE RECETAS
-- ============================================================
UPDATE Recetas SET puntuacion_promedio = (
    SELECT ROUND(AVG(puntuacion), 2) 
    FROM Calificaciones 
    WHERE Calificaciones.id_receta = Recetas.id_receta
) WHERE id_receta IN (SELECT DISTINCT id_receta FROM Calificaciones);

-- ============================================================
-- RECETAS DESTACADAS (Favoritos de usuarios)
-- ============================================================
INSERT INTO Recetas_Destacadas (id_usuario, id_receta, created_at) VALUES 
-- Usuario 2 (Maria) - Le gustan platos principales mexicanos
(2, 1, '2025-11-20 15:00:00'),  -- Guacamole
(2, 4, '2025-11-17 20:00:00'),  -- Tacos al Pastor
(2, 10, '2025-11-12 18:30:00'), -- Brownies
(2, 16, '2025-11-09 12:30:00'), -- Sopa de Tortilla
(2, 6, '2025-11-15 13:00:00'),  -- Enchiladas Verdes

-- Usuario 3 (Juan) - Le gustan postres
(3, 8, '2025-11-14 16:30:00'),  -- Flan Napolitano
(3, 9, '2025-11-13 16:00:00'),  -- Tres Leches
(3, 10, '2025-11-12 14:40:00'), -- Brownies
(3, 11, '2025-11-16 15:00:00'), -- Tiramisu

-- Usuario 4 (Carlos) - Le gustan sopas y caldos
(4, 16, '2025-11-09 12:30:00'), -- Sopa de Tortilla
(4, 17, '2025-11-11 15:30:00'), -- Ajiaco
(4, 4, '2025-11-18 21:00:00'),  -- Tacos al Pastor
(4, 12, '2025-11-11 12:00:00'), -- Horchata

-- Usuario 5 (Laura) - Vegetariana
(5, 18, '2025-11-08 18:30:00'), -- Pasta Primavera
(5, 20, '2025-11-07 12:30:00'), -- Buddha Bowl
(5, 14, '2025-11-10 13:30:00'), -- Ensalada César
(5, 19, '2025-11-10 17:00:00'), -- Curry de Verduras
(5, 15, '2025-11-12 15:00:00'), -- Ensalada Griega

-- Usuario 6 (Roberto)
(6, 4, '2025-11-20 12:30:00'),  -- Tacos al Pastor
(6, 6, '2025-11-18 19:30:00'),  -- Enchiladas
(6, 20, '2025-11-07 12:40:00'), -- Buddha Bowl
(6, 18, '2025-11-08 18:30:00'), -- Pasta Primavera

-- Usuario 7 (Sofia) - Repostería
(7, 8, '2025-11-17 11:00:00'),  -- Flan
(7, 11, '2025-11-16 20:30:00'), -- Tiramisu
(7, 10, '2025-11-15 17:00:00'), -- Brownies
(7, 9, '2025-11-15 19:30:00'),  -- Tres Leches

-- Usuario 8 (Diego)
(8, 1, '2025-11-23 10:30:00'),  -- Guacamole
(8, 2, '2025-11-21 13:30:00'),  -- Bruschetta
(8, 5, '2025-11-19 14:00:00'),  -- Paella
(8, 7, '2025-11-20 15:00:00'),  -- Feijoada

-- Usuario 9 (Valentina) - Vegetariana
(9, 18, '2025-11-11 13:00:00'), -- Pasta Primavera
(9, 19, '2025-11-10 17:00:00'), -- Curry
(9, 20, '2025-11-10 15:00:00'), -- Buddha Bowl

-- Usuario 10 (Javier)
(10, 3, '2025-11-21 18:00:00'),  -- Ceviche
(10, 5, '2025-11-20 16:30:00'),  -- Paella
(10, 8, '2025-11-20 18:40:00'),  -- Flan

-- Usuario 11 (Isabella) - Vegana
(11, 20, '2025-11-10 15:00:00'), -- Buddha Bowl
(11, 18, '2025-11-15 11:00:00'), -- Pasta Primavera
(11, 19, '2025-11-13 13:30:00'), -- Curry

-- Usuario 12 (Miguel)
(12, 4, '2025-11-22 17:00:00'),  -- Tacos al Pastor
(12, 6, '2025-11-21 11:30:00'),  -- Enchiladas
(12, 3, '2025-11-23 10:40:00'),  -- Ceviche

-- Usuario 13 (Camila) - Ensaladas
(13, 14, '2025-11-16 19:00:00'), -- Ensalada César
(13, 15, '2025-11-12 15:00:00'), -- Ensalada Griega
(13, 20, '2025-11-14 11:40:00'), -- Buddha Bowl

-- Usuario 14 (Andres)
(14, 5, '2025-11-16 14:40:00'),  -- Paella
(14, 7, '2025-11-17 13:30:00'),  -- Feijoada
(14, 16, '2025-11-16 13:40:00'), -- Sopa de Tortilla

-- Usuario 15 (Lucia) - Repostería
(15, 10, '2025-11-15 19:00:00'), -- Brownies
(15, 11, '2025-11-22 13:30:00'), -- Tiramisu
(15, 8, '2025-11-22 10:00:00'),  -- Flan

-- Usuario 16 (Fernando)
(16, 6, '2025-11-23 16:00:00'),  -- Enchiladas
(16, 10, '2025-11-23 10:50:00'), -- Brownies
(16, 16, '2025-11-20 09:30:00'), -- Sopa de Tortilla

-- Usuario 17 (Daniela) - Bebidas
(17, 12, '2025-11-17 14:00:00'), -- Horchata
(17, 13, '2025-11-15 21:30:00'), -- Mojito

-- Usuario 18 (Gabriel)
(18, 6, '2025-11-24 09:30:00'),  -- Enchiladas
(18, 20, '2025-11-14 11:40:00'), -- Buddha Bowl

-- Usuario 19 (Natalia) - Sin Gluten
(19, 1, '2025-11-12 14:30:00'),  -- Guacamole
(19, 14, '2025-11-16 17:00:00'), -- Ensalada César

-- Usuario 20 (Ricardo)
(20, 4, '2025-11-18 15:00:00'),  -- Tacos
(20, 10, '2025-11-12 19:00:00'); -- Brownies

-- ============================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- ============================================================
SELECT 'Usuarios registrados:' as Info, COUNT(*) as Total FROM Usuarios
UNION ALL
SELECT 'Roles asignados:', COUNT(*) FROM Usuario_Rol
UNION ALL
SELECT 'Categorías:', COUNT(*) FROM Categorias
UNION ALL
SELECT 'Recetas creadas:', COUNT(*) FROM Recetas
UNION ALL
SELECT 'Comentarios totales:', COUNT(*) FROM Comentarios
UNION ALL
SELECT 'Comentarios aprobados:', COUNT(*) FROM Comentarios WHERE id_estado = 2
UNION ALL
SELECT 'Comentarios pendientes:', COUNT(*) FROM Comentarios WHERE id_estado = 1
UNION ALL
SELECT 'Comentarios rechazados:', COUNT(*) FROM Comentarios WHERE id_estado = 3
UNION ALL
SELECT 'Calificaciones:', COUNT(*) FROM Calificaciones
UNION ALL
SELECT 'Recetas destacadas:', COUNT(*) FROM Recetas_Destacadas
UNION ALL
SELECT 'Usuarios con rol admin:', COUNT(DISTINCT id_usuario) FROM Usuario_Rol WHERE id_rol = 2
UNION ALL
SELECT 'Usuarios con rol user:', COUNT(DISTINCT id_usuario) FROM Usuario_Rol WHERE id_rol = 1;

-- ============================================================
-- CONSULTAS DE VERIFICACIÓN ADICIONALES
-- ============================================================

-- Mostrar distribución de recetas por categoría
SELECT 
    c.nombre_categoria,
    COUNT(r.id_receta) as total_recetas,
    ROUND(AVG(r.puntuacion_promedio), 2) as puntuacion_promedio_categoria
FROM Categorias c
LEFT JOIN Recetas r ON c.id_categoria = r.id_categoria
GROUP BY c.id_categoria, c.nombre_categoria
ORDER BY total_recetas DESC;

-- Mostrar usuarios más activos (por comentarios)
SELECT 
    u.nombre_usuario,
    COUNT(c.id_comentario) as total_comentarios,
    COUNT(DISTINCT c.id_receta) as recetas_comentadas
FROM Usuarios u
INNER JOIN Comentarios c ON u.id_usuario = c.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario
ORDER BY total_comentarios DESC
LIMIT 10;

-- Mostrar usuarios más activos (por calificaciones)
SELECT 
    u.nombre_usuario,
    COUNT(cal.id_calificacion) as total_calificaciones,
    ROUND(AVG(cal.puntuacion), 2) as promedio_dado
FROM Usuarios u
INNER JOIN Calificaciones cal ON u.id_usuario = cal.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario
ORDER BY total_calificaciones DESC
LIMIT 10;

-- Recetas mejor calificadas
SELECT 
    r.nombre_receta,
    r.puntuacion_promedio,
    COUNT(cal.id_calificacion) as total_calificaciones,
    c.nombre_categoria,
    r.pais_origen
FROM Recetas r
INNER JOIN Calificaciones cal ON r.id_receta = cal.id_receta
INNER JOIN Categorias c ON r.id_categoria = c.id_categoria
GROUP BY r.id_receta
HAVING COUNT(cal.id_calificacion) >= 3
ORDER BY r.puntuacion_promedio DESC, total_calificaciones DESC
LIMIT 10;

-- Verificar integridad referencial
SELECT 'Todas las calificaciones tienen recetas válidas' as verificacion,
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS ✓'
        ELSE CONCAT('FAIL ✗ - ', COUNT(*), ' registros huérfanos')
    END as resultado
FROM Calificaciones cal
LEFT JOIN Recetas r ON cal.id_receta = r.id_receta
WHERE r.id_receta IS NULL

UNION ALL

SELECT 'Todos los comentarios tienen usuarios válidos',
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS ✓'
        ELSE CONCAT('FAIL ✗ - ', COUNT(*), ' registros huérfanos')
    END
FROM Comentarios com
LEFT JOIN Usuarios u ON com.id_usuario = u.id_usuario
WHERE u.id_usuario IS NULL

UNION ALL

SELECT 'Todas las recetas destacadas son válidas',
    CASE 
        WHEN COUNT(*) = 0 THEN 'PASS ✓'
        ELSE CONCAT('FAIL ✗ - ', COUNT(*), ' registros huérfanos')
    END
FROM Recetas_Destacadas rd
LEFT JOIN Recetas r ON rd.id_receta = r.id_receta
LEFT JOIN Usuarios u ON rd.id_usuario = u.id_usuario
WHERE r.id_receta IS NULL OR u.id_usuario IS NULL;
