/*
  Warnings:

  - A unique constraint covering the columns `[clientId]` on the table `Attempt` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Attempt" ADD COLUMN     "clientId" TEXT,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- CreateIndex
CREATE UNIQUE INDEX "Attempt_clientId_key" ON "Attempt"("clientId");
