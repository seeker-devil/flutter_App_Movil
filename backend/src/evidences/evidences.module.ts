import { Module } from "@nestjs/common";
import { EvidencesController } from "./evidences.controller";
import { EvidencesService } from "./evidences.service";
import { PrismaModule } from "../prisma/prisma.module";

@Module({
  imports: [PrismaModule],
  controllers: [EvidencesController],
  providers: [EvidencesService],
  exports: [EvidencesService],
})
export class EvidencesModule {}
