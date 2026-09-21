import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import { ValidationPipe } from "@nestjs/common";
import { GlobalExceptionFilter } from "./common/filters/global-exception.filter";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import * as express from "express";
import * as path from "path";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.use("/uploads", express.static(path.join(process.cwd(), "uploads")));

  app.setGlobalPrefix("api");
  app.enableCors();

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
  app.useGlobalFilters(new GlobalExceptionFilter());

  // Configuración de Swagger / OpenAPI
  const config = new DocumentBuilder()
    .setTitle("SafeAccess 90 - REST API")
    .setDescription(
      "Documentación técnica de los endpoints de la API REST del proyecto SafeAccess 90. Incluye módulos de Autenticación, Salud, Intentos y Gestión CRUD de Evaluaciones.",
    )
    .setVersion("1.0.0")
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup("api/docs", app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Backend is running on port ${port}`);
  console.log(
    `Swagger Documentation available at http://localhost:${port}/api/docs`,
  );
}
bootstrap();
