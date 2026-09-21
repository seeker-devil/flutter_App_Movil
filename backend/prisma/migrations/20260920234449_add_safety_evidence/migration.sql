-- CreateTable
CREATE TABLE "SafetyEvidence" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "clientId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "imageUrl" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "capturedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "SafetyEvidence_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SafetyEvidence_clientId_key" ON "SafetyEvidence"("clientId");

-- AddForeignKey
ALTER TABLE "SafetyEvidence" ADD CONSTRAINT "SafetyEvidence_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
