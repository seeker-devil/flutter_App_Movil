import { Controller, Get } from "@nestjs/common";
import { ApiTags, ApiOperation, ApiResponse } from "@nestjs/swagger";

@ApiTags("Health")
@Controller("health")
export class HealthController {
  @Get()
  @ApiOperation({
    summary: "Verificar el estado operativo del backend NestJS",
  })
  @ApiResponse({
    status: 200,
    description: "Backend funcionando correctamente",
  })
  checkHealth() {
    return {
      success: true,
      message: "SafeAccess 90 backend is running",
      timestamp: new Date().toISOString(),
    };
  }
}
