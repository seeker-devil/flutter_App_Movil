import { ExtractJwt, Strategy } from "passport-jwt";
import { PassportStrategy } from "@nestjs/passport";
import { Injectable, UnauthorizedException, Logger } from "@nestjs/common";
import { PrismaService } from "../../prisma/prisma.service";
import { RedisService } from "../../redis/redis.service";
import { AuthenticatedUser } from "../interfaces/authenticated-user.interface";

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  private readonly logger = new Logger(JwtStrategy.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly redis: RedisService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || "change_this_in_local_env",
    });
  }

  async validate(payload: any): Promise<AuthenticatedUser> {
    const userId = payload.sub;
    const cacheKey = `auth:user:${userId}`;

    // 1. Consultar Redis de forma segura
    try {
      const redisClient = this.redis.getClient();
      if (redisClient) {
        const cachedUser = await redisClient.get(cacheKey);
        if (cachedUser) {
          this.logger.log(`[AUTH] Usuario ${userId} validado desde CACHE (Redis)`);
          return JSON.parse(cachedUser);
        }
      }
    } catch (err) {
      this.logger.warn(`[AUTH] Error al consultar Redis cache (continuando con PostgreSQL): ${err}`);
    }

    // 2. Si no existe en Redis o la caché expiró/falló, consultar PostgreSQL
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, role: true, active: true },
    });

    if (!user) {
      throw new UnauthorizedException("Credenciales inválidas");
    }

    if (!user.active) {
      throw new UnauthorizedException("Usuario inactivo");
    }

    this.logger.log(`[AUTH] Usuario ${userId} validado desde DATABASE (PostgreSQL)`);

    const authUser: AuthenticatedUser = {
      id: user.id,
      role: user.role,
      active: user.active,
    };

    // 3. Re-poblar Redis con TTL de 60 segundos de forma segura
    try {
      const redisClient = this.redis.getClient();
      if (redisClient) {
        const ttl = parseInt(process.env.AUTH_CACHE_TTL_SECONDS || "60", 10);
        await redisClient.set(cacheKey, JSON.stringify(authUser), "EX", ttl);
      }
    } catch (err) {
      this.logger.warn(`[AUTH] Error al guardar en Redis cache: ${err}`);
    }

    return authUser;
  }
}
