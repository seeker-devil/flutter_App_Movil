import { IsEmail, IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class LoginDto {
  @ApiProperty({
    description: "Correo electrónico del usuario",
    example: "admin@safeaccess90.com",
  })
  @IsEmail({}, { message: "El formato de correo no es válido" })
  @IsNotEmpty({ message: "El email es obligatorio" })
  email: string;

  @ApiProperty({
    description: "Contraseña de acceso",
    example: "Admin123*",
  })
  @IsString({ message: "El password debe ser texto" })
  @IsNotEmpty({ message: "El password es obligatorio" })
  password: string;
}
