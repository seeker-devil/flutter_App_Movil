import { Role } from '@prisma/client';

export interface AuthenticatedUser {
  id: number;
  role: Role;
  active: boolean;
}
