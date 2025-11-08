# API Contracts - Recipes Backend

Base URL: `http://localhost:8080/api`

## Autenticación

### Endpoints Públicos
Los siguientes endpoints NO requieren autenticación:
- `POST /auth/register`
- `POST /auth/login`
- `GET /recipes`
- `GET /recipes/{id}`
- `GET /recipes/featured`
- `GET /categories`
- `GET /files/**` (acceso público a imágenes)

### Endpoints Protegidos
Todos los demás endpoints requieren un token JWT en el header de autorización.

---

## Ejemplos de Uso con jQuery/AJAX

### Petición sin autenticación (GET)
```javascript
$.ajax({
    url: 'http://localhost:8080/api/recipes',
    type: 'GET'
}).done(function(data) {
    // data es un array
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición sin autenticación (POST) con body
```javascript
$.ajax({
    url: 'http://localhost:8080/api/auth/login',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify({
        emailOrUsername: 'string',
        password: 'string'
    })
}).done(function(response) {
    // response.token, response.user
    localStorage.setItem('token', response.token);
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición con autenticación (GET)
```javascript
$.ajax({
    url: 'http://localhost:8080/api/profile/me',
    type: 'GET',
    headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
    }
}).done(function(data) {
    // data es un objeto
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición con autenticación (POST/PUT) con body
```javascript
$.ajax({
    url: 'http://localhost:8080/api/recipes/1/comments',
    type: 'POST',
    headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
    },
    contentType: 'application/json',
    data: JSON.stringify({
        contenido: 'string'
    })
}).done(function(data) {
    // data es un objeto
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición con autenticación (DELETE)
```javascript
$.ajax({
    url: 'http://localhost:8080/api/admin/recipes/1',
    type: 'DELETE',
    headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
    }
}).done(function() {
    // Sin respuesta (204)
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición con query parameters
```javascript
$.ajax({
    url: 'http://localhost:8080/api/recipes',
    type: 'GET',
    data: {
        categoria: 1,        // number
        busqueda: 'string',  // string
        page: 0,             // number
        size: 10             // number
    }
}).done(function(data) {
    // data es un array
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición con archivo (multipart/form-data)
```javascript
// HTML: <input type="file" id="imageInput">
var formData = new FormData();
formData.append('file', $('#imageInput')[0].files[0]);

$.ajax({
    url: 'http://localhost:8080/api/files/upload',
    type: 'POST',
    headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
    },
    data: formData,
    processData: false,
    contentType: false
}).done(function(response) {
    // response.filePath = "/uploads/recipes/uuid.jpg"
    console.log('Imagen guardada en:', response.filePath);
}).fail(function(xhr) {
    // Manejar error
});
```

### Petición con archivo + JSON (receta con imagen)
```javascript
var recipeData = {
    titulo: 'string',
    descripcion: 'string',
    ingredientes: 'string',
    instrucciones: 'string',
    categoriaId: 1
};

var formData = new FormData();
formData.append('recipe', JSON.stringify(recipeData));
formData.append('image', $('#imageInput')[0].files[0]);

$.ajax({
    url: 'http://localhost:8080/api/recipes/with-image',
    type: 'POST',
    headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
    },
    data: formData,
    processData: false,
    contentType: false
}).done(function(recipe) {
    // recipe.imagenUrl = "/uploads/recipes/uuid.jpg"
    var imageUrl = 'http://localhost:8080/api/files/images/' + recipe.imagenUrl.split('/').pop();
}).fail(function(xhr) {
    // Manejar error
});
```

---

## Endpoints Públicos

### POST /auth/register
Registrar nuevo usuario.

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "nombre": "string",
  "apellido": "string"
}
```

**Response:** `200 OK`
```json
{
  "token": "string",
  "type": "Bearer",
  "expiresIn": 86400000,
  "user": {
    "id": "number",
    "username": "string",
    "email": "string",
    "nombre": "string",
    "apellido": "string",
    "role": "string"
  }
}
```

**Redirigir a:** `/` (página principal)

---

### POST /auth/login
Iniciar sesión.

**Request Body:**
```json
{
  "emailOrUsername": "string",
  "password": "string"
}
```

**Response:** `200 OK`
```json
{
  "token": "string",
  "type": "Bearer",
  "expiresIn": 86400000,
  "user": {
    "id": "number",
    "username": "string",
    "email": "string",
    "nombre": "string",
    "apellido": "string",
    "role": "string"
  }
}
```

**Redirigir a:** `/` (página principal)

---

### POST /auth/logout
Cerrar sesión.

**Headers:** Requiere autenticación

**Response:** `200 OK`

**Redirigir a:** `/login.html`

---

### GET /auth/validate
Validar token actual.

**Headers:** Requiere autenticación

**Response:** `200 OK`
```json
{
  "valid": "boolean",
  "user": {
    "id": "number",
    "username": "string",
    "role": "string"
  }
}
```

---

## Archivos e Imágenes

### POST /files/upload
Subir una imagen al servidor.

**Headers:** Requiere autenticación

**Content-Type:** `multipart/form-data`

**Form Data:**
- `file`: Archivo de imagen (jpg, jpeg, png, gif, webp)

**Validaciones:**
- Tamaño máximo: 5MB
- Extensiones permitidas: .jpg, .jpeg, .png, .gif, .webp

**Response:** `200 OK`
```json
{
  "fileName": "string",
  "filePath": "/uploads/recipes/550e8400-e29b-41d4-a716-446655440000.jpg",
  "fileSize": "string",
  "message": "Archivo subido exitosamente"
}
```

**Nota:** El `filePath` es una ruta relativa que se debe guardar en la base de datos.

---

### GET /files/images/{fileName}
Obtener una imagen del servidor.

**Acceso:** Público (sin autenticación)

**Response:** `200 OK`
- Content-Type: `image/jpeg`, `image/png`, etc.
- Body: Contenido binario de la imagen

**Ejemplo de uso:**
```html
<img src="http://localhost:8080/api/files/images/550e8400-e29b-41d4-a716-446655440000.jpg" 
     alt="Imagen de receta">
```

**Nota:** Para obtener la URL completa de una imagen desde el campo `imagenUrl` de la base de datos:
```javascript
// imagenUrl de BD: "/uploads/recipes/uuid.jpg"
var fileName = imagenUrl.split('/').pop(); // "uuid.jpg"
var fullUrl = 'http://localhost:8080/api/files/images/' + fileName;
```

---

### GET /files/download/{fileName}
Descargar una imagen (fuerza descarga en lugar de mostrar).

**Acceso:** Público (sin autenticación)

**Response:** `200 OK`
- Content-Type: `application/octet-stream` o tipo MIME de la imagen
- Content-Disposition: `attachment; filename="..."`

---

## Recetas

### GET /recipes
Listar todas las recetas.

**Query Parameters:**
- `categoria` (optional): `number` - ID de categoría
- `busqueda` (optional): `string` - Término de búsqueda
- `page` (optional): `number` - Número de página (default: 0)
- `size` (optional): `number` - Tamaño de página (default: 10)

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "titulo": "string",
    "descripcion": "string",
    "ingredientes": "string",
    "instrucciones": "string",
    "tiempoPreparacion": "number",
    "porciones": "number",
    "imagenUrl": "string",
    "fechaCreacion": "string (ISO 8601)",
    "autorNombre": "string",
    "autorId": "number",
    "categoriaNombre": "string",
    "categoriaId": "number",
    "calificacionPromedio": "number",
    "totalCalificaciones": "number",
    "totalComentarios": "number"
  }
]
```

**Mostrar en:** `/index.html`, `/recipes.html`

---

### GET /recipes/{id}
Obtener detalle de una receta.

**Response:** `200 OK`
```json
{
  "id": "number",
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "string",
  "fechaCreacion": "string (ISO 8601)",
  "autorNombre": "string",
  "autorId": "number",
  "categoriaNombre": "string",
  "categoriaId": "number",
  "calificacionPromedio": "number",
  "totalCalificaciones": "number",
  "totalComentarios": "number"
}
```

**Mostrar en:** `/recipe-detail.html`

---

### GET /recipes/featured
Obtener recetas destacadas.

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "titulo": "string",
    "descripcion": "string",
    "ingredientes": "string",
    "instrucciones": "string",
    "tiempoPreparacion": "number",
    "porciones": "number",
    "imagenUrl": "string",
    "fechaCreacion": "string (ISO 8601)",
    "autorNombre": "string",
    "autorId": "number",
    "categoriaNombre": "string",
    "categoriaId": "number",
    "calificacionPromedio": "number",
    "totalCalificaciones": "number",
    "totalComentarios": "number"
  }
]
```

**Mostrar en:** `/index.html` (carrusel o sección destacada)

---

### GET /recipes/{id}/comments
Obtener comentarios de una receta.

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "contenido": "string",
    "fechaCreacion": "string (ISO 8601)",
    "usuarioNombre": "string",
    "usuarioId": "number",
    "recetaId": "number",
    "recetaTitulo": "string",
    "estadoNombre": "string",
    "estadoId": "number"
  }
]
```

**Mostrar en:** `/recipe-detail.html` (sección de comentarios)

---

### POST /recipes/{id}/comments
Agregar comentario a una receta.

**Headers:** Requiere autenticación

**Request Body:**
```json
{
  "contenido": "string"
}
```

**Response:** `201 Created`
```json
{
  "id": "number",
  "contenido": "string",
  "fechaCreacion": "string (ISO 8601)",
  "usuarioNombre": "string",
  "usuarioId": "number",
  "recetaId": "number",
  "recetaTitulo": "string",
  "estadoNombre": "string",
  "estadoId": "number"
}
```

**Nota:** El comentario tendrá estado `PENDING` hasta ser aprobado por un administrador.

---

### GET /recipes/{id}/ratings
Obtener calificaciones de una receta.

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "puntuacion": "number",
    "fechaCalificacion": "string (ISO 8601)",
    "usuarioId": "number",
    "recetaId": "number"
  }
]
```

---

### POST /recipes/{id}/ratings
Calificar una receta.

**Headers:** Requiere autenticación

**Request Body:**
```json
{
  "puntuacion": "number (1-5)"
}
```

**Response:** `201 Created`
```json
{
  "id": "number",
  "puntuacion": "number",
  "fechaCalificacion": "string (ISO 8601)",
  "usuarioId": "number",
  "recetaId": "number"
}
```

---

### POST /recipes/with-image
Crear una receta con imagen.

**Headers:** Requiere autenticación

**Content-Type:** `multipart/form-data`

**Form Data:**
- `recipe`: JSON string con los datos de la receta
- `image`: Archivo de imagen (opcional)

**Ejemplo de recipe JSON:**
```json
{
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "categoriaId": "number"
}
```

**Response:** `201 Created`
```json
{
  "id": "number",
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "/uploads/recipes/uuid.jpg",
  "fechaCreacion": "string (ISO 8601)",
  "autorNombre": "string",
  "autorId": "number",
  "categoriaNombre": "string",
  "categoriaId": "number",
  "calificacionPromedio": "number",
  "totalCalificaciones": "number",
  "totalComentarios": "number"
}
```

**Notas:**
- Si se proporciona una imagen, se guarda automáticamente y su ruta se asigna a `imagenUrl`
- Si no se proporciona imagen, `imagenUrl` será null
- El campo `imagenUrl` contiene la ruta relativa (ej: `/uploads/recipes/uuid.jpg`)

**Mostrar en:** `/create-recipe.html`

---

### PUT /recipes/{id}/with-image
Actualizar una receta con nueva imagen.

**Headers:** Requiere autenticación

**Content-Type:** `multipart/form-data`

**Form Data:**
- `recipe`: JSON string con los datos actualizados
- `image`: Archivo de imagen (opcional)

**Ejemplo de recipe JSON:**
```json
{
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "categoriaId": "number"
}
```

**Response:** `200 OK`
```json
{
  "id": "number",
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "/uploads/recipes/uuid.jpg",
  "fechaCreacion": "string (ISO 8601)",
  "autorNombre": "string",
  "autorId": "number",
  "categoriaNombre": "string",
  "categoriaId": "number",
  "calificacionPromedio": "number",
  "totalCalificaciones": "number",
  "totalComentarios": "number"
}
```

**Comportamiento:**
- Si se proporciona una nueva imagen, la imagen anterior se elimina automáticamente
- Si no se proporciona imagen, se mantiene la imagen existente
- Solo el autor de la receta o un administrador puede actualizarla

**Mostrar en:** `/edit-recipe.html`

---

## Perfil de Usuario

Todos estos endpoints requieren autenticación.

### GET /profile/me
Obtener perfil del usuario autenticado.

**Headers:** Requiere autenticación

**Response:** `200 OK`
```json
{
  "id": "number",
  "username": "string",
  "email": "string",
  "nombre": "string",
  "apellido": "string",
  "fechaRegistro": "string (ISO 8601)",
  "totalRecetas": "number",
  "totalComentarios": "number",
  "totalCalificaciones": "number"
}
```

**Mostrar en:** `/profile.html`

---

### PUT /profile/me
Actualizar perfil del usuario autenticado.

**Headers:** Requiere autenticación

**Request Body:**
```json
{
  "nombre": "string",
  "apellido": "string",
  "email": "string"
}
```

**Response:** `200 OK`
```json
{
  "id": "number",
  "username": "string",
  "email": "string",
  "nombre": "string",
  "apellido": "string",
  "fechaRegistro": "string (ISO 8601)",
  "totalRecetas": "number",
  "totalComentarios": "number",
  "totalCalificaciones": "number"
}
```

---

### GET /profile/favorites
Obtener recetas favoritas del usuario.

**Headers:** Requiere autenticación

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "titulo": "string",
    "descripcion": "string",
    "ingredientes": "string",
    "instrucciones": "string",
    "tiempoPreparacion": "number",
    "porciones": "number",
    "imagenUrl": "string",
    "fechaCreacion": "string (ISO 8601)",
    "autorNombre": "string",
    "autorId": "number",
    "categoriaNombre": "string",
    "categoriaId": "number",
    "calificacionPromedio": "number",
    "totalCalificaciones": "number",
    "totalComentarios": "number"
  }
]
```

