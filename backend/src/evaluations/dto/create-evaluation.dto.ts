import {
  IsString,
  IsNotEmpty,
  MinLength,
  MaxLength,
  IsInt,
  Min,
  Max,
  IsBoolean,
  IsOptional,
} from "class-validator";
import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class CreateEvaluationDto {
  @ApiProperty({
    description: "Título descriptivo de la evaluación",
    example: "Evaluación General de Seguridad SafeAccess 90",
  })
  @IsString()
  @IsNotEmpty({ message: "El título es obligatorio" })
  @MinLength(3, { message: "El título debe tener al menos 3 caracteres" })
  @MaxLength(150, { message: "El título no puede exceder los 150 caracteres" })
  title: string;

  @ApiProperty({
    description: "Puntaje mínimo porcentual para aprobar (0-100)",
    example: 70,
  })
  @IsInt({ message: "El puntaje de aprobación debe ser un número entero" })
  @Min(0, { message: "El puntaje mínimo permitido es 0" })
  @Max(100, { message: "El puntaje máximo permitido es 100" })
  passingScore: number;

  @ApiPropertyOptional({
    description: "Estado activo de la evaluación",
    default: true,
  })
  @IsOptional()
  @IsBoolean({ message: "El campo active debe ser un valor booleano" })
  active?: boolean;
}
