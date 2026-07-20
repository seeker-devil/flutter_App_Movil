import { Module } from '@nestjs/common';
import { HealthModule } from './health/health.module';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { RedisModule } from './redis/redis.module';

@Module({
  imports: [HealthModule, PrismaModule, AuthModule, RedisModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