**Mostrar en:** `/favorites.html`

---

### POST /profile/favorites/{recipeId}
Agregar receta a favoritos.

**Headers:** Requiere autenticación

**Response:** `200 OK`

---

### DELETE /profile/favorites/{recipeId}
Eliminar receta de favoritos.

**Headers:** Requiere autenticación

**Response:** `204 No Content`

---

### GET /profile/my-recipes
Obtener recetas creadas por el usuario.

**Headers:** Requiere autenticación

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "titulo": "string",
    "descripcion": "string",
    "ingredientes": "string",
    "instrucciones": "string",
    "tiempoPreparacion": "number",
    "porciones": "number",
    "imagenUrl": "string",
    "fechaCreacion": "string (ISO 8601)",
    "autorNombre": "string",
    "autorId": "number",
    "categoriaNombre": "string",
    "categoriaId": "number",
    "calificacionPromedio": "number",
    "totalCalificaciones": "number",
    "totalComentarios": "number"
  }
]
```

**Mostrar en:** `/my-recipes.html`

---

### GET /profile/my-comments
Obtener comentarios del usuario.

**Headers:** Requiere autenticación

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "contenido": "string",
    "fechaCreacion": "string (ISO 8601)",
    "usuarioNombre": "string",
    "usuarioId": "number",
    "recetaId": "number",
    "recetaTitulo": "string",
    "estadoNombre": "string",
    "estadoId": "number"
  }
]
```

