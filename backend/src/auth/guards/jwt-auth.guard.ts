import { Injectable, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  handleRequest(err: any, user: any, info: any) {
    // Manejo personalizado de errores si es necesario
    if (err || !user) {
      throw err || new UnauthorizedException('Credenciales inválidas');
    }
    
    // Si el usuario está inactivo, lo rechazamos
    if (!user.active) {
      throw new UnauthorizedException('Usuario inactivo');
    }
    
    return user;
  }
}
