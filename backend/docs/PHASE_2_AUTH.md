# Fase 2: Autenticación y Rutas Protegidas

Este documento explica la arquitectura de la autenticación implementada en la Fase 2 del backend de SafeAccess 90.

## Flujo de Autenticación
1. El usuario envía sus credenciales (email y password) al endpoint `POST /api/auth/login`.
2. El `AuthService` verifica que el usuario exista y esté activo en PostgreSQL.
3. Se valida el password usando `bcrypt.compare`.
4. Si es exitoso, se firma y devuelve un JWT que contiene únicamente `sub` (ID) y `role`.

## Estructura del JWT
El payload del token es mínimo para evitar exponer datos innecesarios:
```json
{
  "sub": 1,
  "role": "ADMIN",
  "iat": 1700000000,
  "exp": 1700003600
}
```

## Protección de Rutas
Se implementó `JwtAuthGuard`, el cual extiende la estrategia de `passport-jwt`. Este guard intercepta las solicitudes a rutas protegidas, extrae el token del encabezado `Authorization: Bearer <token>`, verifica la firma y ejecuta el método `validate` de `JwtStrategy`.

## Control de Roles
Se implementó un `RolesGuard` personalizado. Utiliza el decorador `@Roles('ADMIN')` para restringir el acceso a ciertos endpoints según el rol embebido en el token y validado en la estrategia JWT.

## Uso de Redis para Evitar Consultas Redundantes
Para reducir las consultas a la base de datos (PostgreSQL) en cada request autenticado:
1. `JwtStrategy.validate` verifica si el estado del usuario existe en Redis usando la clave `auth:user:{userId}`.
2. Si existe (**CACHE HIT**), se confía en el estado almacenado y se evita la consulta SQL.
3. Si no existe (**CACHE MISS**), se consulta PostgreSQL, se valida que el usuario siga `active = true`, y se guarda en Redis con un **TTL de 60 segundos**.
4. Este TTL de 60 segundos garantiza que si un administrador desactiva a un usuario, su sesión será revocada como máximo en un minuto, manteniendo un equilibrio entre rendimiento y seguridad.

## Pruebas para el Video
Durante el video del taller se deben mostrar los siguientes escenarios:
- Iniciar sesión correctamente y recibir el token.
- Intentar acceder a `/api/auth/me` sin token (Fallo esperado 401).
- Acceder a `/api/auth/me` con token (Éxito 200).
- Visualizar en los logs de la terminal cómo la primera petición indica `[AUTH] Usuario X validado desde DATABASE` y la siguiente indica `[AUTH] Usuario X validado desde CACHE`.
- Intentar acceder a `/api/auth/admin-check` con un participante (Fallo esperado 403) y luego con un administrador (Éxito 200).
