import { Injectable, BadRequestException } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { CreateAttemptDto } from "./dto/create-attempt.dto";

@Injectable()
export class AttemptsService {
  constructor(private readonly prisma: PrismaService) {}

  async findUserAttempts(userId: number) {
    const attempts = await this.prisma.attempt.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      include: {
        evaluation: {
          select: {
            title: true,
            passingScore: true,
          },
        },
      },
    });

    return {
      success: true,
      data: attempts,
    };
  }

  async createAttempt(userId: number, dto: CreateAttemptDto) {
    // Check idempotency if clientId is provided
    if (dto.clientId) {
      const existing = await this.prisma.attempt.findUnique({
        where: { clientId: dto.clientId },
      });

      if (existing) {
        return {
          success: true,
          message: "Intento ya sincronizado previamente (Idempotente)",
          data: existing,
        };
      }
    }

    const evaluation = await this.prisma.evaluation.findUnique({
      where: { id: dto.evaluationId },
    });

    if (!evaluation) {
      // If evaluation doesn't exist, auto-create a default training evaluation if id is 1
      if (dto.evaluationId === 1) {
        await this.prisma.evaluation.create({
          data: {
            id: 1,
            title: "Evaluación General de Seguridad SafeAccess 90",
            passingScore: 70,
            active: true,
          },
        });
      } else {
        throw new BadRequestException(
          `Evaluación con id ${dto.evaluationId} no encontrada`,
        );
      }
    }

    const startedAt = dto.startedAt ? new Date(dto.startedAt) : new Date();
    const finishedAt = dto.finishedAt ? new Date(dto.finishedAt) : new Date();

    const attempt = await this.prisma.attempt.create({
      data: {
        userId,
        evaluationId: dto.evaluationId,
        clientId: dto.clientId || null,
        status: dto.status || "APPROVED",
        score: dto.score ?? 100,
        startedAt,
        finishedAt,
      },
    });

    return {
      success: true,
      message: "Intento registrado exitosamente",
      data: attempt,
    };
  }
}
