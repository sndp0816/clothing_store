import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/core/utils/validators.dart';
import 'package:clothing_store/features/auth/domain/entities/user.dart';
import 'package:clothing_store/features/auth/domain/repositories/auth_repository.dart';

/// Business rules for logging in:
/// 1. normalise the email (trim + lowercase)
/// 2. validate email & password — never hit the repository with bad input
/// 3. delegate authentication to the repository
class LoginUseCase implements UseCase<User, LoginParams> {
  const LoginUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    final email = params.email.trim().toLowerCase();

    final emailError = Validators.validateEmail(email);
    if (emailError != null) return Left(ValidationFailure(emailError));

    final passwordError = Validators.validatePassword(params.password);
    if (passwordError != null) return Left(ValidationFailure(passwordError));

    return repository.login(email: email, password: params.password);
  }
}

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
