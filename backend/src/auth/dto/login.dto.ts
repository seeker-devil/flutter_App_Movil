import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class LoginDto {
  @IsEmail({}, { message: 'El formato de correo no es válido' })
  @IsNotEmpty({ message: 'El email es obligatorio' })
  email: string;

  @IsString({ message: 'El password debe ser texto' })
  @IsNotEmpty({ message: 'El password es obligatorio' })
  password: string;
}
