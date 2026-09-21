import { Injectable, Logger } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { CreateEvidenceDto } from "./dto/create-evidence.dto";
import * as fs from "fs";
import * as path from "path";

export interface UploadedFileDto {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  size: number;
  buffer: Buffer;
}

@Injectable()
export class EvidencesService {
  private readonly logger = new Logger(EvidencesService.name);

  constructor(private readonly prisma: PrismaService) {}

  async findUserEvidences(userId: number) {
    return this.prisma.safetyEvidence.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });
  }

  async createEvidence(
    userId: number,
    dto: CreateEvidenceDto,
    file?: UploadedFileDto,
  ) {
    // 1. Idempotencia: Verificar si el clientId ya fue procesado
    const existing = await this.prisma.safetyEvidence.findUnique({
      where: { clientId: dto.clientId },
    });

    if (existing) {
      this.logger.log(
        `[IDEMPOTENCIA] Evidencia con clientId=${dto.clientId} ya existe. Retornando registro existente.`,
      );
      return {
        message: "Evidencia ya registrada (recuperada por idempotencia)",
        data: existing,
      };
    }

    // 2. Procesar almacenamiento de imagen recibida
    let imageUrl: string | null = null;
    if (file) {
      const uploadDir = path.join(process.cwd(), "uploads", "evidences");
      if (!fs.existsSync(uploadDir)) {
        fs.mkdirSync(uploadDir, { recursive: true });
      }

      const fileExt = path.extname(file.originalname) || ".jpg";
      const filename = `${dto.clientId}${fileExt}`;
      const filePath = path.join(uploadDir, filename);

      fs.writeFileSync(filePath, file.buffer);
      imageUrl = `/uploads/evidences/${filename}`;
      this.logger.log(`[FILE] Fotografía guardada en ${filePath}`);
    }

    // 3. Crear registro en PostgreSQL vía Prisma
    const capturedAtDate = dto.capturedAt
      ? new Date(dto.capturedAt)
      : new Date();

    const evidence = await this.prisma.safetyEvidence.create({
      data: {
        userId,
        clientId: dto.clientId,
        description: dto.description,
        imageUrl,
        latitude: dto.latitude != null ? Number(dto.latitude) : null,
        longitude: dto.longitude != null ? Number(dto.longitude) : null,
        capturedAt: capturedAtDate,
      },
    });

    return {
      message: "Evidencia de seguridad registrada exitosamente",
      data: evidence,
    };
  }
}
