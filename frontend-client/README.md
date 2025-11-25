# Estructura del Frontend - Recetas Deliciosas

## Organización de Carpetas

```
frontend-client/
├── pages/
│   ├── admin/                    # Páginas de administrador
│   │   ├── dashboard/            # Panel principal de admin
│   │   ├── crear-receta/         # Crear nueva receta
│   │   ├── gestionar-recetas/    # CRUD de recetas
│   │   ├── gestionar-usuarios/   # Gestión de usuarios
│   │   ├── moderar-comentarios/  # Moderación de comentarios
│   │   ├── info-usuario/         # Información de usuario seleccionado
│   │   └── reportes/             # Reportes y estadísticas
│   │
│   ├── user/                     # Páginas de usuario
│   │   ├── inicio/               # Pantalla principal de usuario
│   │   ├── perfil/               # Perfil de usuario
│   │   ├── recetas-destacadas/   # Recetas favoritas/destacadas
│   │   ├── detalle-receta/       # Detalle de una receta
│   │   └── acerca-de-nosotros/   # Página informativa
│   │
│   └── public/                   # Páginas públicas (sin autenticación)
│       ├── bienvenida/           # Página de bienvenida
│       └── login/                # Inicio de sesión y registro
│
└── libs/                         # Librerías externas
    ├── bootstrap/                # Bootstrap CSS/JS
    ├── bootstrap-icons/          # Iconos de Bootstrap
    ├── jquery-ui/                # jQuery UI
    └── jquery-4.0.0-rc.1.min.js  # jQuery Core

```

## Convenciones de Nombres

### Carpetas
- Páginas de admin: `admin/nombre-funcionalidad/`
- Páginas de usuario: `user/nombre-funcionalidad/`
- Páginas públicas: `public/nombre-funcionalidad/`
- Librerías: `libs/nombre-libreria/`

### Archivos
- HTML: Mantienen sus nombres originales dentro de cada carpeta
- CSS: `style.css` o nombre descriptivo
- JS: `script.js` o nombre descriptivo

## Rutas Relativas

Ahora que las carpetas están reorganizadas, las rutas relativas entre páginas siguen este patrón:

### Desde una página de admin a otra página de admin:
```html
<a href="../otra-pagina/archivo.html">Enlace</a>
```

### Desde una página de admin a usuario:
```html
<a href="../../user/nombre-pagina/archivo.html">Enlace</a>
```

### Desde cualquier página a las librerías:
- Desde `pages/admin/`: `../../../libs/`
- Desde `pages/user/`: `../../../libs/`
- Desde `pages/public/`: `../../../libs/`

### Ejemplos de rutas a librerías:
```html
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="../../../libs/bootstrap/css/bootstrap.min.css">

<!-- Bootstrap Icons -->
<link rel="stylesheet" href="../../../libs/bootstrap-icons/bootstrap-icons.css">

<!-- jQuery -->
<script src="../../../libs/jquery-4.0.0-rc.1.min.js"></script>

<!-- Bootstrap JS -->
<script src="../../../libs/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- jQuery UI -->
<script src="../../../libs/jquery-ui/jquery-ui.min.js"></script>
```

## Notas
- Todos los archivos originales se mantuvieron intactos
- Solo se reorganizó la estructura de carpetas
- Los nombres de carpetas se estandarizaron usando kebab-case
- Las librerías están centralizadas en una sola ubicación
- **✅ Todas las rutas de navegación actualizadas**
- **✅ Todas las referencias a librerías actualizadas**
- Las páginas que usan CDN (bienvenida, login, detalle-receta, recetas-destacadas, acerca-de-nosotros) no necesitan actualización

## Resumen de Actualizaciones

### Rutas de Librerías Actualizadas ✅
Todas las páginas ahora usan las rutas correctas:
- `../../../libs/bootstrap/css/bootstrap.min.css`
- `../../../libs/bootstrap/js/bootstrap.bundle.min.js`
- `../../../libs/bootstrap-icons/bootstrap-icons.css`
- `../../../libs/jquery-4.0.0-rc.1.min.js`
- `../../../libs/jquery-ui/jquery-ui.min.js`

### Rutas de Navegación Actualizadas ✅
- **Páginas de Admin**: Todos los enlaces entre páginas de administrador usan los nuevos nombres
- **Páginas de Usuario**: Todos los enlaces de navegación usan los nuevos nombres de carpetas
- **Navegación Cruzada**: Enlaces entre secciones funcionan correctamente
