import { JwtAuthGuard } from './jwt-auth.guard';
import { UnauthorizedException } from '@nestjs/common';

describe('JwtAuthGuard', () => {
  let guard: JwtAuthGuard;

  beforeEach(() => {
    guard = new JwtAuthGuard();
  });

  it('should be defined', () => {
    expect(guard).toBeDefined();
  });

  it('should return user if user exists and is active', () => {
    const user = { id: 1, active: true };
    expect(guard.handleRequest(null, user, null)).toEqual(user);
  });

  it('should throw error if error exists', () => {
    expect(() => guard.handleRequest(new Error('Test error'), null, null)).toThrow();
  });

  it('should throw UnauthorizedException if user does not exist', () => {
    expect(() => guard.handleRequest(null, null, null)).toThrow(UnauthorizedException);
  });

  it('should throw UnauthorizedException if user is inactive', () => {
    const user = { id: 1, active: false };
    expect(() => guard.handleRequest(null, user, null)).toThrow(UnauthorizedException);
  });
});
