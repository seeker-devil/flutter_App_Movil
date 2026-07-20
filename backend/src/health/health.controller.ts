import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  checkHealth() {
    return {
      success: true,
      message: 'SafeAccess 90 backend is running',
      timestamp: new Date().toISOString(),
    };
  }
}
