import 'package:dartz/dartz.dart' show Left, Right;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:clothing_store/features/auth/domain/usecases/login_usecase.dart';

import '../../helpers/test_data.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late LoginUseCase useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('returns ValidationFailure for an invalid email and never calls the repository', () async {
    final result = await useCase(const LoginParams(email: 'not-an-email', password: 'Password@123'));

    expect(result, const Left(ValidationFailure('Enter a valid email address')));
    verifyNever(() => repository.login(email: any(named: 'email'), password: any(named: 'password')));
  });

  test('returns ValidationFailure for a short password', () async {
    final result = await useCase(const LoginParams(email: 'demo@shop.com', password: '123'));

    expect(result, const Left(ValidationFailure('Password must be at least 6 characters')));
    verifyNever(() => repository.login(email: any(named: 'email'), password: any(named: 'password')));
  });

  test('normalises the email and returns the user on success', () async {
    when(() => repository.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Right(tUser));

    final result = await useCase(const LoginParams(email: '  Demo@Shop.com ', password: 'Password@123'));

    expect(result, const Right(tUser));
    verify(() => repository.login(email: 'demo@shop.com', password: 'Password@123')).called(1);
  });

  test('passes through authentication failures from the repository', () async {
    when(() => repository.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Left(AuthFailure('Incorrect email or password.')));

    final result = await useCase(const LoginParams(email: 'demo@shop.com', password: 'wrongpass'));

    expect(result, const Left(AuthFailure('Incorrect email or password.')));
  });
}