**Mostrar en:** `/my-comments.html`

---

## Administración

Todos estos endpoints requieren autenticación con rol ADMIN.

### Gestión de Recetas

#### POST /admin/recipes
Crear nueva receta.

**Headers:** Requiere autenticación (rol ADMIN)

**Request Body:**
```json
{
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "string",
  "categoriaId": "number"
}
```

**Response:** `201 Created`
```json
{
  "id": "number",
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "string",
  "fechaCreacion": "string (ISO 8601)",
  "autorNombre": "string",
  "autorId": "number",
  "categoriaNombre": "string",
  "categoriaId": "number",
  "calificacionPromedio": "number",
  "totalCalificaciones": "number",
  "totalComentarios": "number"
}
```

**Mostrar en:** `/admin/recipes.html`

---

#### PUT /admin/recipes/{id}
Actualizar receta existente.

**Headers:** Requiere autenticación (rol ADMIN)

**Request Body:**
```json
{
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "string",
  "categoriaId": "number"
}
```

**Response:** `200 OK`
```json
{
  "id": "number",
  "titulo": "string",
  "descripcion": "string",
  "ingredientes": "string",
  "instrucciones": "string",
  "tiempoPreparacion": "number",
  "porciones": "number",
  "imagenUrl": "string",
  "fechaCreacion": "string (ISO 8601)",
  "autorNombre": "string",
  "autorId": "number",
  "categoriaNombre": "string",
  "categoriaId": "number",
  "calificacionPromedio": "number",
  "totalCalificaciones": "number",
  "totalComentarios": "number"
}
```

