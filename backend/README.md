# SafeAccess 90 - Backend (Fases 1 y 2)

Este es el esqueleto inicial del backend para SafeAccess 90, con la Fase 1 y Fase 2 del taller de optimización.

## Requisitos
- Node.js (v18+)
- npm
- Docker y Docker Compose
- Git

## Variables de Entorno y Configuración
El sistema requiere PostgreSQL y Redis. Configura tu `.env`:
- `JWT_SECRET`: Llave secreta para firmar los tokens.
- `JWT_EXPIRES_IN`: Tiempo de expiración (ej. `1h`).
- `AUTH_CACHE_TTL_SECONDS`: Tiempo de caché del usuario en Redis (ej. `60`).
- `REDIS_HOST` y `REDIS_PORT`: Conexión a Redis.

El caché de Redis tiene un TTL de 60 segundos para evitar consultas redundantes a la base de datos durante la autenticación.

## Pasos para iniciar (Manual)

Debido a restricciones de ACL en la terminal integrada, los siguientes comandos **NO FUERON EJECUTADOS**. Por favor, ejecútelos manualmente en la carpeta `backend/`:

1. Instalar dependencias:
   ```bash
   npm install
   ```

2. Levantar los contenedores (PostgreSQL y Redis):
   ```bash
   docker compose up -d
   ```

3. Generar cliente y migrar:
   ```bash
   npx prisma generate
   npx prisma migrate dev --name init
   npx prisma db seed
   ```

4. Validar el código (Lint y Test):
   ```bash
   npm run lint
   npm run test
   ```

5. Compilar e Iniciar:
   ```bash
   npm run build
   npm run start:dev
   ```

6. Validar Redis:
   ```bash
   docker compose ps
   Test-NetConnection localhost -Port 6379
   ```

## Endpoints Disponibles
- **Salud:** `GET /api/health`
- **Login:** `POST /api/auth/login` (Recibe `email` y `password`)
- **Perfil:** `GET /api/auth/me` (Requiere Header `Authorization: Bearer <token>`)
- **Admin Check:** `GET /api/auth/admin-check` (Requiere rol ADMIN)

## Credenciales de Demostración (Seed)
- Admin: `admin@safeaccess.local` / `Demo1234*`
- Participante: `participant@safeaccess.local` / `Demo1234*`
