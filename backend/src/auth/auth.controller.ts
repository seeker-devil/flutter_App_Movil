import {
  Controller,
  Post,
  Body,
  Get,
  UseGuards,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { AuthService } from "./auth.service";
import { LoginDto } from "./dto/login.dto";
import { JwtAuthGuard } from "./guards/jwt-auth.guard";
import { RolesGuard } from "./guards/roles.guard";
import { Roles } from "./decorators/roles.decorator";
import { CurrentUser } from "./decorators/current-user.decorator";
import { AuthenticatedUser } from "./interfaces/authenticated-user.interface";
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from "@nestjs/swagger";

@ApiTags("Auth")
@Controller("auth")
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post("login")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Inicio de sesión de usuario y obtención de JWT" })
  @ApiResponse({
    status: 200,
    description: "Autenticación exitosa y devolución de token JWT",
  })
  @ApiResponse({ status: 401, description: "Credenciales inválidas" })
  login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @UseGuards(JwtAuthGuard)
  @Get("me")
  @ApiBearerAuth()
  @ApiOperation({ summary: "Obtener perfil del usuario autenticado" })
  @ApiResponse({ status: 200, description: "Datos de usuario obtenidos" })
  @ApiResponse({ status: 401, description: "No autorizado (Token no válido)" })
  getProfile(@CurrentUser() user: AuthenticatedUser) {
    return {
      success: true,
      data: {
        id: user.id,
        role: user.role,
        active: user.active,
      },
    };
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles("ADMIN")
  @Get("admin-check")
  @ApiBearerAuth()
  @ApiOperation({ summary: "Verificación de permisos de Administrador" })
  @ApiResponse({ status: 200, description: "Acceso autorizado como ADMIN" })
  @ApiResponse({
    status: 403,
    description: "Acceso prohibido (Requiere rol ADMIN)",
  })
  checkAdmin() {
    return {
      success: true,
      message: "Acceso administrativo autorizado",
    };
  }
}
