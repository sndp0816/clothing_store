import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/exceptions.dart';
import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clothing_store/features/auth/domain/entities/user.dart';
import 'package:clothing_store/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this.dataSource);

  final AuthLocalDataSource dataSource;

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      final model = await dataSource.login(email: email, password: password);
      return Right(model.toEntity());
    } on InvalidCredentialsException {
      return const Left(AuthFailure('Incorrect email or password. Check your details and try again.'));
    } catch (_) {
      return const Left(AuthFailure('Login failed. Please try again.'));
    }
  }
}
