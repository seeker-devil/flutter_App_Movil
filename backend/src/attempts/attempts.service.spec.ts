import { Test, TestingModule } from "@nestjs/testing";
import { AttemptsService } from "./attempts.service";
import { PrismaService } from "../prisma/prisma.service";

describe("AttemptsService", () => {
  let service: AttemptsService;
  let prisma: PrismaService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AttemptsService,
        {
          provide: PrismaService,
          useValue: {
            attempt: {
              findMany: jest.fn(),
              findUnique: jest.fn(),
              create: jest.fn(),
            },
            evaluation: {
              findUnique: jest.fn(),
              create: jest.fn(),
            },
          },
        },
      ],
    }).compile();

    service = module.get<AttemptsService>(AttemptsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it("should be defined", () => {
    expect(service).toBeDefined();
  });

  it("should return user attempts", async () => {
    const mockAttempts = [{ id: 1, userId: 1, evaluationId: 1, score: 100 }];
    jest
      .spyOn(prisma.attempt, "findMany")
      .mockResolvedValue(mockAttempts as any);

    const result = await service.findUserAttempts(1);
    expect(result.success).toBe(true);
    expect(result.data).toEqual(mockAttempts);
  });

  it("should return existing attempt if clientId already exists (Idempotency)", async () => {
    const mockExisting = {
      id: 10,
      userId: 1,
      evaluationId: 1,
      clientId: "uuid-123",
      score: 90,
    };
    jest
      .spyOn(prisma.attempt, "findUnique")
      .mockResolvedValue(mockExisting as any);

    const result = await service.createAttempt(1, {
      clientId: "uuid-123",
      evaluationId: 1,
      score: 90,
    });
    expect(result.success).toBe(true);
    expect(result.message).toContain("Idempotente");
    expect(result.data).toEqual(mockExisting);
  });

  it("should create new attempt if clientId is new", async () => {
    jest.spyOn(prisma.attempt, "findUnique").mockResolvedValue(null);
    jest
      .spyOn(prisma.evaluation, "findUnique")
      .mockResolvedValue({ id: 1, title: "Eval", passingScore: 70 } as any);
    const mockCreated = {
      id: 11,
      userId: 1,
      evaluationId: 1,
      clientId: "uuid-456",
      score: 95,
    };
    jest.spyOn(prisma.attempt, "create").mockResolvedValue(mockCreated as any);

    const result = await service.createAttempt(1, {
      clientId: "uuid-456",
      evaluationId: 1,
      score: 95,
    });
    expect(result.success).toBe(true);
    expect(result.data).toEqual(mockCreated);
  });
});
