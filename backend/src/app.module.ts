import { Module } from "@nestjs/common";
import { HealthModule } from "./health/health.module";
import { PrismaModule } from "./prisma/prisma.module";
import { AuthModule } from "./auth/auth.module";
import { RedisModule } from "./redis/redis.module";
import { AttemptsModule } from "./attempts/attempts.module";

@Module({
  imports: [
    HealthModule,
    PrismaModule,
    AuthModule,
    RedisModule,
    AttemptsModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
