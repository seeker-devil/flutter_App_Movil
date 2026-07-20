import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting seed...');

  const adminPassword = await bcrypt.hash('Demo1234*', 10);
  const admin = await prisma.user.upsert({
    where: { email: 'admin@safeaccess.local' },
    update: {},
    create: {
      email: 'admin@safeaccess.local',
      passwordHash: adminPassword,
      role: 'ADMIN',
    },
  });

  const participantPassword = await bcrypt.hash('Demo1234*', 10);
  const participant = await prisma.user.upsert({
    where: { email: 'participant@safeaccess.local' },
    update: {},
    create: {
      email: 'participant@safeaccess.local',
      passwordHash: participantPassword,
      role: 'PARTICIPANT',
    },
  });

  console.log('Users created:', { admin: admin.email, participant: participant.email });

  const evaluation = await prisma.evaluation.create({
    data: {
      title: 'Inducción de Seguridad 2026',
      passingScore: 80,
      active: true,
      questions: {
        create: Array.from({ length: 10 }).map((_, qIndex) => ({
          text: `Pregunta de prueba ${qIndex + 1}`,
          order: qIndex + 1,
          active: true,
          options: {
            create: Array.from({ length: 4 }).map((_, oIndex) => ({
              text: `Opción ${oIndex + 1} para pregunta ${qIndex + 1}`,
              order: oIndex + 1,
              isCorrect: oIndex === 0, // La primera opción es correcta en el seed
            })),
          },
        })),
      },
    },
  });

  console.log('Evaluation created:', evaluation.title);

  const attempt = await prisma.attempt.create({
    data: {
      userId: participant.id,
      evaluationId: evaluation.id,
      status: 'IN_PROGRESS',
    },
  });

  console.log('Attempt created for participant:', attempt.id);
  console.log('Seed completed successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
