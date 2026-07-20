import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus } from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message: string | string[] = 'Internal server error';
    let code = 'INTERNAL_SERVER_ERROR';

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse: any = exception.getResponse();
      
      message = exceptionResponse.message || exception.message;
      code = exceptionResponse.error || exception.name.replace('Exception', '').toUpperCase();
    } else if (exception instanceof Error) {
      message = exception.message;
    }

    // Adaptar mensaje para validation pipe si es array
    const finalMessage = Array.isArray(message) ? message.join(', ') : message;

    response.status(status).json({
      success: false,
      error: {
        statusCode: status,
        code: code.toUpperCase().replace(/\s+/g, '_'),
        message: finalMessage,
        path: request.url,
        timestamp: new Date().toISOString(),
      },
    });
  }
}
