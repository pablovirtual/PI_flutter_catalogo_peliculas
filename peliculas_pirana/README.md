# 🎬 Películas Piraña

Aplicación móvil desarrollada en Flutter para la gestión y visualización de un catálogo de películas. Este proyecto integra servicios en la nube (Firebase) y APIs externas (TMDB) para ofrecer una experiencia completa de usuario.

## 🚀 Características Principales

### 1. Autenticación de Usuarios
- **Registro y Login:** Sistema seguro mediante Firebase Authentication (Email/Password).
- **Sesión Persistente:** La aplicación recuerda al usuario logueado.
- **Menú Personalizado:** El menú lateral muestra el correo del usuario actual.

### 2. Catálogo Híbrido
La pantalla principal combina dos fuentes de datos:
- **Películas Personales (Firebase):** Las que el usuario agrega manualmente. Se muestran primero con un distintivo "✨ Tu película".
- **Películas Populares (TMDB API):** Las 20 películas más populares del momento obtenidas en tiempo real desde The Movie Database.

### 3. Gestión de Contenido (CRUD Completo)
El usuario tiene control total sobre sus propias películas:
- **Crear:** Agregar nuevas películas con título, año, director, género, sinopsis y URL de imagen (con vista previa).
- **Leer:** Visualizar todas las películas en el catálogo.
- **Actualizar:** Editar cualquier dato de sus películas existentes.
- **Eliminar:** Borrar películas de su colección personal.

### 4. Detalles de Película
- Pantalla dedicada con información extendida.
- Visualización de póster en alta calidad.
- Ficha técnica completa (Director, Año, Género).

## 🛠️ Arquitectura y Tecnologías

El proyecto sigue una arquitectura limpia basada en servicios y proveedores:

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Firestore Database & Authentication)
- **API Externa:** The Movie Database (TMDB)
- **Gestión de Estado:** Provider Pattern

### Estructura de Carpetas
- `lib/models`: Modelos de datos (`MovieModel`).
- `lib/screens`: Pantallas de la UI (`Login`, `Catalog`, `Crud`, `Detail`, `Welcome`).
- `lib/services`: Lógica de negocio (`AuthService`, `DatabaseService`, `TMDBService`).

## 📱 Guía de Uso

1. **Inicio:** Al abrir la app, verás la pantalla de bienvenida.
2. **Acceso:** Regístrate con un correo nuevo o inicia sesión.
3. **Navegación:**
   - Usa el menú lateral (☰) para navegar.
   - **Catálogo:** Ver películas. Toca una para ver detalles.
   - **Agregar Películas:** Abre el gestor para crear o editar.
4. **Gestión:**
   - Para **editar**: Toca el lápiz azul (✏️) en la lista de gestión.
   - Para **eliminar**: Toca el basurero rojo (🗑️).

## 🔧 Configuración para Desarrollo

1. Clonar el repositorio.
2. Asegurar tener `flutter` instalado.
3. Configurar proyecto de Firebase y agregar `google-services.json` en `android/app/`.
4. Ejecutar `flutter pub get` para instalar dependencias.
5. Correr con `flutter run`.

---
**Desarrollado para Proyecto Universitario - UDG Virtual**