---

#### DELETE /admin/recipes/{id}
Eliminar una receta.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `204 No Content`

**Nota:** Al eliminar una receta, su imagen asociada también se elimina automáticamente del servidor.

---

#### POST /admin/recipes/{id}/feature
Destacar una receta.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`

---

#### DELETE /admin/recipes/{id}/feature
Quitar receta de destacadas.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `204 No Content`

---

### Gestión de Usuarios

#### GET /admin/users
Listar todos los usuarios.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "username": "string",
    "email": "string",
    "nombre": "string",
    "apellido": "string",
    "role": "string"
  }
]
```

**Mostrar en:** `/admin/users.html`

---

#### DELETE /admin/users/{id}
Eliminar usuario.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `204 No Content`

---

#### PUT /admin/users/{id}/toggle-status
Activar/desactivar usuario.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`

---

### Moderación de Comentarios

#### GET /admin/comments/pending
Listar comentarios pendientes de aprobación.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "contenido": "string",
    "fechaCreacion": "string (ISO 8601)",
    "usuarioNombre": "string",
    "usuarioId": "number",
    "recetaId": "number",
    "recetaTitulo": "string",
    "estadoNombre": "string",
    "estadoId": "number"
  }
]
```

**Mostrar en:** `/admin/comments.html`

---

