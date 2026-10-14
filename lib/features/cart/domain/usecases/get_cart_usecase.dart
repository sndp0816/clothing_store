import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/repositories/cart_repository.dart';

class GetCartUseCase implements UseCase<Cart, NoParams> {
  const GetCartUseCase(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, Cart>> call(NoParams params) => repository.getCart();
}
