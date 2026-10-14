import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/auth/domain/entities/user.dart';

/// Contract owned by the domain layer. The data layer implements it.
abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String email, required String password});
}
