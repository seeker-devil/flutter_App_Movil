import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  ParseIntPipe,
} from "@nestjs/common";
import { EvaluationsService } from "./evaluations.service";
import { CreateEvaluationDto } from "./dto/create-evaluation.dto";
import { UpdateEvaluationDto } from "./dto/update-evaluation.dto";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { RolesGuard } from "../auth/guards/roles.guard";
import { Roles } from "../auth/decorators/roles.decorator";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
} from "@nestjs/swagger";

@ApiTags("Evaluations")
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller("evaluations")
export class EvaluationsController {
  constructor(private readonly evaluationsService: EvaluationsService) {}

  @Post()
  @UseGuards(RolesGuard)
  @Roles("ADMIN")
  @ApiOperation({
    summary: "Crear nueva evaluación (Solo administradores)",
  })
  @ApiResponse({
    status: 201,
    description: "Evaluación creada exitosamente",
  })
  @ApiResponse({
    status: 403,
    description: "Acceso denegado (Requiere rol ADMIN)",
  })
  create(@Body() dto: CreateEvaluationDto) {
    return this.evaluationsService.create(dto);
  }

  @Get()
  @ApiOperation({ summary: "Obtener lista completa de evaluaciones" })
  @ApiResponse({ status: 200, description: "Lista obtenida correctamente" })
  findAll() {
    return this.evaluationsService.findAll();
  }

  @Get(":id")
  @ApiOperation({ summary: "Obtener evaluación por ID" })
  @ApiParam({ name: "id", description: "ID numérico de la evaluación" })
  @ApiResponse({ status: 200, description: "Evaluación encontrada" })
  @ApiResponse({ status: 404, description: "Evaluación no encontrada" })
  findOne(@Param("id", ParseIntPipe) id: number) {
    return this.evaluationsService.findOne(id);
  }

  @Patch(":id")
  @UseGuards(RolesGuard)
  @Roles("ADMIN")
  @ApiOperation({
    summary: "Actualizar datos de evaluación (Solo administradores)",
  })
  @ApiParam({ name: "id", description: "ID numérico de la evaluación" })
  @ApiResponse({
    status: 200,
    description: "Evaluación actualizada exitosamente",
  })
  @ApiResponse({ status: 404, description: "Evaluación no encontrada" })
  update(
    @Param("id", ParseIntPipe) id: number,
    @Body() dto: UpdateEvaluationDto,
  ) {
    return this.evaluationsService.update(id, dto);
  }

  @Delete(":id")
  @UseGuards(RolesGuard)
  @Roles("ADMIN")
  @ApiOperation({
    summary: "Desactivar evaluación por baja lógica (Solo administradores)",
  })
  @ApiParam({ name: "id", description: "ID numérico de la evaluación" })
  @ApiResponse({
    status: 200,
    description: "Evaluación desactivada correctamente (active = false)",
  })
  @ApiResponse({ status: 404, description: "Evaluación no encontrada" })
  remove(@Param("id", ParseIntPipe) id: number) {
    return this.evaluationsService.remove(id);
  }
}
