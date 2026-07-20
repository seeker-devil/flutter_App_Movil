import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

describe('AuthService', () => {
  let service: AuthService;
  let prisma: PrismaService;
  let jwtService: JwtService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: PrismaService,
          useValue: {
            user: {
              findUnique: jest.fn(),
            },
          },
        },
        {
          provide: JwtService,
          useValue: {
            sign: jest.fn().mockReturnValue('token'),
          },
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    prisma = module.get<PrismaService>(PrismaService);
    jwtService = module.get<JwtService>(JwtService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should throw UnauthorizedException if user does not exist', async () => {
    jest.spyOn(prisma.user, 'findUnique').mockResolvedValue(null);
    await expect(service.login({ email: 'test@test.com', password: '123' })).rejects.toThrow(UnauthorizedException);
  });

  it('should throw UnauthorizedException if user is inactive', async () => {
    jest.spyOn(prisma.user, 'findUnique').mockResolvedValue({ active: false } as any);
    await expect(service.login({ email: 'test@test.com', password: '123' })).rejects.toThrow(UnauthorizedException);
  });

  it('should throw UnauthorizedException if password is wrong', async () => {
    jest.spyOn(prisma.user, 'findUnique').mockResolvedValue({ active: true, passwordHash: 'hash' } as any);
    jest.spyOn(bcrypt, 'compare').mockImplementation(async () => false);
    await expect(service.login({ email: 'test@test.com', password: '123' })).rejects.toThrow(UnauthorizedException);
  });

  it('should return token if credentials are valid', async () => {
    jest.spyOn(prisma.user, 'findUnique').mockResolvedValue({ id: 1, email: 'test@test.com', active: true, passwordHash: 'hash', role: 'PARTICIPANT' } as any);
    jest.spyOn(bcrypt, 'compare').mockImplementation(async () => true);
    
    const result = await service.login({ email: 'test@test.com', password: '123' });
    expect(result.success).toBe(true);
    expect(result.data.accessToken).toBe('token');
  });
});