#### PUT /admin/comments/{id}/approve
Aprobar comentario.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
{
  "id": "number",
  "contenido": "string",
  "fechaCreacion": "string (ISO 8601)",
  "usuarioNombre": "string",
  "usuarioId": "number",
  "recetaId": "number",
  "recetaTitulo": "string",
  "estadoNombre": "string",
  "estadoId": "number"
}
```

---

#### PUT /admin/comments/{id}/reject
Rechazar comentario.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
{
  "id": "number",
  "contenido": "string",
  "fechaCreacion": "string (ISO 8601)",
  "usuarioNombre": "string",
  "usuarioId": "number",
  "recetaId": "number",
  "recetaTitulo": "string",
  "estadoNombre": "string",
  "estadoId": "number"
}
```

---

#### DELETE /admin/comments/{id}
Eliminar comentario.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `204 No Content`

---

### Gestión de Categorías

#### GET /admin/categories
Listar todas las categorías.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "nombre": "string",
    "descripcion": "string",
    "totalRecetas": "number"
  }
]
```

**Mostrar en:** `/admin/categories.html`

---

#### POST /admin/categories
Crear nueva categoría.

**Headers:** Requiere autenticación (rol ADMIN)

**Request Body:**
```json
{
  "nombre": "string",
  "descripcion": "string"
}
```

**Response:** `201 Created`
```json
{
  "id": "number",
  "nombre": "string",
  "descripcion": "string",
  "totalRecetas": "number"
}
```

---

#### PUT /admin/categories/{id}
Actualizar categoría.

**Headers:** Requiere autenticación (rol ADMIN)

**Request Body:**
```json
{
  "nombre": "string",
  "descripcion": "string"
}
```

**Response:** `200 OK`
```json
{
  "id": "number",
  "nombre": "string",
  "descripcion": "string",
  "totalRecetas": "number"
}
```

---

#### DELETE /admin/categories/{id}
Eliminar categoría.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `204 No Content`

---

### Reportes

#### GET /admin/reports
Obtener reportes del sistema.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
{
  "totalUsuarios": "number",
  "totalRecetas": "number",
  "totalComentarios": "number",
  "comentariosPendientes": "number",
  "promedioCalificaciones": "number"
}
```

