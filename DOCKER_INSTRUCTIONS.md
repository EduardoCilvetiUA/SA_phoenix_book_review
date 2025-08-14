# Docker Setup for Phoenix Book Review

## Requisitos
- Docker Desktop instalado
- Docker Compose (incluido con Docker Desktop)

## Instrucciones de Uso

### 1. Configurar Variables de Entorno
El archivo `.env` ya está configurado con las variables necesarias. Docker Compose las leerá automáticamente.

### 2. Construir y Ejecutar la Aplicación
```bash
# Construir las imágenes y iniciar los servicios
docker-compose up --build

# O ejecutar en background
docker-compose up --build -d
```

### 3. Acceder a la Aplicación
Una vez que los contenedores estén ejecutándose:
- **Aplicación Web**: http://localhost:4000
- **Base de Datos PostgreSQL**: localhost:5432

### 4. Comandos Útiles

```bash
# Ver logs de la aplicación
docker-compose logs web

# Ver logs de la base de datos
docker-compose logs db

# Ejecutar comandos dentro del contenedor de la aplicación
docker-compose exec web mix ecto.reset

# Parar los servicios
docker-compose down

# Parar y eliminar volúmenes (cuidado: borra la base de datos)
docker-compose down -v
```

### 5. Estructura de Servicios

**Database (db)**:
- PostgreSQL 15 Alpine
- Puerto: 5432
- Volumen persistente para datos
- Healthcheck incluido

**Web Application (web)**:
- Imagen personalizada con Elixir 1.18
- Puerto: 4000
- Auto-ejecuta migraciones y seeds al iniciar
- Monta el código fuente para desarrollo

### 6. Variables de Entorno Utilizadas

Todas las variables se leen del archivo `.env`:
- `DATABASE_PASSWORD`: Contraseña de PostgreSQL
- `SECRET_KEY_BASE`: Clave secreta de Phoenix
- `PHX_HOST`: Host de la aplicación
- `PHX_PORT`: Puerto de la aplicación
- `MIX_ENV`: Entorno de Elixir

### 7. Resolución de Problemas

**Si la aplicación no inicia:**
```bash
# Revisar logs
docker-compose logs

# Reconstruir sin cache
docker-compose build --no-cache

# Reiniciar servicios
docker-compose restart
```

**Si hay problemas con la base de datos:**
```bash
# Verificar que PostgreSQL esté listo
docker-compose exec db pg_isready -U postgres

# Recrear la base de datos
docker-compose exec web mix ecto.reset
```

### 8. Desarrollo

Para desarrollo activo, el código se monta como volumen, por lo que los cambios se reflejan automáticamente. Sin embargo, para cambios en dependencias:

```bash
# Reconstruir la imagen
docker-compose build web

# Reiniciar el servicio web
docker-compose restart web
```

## Notas Importantes

- Los datos de PostgreSQL persisten en un volumen Docker
- La primera ejecución tardará más porque debe construir la imagen
- El servicio web espera a que PostgreSQL esté listo antes de iniciar
- Las migraciones y seeds se ejecutan automáticamente al iniciar