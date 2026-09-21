import { IsString, IsOptional, IsDateString, IsNotEmpty } from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { Type } from "class-transformer";

export class CreateEvidenceDto {
  @ApiProperty({
    description: "Identificador único UUID v4 generado por el cliente móvil",
    example: "e8f9a1b2-3c4d-5e6f-7a8b-9c0d1e2f3a4b",
  })
  @IsString()
  @IsNotEmpty()
  clientId: string;

  @ApiProperty({
    description: "Descripción u observación detallada de seguridad",
    example: "Uso correcto de casco y arnés en área de construcción.",
  })
  @IsString()
  @IsNotEmpty()
  description: string;

  @ApiPropertyOptional({
    description: "Latitud geográfica de la observación",
    example: -0.180653,
  })
  @IsOptional()
  @Type(() => Number)
  latitude?: number;

  @ApiPropertyOptional({
    description: "Longitud geográfica de la observación",
    example: -78.467838,
  })
  @IsOptional()
  @Type(() => Number)
  longitude?: number;

  @ApiPropertyOptional({
    description: "Fecha y hora de captura local de la evidencia (ISO 8601)",
    example: "2026-09-20T17:00:00.000Z",
  })
  @IsOptional()
  @IsDateString()
  capturedAt?: string;
}
