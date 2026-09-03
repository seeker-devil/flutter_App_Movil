import {
  IsInt,
  IsOptional,
  IsString,
  IsEnum,
  IsDateString,
} from "class-validator";
import { AttemptStatus } from "@prisma/client";

export class CreateAttemptDto {
  @IsOptional()
  @IsString()
  clientId?: string;

  @IsInt()
  evaluationId: number;

  @IsOptional()
  @IsEnum(AttemptStatus)
  status?: AttemptStatus;

  @IsOptional()
  @IsInt()
  score?: number;

  @IsOptional()
  @IsDateString()
  startedAt?: string;

  @IsOptional()
  @IsDateString()
  finishedAt?: string;
}
