import { Injectable, NotFoundException } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { CreateEvaluationDto } from "./dto/create-evaluation.dto";
import { UpdateEvaluationDto } from "./dto/update-evaluation.dto";

@Injectable()
export class EvaluationsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateEvaluationDto) {
    const evaluation = await this.prisma.evaluation.create({
      data: {
        title: dto.title,
        passingScore: dto.passingScore,
        active: dto.active ?? true,
      },
    });

    return {
      success: true,
      message: "Evaluación creada exitosamente",
      data: evaluation,
    };
  }

  async findAll() {
    const evaluations = await this.prisma.evaluation.findMany({
      orderBy: { createdAt: "desc" },
    });

    return {
      success: true,
      data: evaluations,
    };
  }

  async findOne(id: number) {
    const evaluation = await this.prisma.evaluation.findUnique({
      where: { id },
    });

    if (!evaluation) {
      throw new NotFoundException(`Evaluación con ID ${id} no encontrada`);
    }

    return {
      success: true,
      data: evaluation,
    };
  }

  async update(id: number, dto: UpdateEvaluationDto) {
    await this.findOne(id); // Genera 404 si no existe

    const updated = await this.prisma.evaluation.update({
      where: { id },
      data: dto,
    });

    return {
      success: true,
      message: "Evaluación actualizada exitosamente",
      data: updated,
    };
  }

  async remove(id: number) {
    await this.findOne(id); // Genera 404 si no existe

    // Baja lógica para mantener integridad referencial histórica con intentos
    const deactivated = await this.prisma.evaluation.update({
      where: { id },
      data: { active: false },
    });

    return {
      success: true,
      message: "Evaluación desactivada exitosamente (Baja lógica)",
      data: deactivated,
    };
  }
}
