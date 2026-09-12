import { Test, TestingModule } from "@nestjs/testing";
import { EvaluationsService } from "./evaluations.service";
import { PrismaService } from "../prisma/prisma.service";
import { NotFoundException } from "@nestjs/common";

describe("EvaluationsService", () => {
  let service: EvaluationsService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        EvaluationsService,
        {
          provide: PrismaService,
          useValue: {
            evaluation: {
              create: jest.fn(),
              findMany: jest.fn(),
              findUnique: jest.fn(),
              update: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<EvaluationsService>(EvaluationsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });

  it("should create a new evaluation", async () => {
    const mockCreated = {
      id: 1,
      title: "Evaluación de Trabajo en Altura",
      passingScore: 80,
      active: true,
      createdAt: new Date(),
    };
    jest
      .spyOn(prisma.evaluation, "create")
      .mockResolvedValue(mockCreated as any);

    const result = await service.create({
      title: "Evaluación de Trabajo en Altura",
      passingScore: 80,
      active: true,
    });

    expect(result.success).toBe(true);
    expect(result.message).toContain("creada exitosamente");
    expect(result.data).toEqual(mockCreated);
  });

  it("should return all evaluations", async () => {
    const mockList = [
      { id: 1, title: "Eval 1", passingScore: 70, active: true },
      { id: 2, title: "Eval 2", passingScore: 80, active: false },
    ];
    jest
      .spyOn(prisma.evaluation, "findMany")
      .mockResolvedValue(mockList as any);

    const result = await service.findAll();

    expect(result.success).toBe(true);
    expect(result.data).toEqual(mockList);
  });

  it("should return evaluation by ID when exists", async () => {
    const mockItem = { id: 1, title: "Eval 1", passingScore: 70, active: true };
    jest
      .spyOn(prisma.evaluation, "findUnique")
      .mockResolvedValue(mockItem as any);

    const result = await service.findOne(1);

    expect(result.success).toBe(true);
    expect(result.data).toEqual(mockItem);
  });

  it("should throw NotFoundException (404) if evaluation does not exist", async () => {
    jest.spyOn(prisma.evaluation, "findUnique").mockResolvedValue(null);

    await expect(service.findOne(999)).rejects.toThrow(NotFoundException);
  });

  it("should update an existing evaluation", async () => {
    const mockItem = {
      id: 1,
      title: "Eval Original",
      passingScore: 70,
      active: true,
    };
    const mockUpdated = {
      id: 1,
      title: "Eval Editada",
      passingScore: 85,
      active: true,
    };

    jest
      .spyOn(prisma.evaluation, "findUnique")
      .mockResolvedValue(mockItem as any);
    jest
      .spyOn(prisma.evaluation, "update")
      .mockResolvedValue(mockUpdated as any);

    const result = await service.update(1, {
      title: "Eval Editada",
      passingScore: 85,
    });

    expect(result.success).toBe(true);
    expect(result.message).toContain("actualizada exitosamente");
    expect(result.data).toEqual(mockUpdated);
  });

  it("should perform logical delete setting active to false", async () => {
    const mockItem = {
      id: 1,
      title: "Eval Activa",
      passingScore: 70,
      active: true,
    };
    const mockDeactivated = {
      id: 1,
      title: "Eval Activa",
      passingScore: 70,
      active: false,
    };

    jest
      .spyOn(prisma.evaluation, "findUnique")
      .mockResolvedValue(mockItem as any);
    jest
      .spyOn(prisma.evaluation, "update")
      .mockResolvedValue(mockDeactivated as any);

    const result = await service.remove(1);

    expect(result.success).toBe(true);
    expect(result.message).toContain("Baja lógica");
    expect(result.data.active).toBe(false);
  });
});