**Mostrar en:** `/admin/reports.html`

---

#### GET /admin/dashboard
Obtener estadísticas del dashboard.

**Headers:** Requiere autenticación (rol ADMIN)

**Response:** `200 OK`
```json
{
  "usuariosActivos": "number",
  "recetasPublicadas": "number",
  "comentariosHoy": "number",
  "calificacionesHoy": "number",
  "recetasMasVistas": "array",
  "usuariosMasActivos": "array"
}
```

**Mostrar en:** `/admin/dashboard.html`

---

## Categorías (Público)

### GET /categories
Listar todas las categorías disponibles.

**Response:** `200 OK`
```json
[
  {
    "id": "number",
    "nombre": "string",
    "descripcion": "string",
    "totalRecetas": "number"
  }
]
```

**Mostrar en:** `/index.html`, `/recipes.html` (filtros)

---

## Códigos de Error

| Código | Descripción |
|--------|-------------|
| 400 | Bad Request - Datos inválidos |
| 401 | Unauthorized - Token inválido o ausente |
| 403 | Forbidden - Sin permisos suficientes |
| 404 | Not Found - Recurso no encontrado |
| 409 | Conflict - Recurso duplicado (ej: email existente) |
| 500 | Internal Server Error |

**Formato de Error:**
```json
{
  "timestamp": "string (ISO 8601)",
  "status": "number",
  "error": "string",
  "message": "string",
  "path": "string"
}
```

---

## Notas Importantes

1. **Fechas:** Todas las fechas están en formato ISO 8601 (UTC). Ejemplo: `"2024-01-01T10:00:00"`
2. **CORS:** El backend acepta peticiones desde `http://localhost:3000`, `http://127.0.0.1:5500` y `http://localhost:5500`.
3. **Token JWT:** 
   - Los tokens expiran después de 24 horas (86400000 ms).
   - Almacenar después del login/registro: `localStorage.setItem('token', response.token)`
   - Incluir en header: `'Authorization': 'Bearer ' + localStorage.getItem('token')`
4. **Validaciones:** 
   - Calificaciones: Valores entre 1 y 5
   - Campos requeridos: No pueden ser nulos o vacíos
   - Email: Debe tener formato válido
5. **Estados de Comentarios:** `PENDING`, `APPROVED`, `REJECTED`
6. **Imágenes:**
   - Tamaño máximo: 5MB
   - Formatos permitidos: JPG, JPEG, PNG, GIF, WebP
   - Las imágenes se guardan con nombres únicos (UUID) en `/uploads/recipes/`
   - El campo `imagenUrl` en la base de datos almacena la ruta relativa
   - Para mostrar una imagen: `http://localhost:8080/api/files/images/{fileName}`
   - Al eliminar una receta o actualizar su imagen, los archivos antiguos se eliminan automáticamente
7. **Multipart/Form-Data:**
   - Usar `FormData()` para enviar archivos
   - Establecer `processData: false` y `contentType: false` en jQuery
   - El campo `recipe` debe ser un JSON string (usar `JSON.stringify()`)
8. **Tipos de datos:**
   - `"string"` = texto
   - `"number"` = número (entero o decimal)
   - `"boolean"` = true/false
   - `"array"` = arreglo []
   - `"string (ISO 8601)"` = fecha en formato texto
