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
- Desde `pages/admin/`: `../../libs/`
- Desde `pages/user/`: `../../libs/`
- Desde `pages/public/`: `../../libs/`

## Notas
- Todos los archivos originales se mantuvieron intactos
- Solo se reorganizó la estructura de carpetas
- Los nombres de carpetas se estandarizaron usando kebab-case
- Las librerías están centralizadas en una sola ubicación
