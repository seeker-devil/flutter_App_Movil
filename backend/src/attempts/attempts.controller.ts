import { Controller, Get, Post, Body, UseGuards } from "@nestjs/common";
import { AttemptsService } from "./attempts.service";
import { CreateAttemptDto } from "./dto/create-attempt.dto";
import { JwtAuthGuard } from "../auth/guards/jwt-auth.guard";
import { CurrentUser } from "../auth/decorators/current-user.decorator";
import { AuthenticatedUser } from "../auth/interfaces/authenticated-user.interface";

@Controller("attempts")
@UseGuards(JwtAuthGuard)
export class AttemptsController {
  constructor(private readonly attemptsService: AttemptsService) {}

  @Get()
  getAttempts(@CurrentUser() user: AuthenticatedUser) {
    return this.attemptsService.findUserAttempts(user.id);
  }

  @Post()
  createAttempt(
    @CurrentUser() user: AuthenticatedUser,
    @Body() dto: CreateAttemptDto,
  ) {
    return this.attemptsService.createAttempt(user.id, dto);
  }
}
