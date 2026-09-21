import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  UseInterceptors,
  UploadedFile,
} from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { EvidencesService, UploadedFileDto } from "./evidences.service";
import { CreateEvidenceDto } from "./dto/create-evidence.dto";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { CurrentUser } from "../auth/decorators/current-user.decorator";
import { AuthenticatedUser } from "../auth/interfaces/authenticated-user.interface";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
} from "@nestjs/swagger";

@ApiTags("Evidences")
@ApiBearerAuth()
@Controller("evidences")
@UseGuards(JwtAuthGuard)
export class EvidencesController {
  constructor(private readonly evidencesService: EvidencesService) {}

  @Get()
  @ApiOperation({
    summary: "Obtener lista de evidencias de seguridad registradas por el usuario",
  })
  @ApiResponse({ status: 200, description: "Lista de evidencias devuelta" })
  getEvidences(@CurrentUser() user: AuthenticatedUser) {
    return this.evidencesService.findUserEvidences(user.id);
  }

  @Post()
  @UseInterceptors(FileInterceptor("file"))
  @ApiConsumes("multipart/form-data", "application/json")
  @ApiOperation({
    summary:
      "Registrar observación/evidencia de seguridad (con imagen opcional y soporte de idempotencia)",
  })
  @ApiResponse({
    status: 201,
    description: "Evidencia de seguridad registrada o recuperada exitosamente",
  })
  createEvidence(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: CreateEvidenceDto,
    @UploadedFile() file?: UploadedFileDto,
  ) {
    return this.evidencesService.createEvidence(user.id, dto, file);
  }
}
