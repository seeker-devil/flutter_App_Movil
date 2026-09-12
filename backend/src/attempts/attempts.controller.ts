import { Controller, Get, Post, Body, UseGuards } from "@nestjs/common";
import { AttemptsService } from "./attempts.service";
import { CreateAttemptDto } from "./dto/create-attempt.dto";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { CurrentUser } from "../auth/decorators/current-user.decorator";
import { AuthenticatedUser } from "../auth/interfaces/authenticated-user.interface";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from "@nestjs/swagger";

@ApiTags("Attempts")
@ApiBearerAuth()
@Controller("attempts")
@UseGuards(JwtAuthGuard)
export class AttemptsController {
  constructor(private readonly attemptsService: AttemptsService) {}

  @Get()
  @ApiOperation({
    summary: "Obtener historial de intentos de evaluación del usuario",
  })
  @ApiResponse({ status: 200, description: "Lista de intentos devuelta" })
  getAttempts(@CurrentUser() user: AuthenticatedUser) {
    return this.attemptsService.findUserAttempts(user.id);
  }

  @Post()
  @ApiOperation({
    summary: "Registrar intento de evaluación (con soporte idempotente)",
  })
  @ApiResponse({
    status: 201,
    description: "Intento registrado o recuperado por idempotencia",
  })
  createAttempt(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: CreateAttemptDto,
  ) {
    return this.attemptsService.createAttempt(user.id, dto);
  }
}
