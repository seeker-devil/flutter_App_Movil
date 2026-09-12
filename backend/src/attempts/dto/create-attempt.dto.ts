import {
  IsInt,
  IsOptional,
  IsString,
  IsEnum,
  IsDateString,
} from "class-validator";
import { AttemptStatus } from "@prisma/client";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class CreateAttemptDto {
  @ApiPropertyOptional({
    description: "Identificador único UUID v4 generado por el cliente móvil",
    example: "c7f9e8a1-3b4d-4e5f-a6b7-8c9d0e1f2a3b",
  })
  @IsOptional()
  @IsString()
  clientId?: string;

  @ApiProperty({
    description: "ID numérico de la evaluación realizada",
    example: 1,
  })
  @IsInt()
  evaluationId: number;

  @ApiPropertyOptional({
    description: "Estado del intento (IN_PROGRESS, APPROVED, FAILED)",
    enum: AttemptStatus,
    default: AttemptStatus.APPROVED,
  })
  @IsOptional()
  @IsEnum(AttemptStatus)
  status?: AttemptStatus;

  @ApiPropertyOptional({
    description: "Puntaje porcentual obtenido (0-100)",
    example: 100,
  })
  @IsOptional()
  @IsInt()
  score?: number;

  @ApiPropertyOptional({
    description: "Fecha y hora de inicio del intento (ISO String)",
    example: "2026-09-12T12:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  startedAt?: string;

  @ApiPropertyOptional({
    description: "Fecha y hora de finalización del intento (ISO String)",
    example: "2026-09-12T12:05:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  finishedAt?: string;
}
