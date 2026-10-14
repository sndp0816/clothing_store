import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clothing_store/core/error/failures.dart';

/// Base contract for every use case.
/// [T] is the success type, [Params] the input.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Used by use cases that need no input.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
