import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase implements UseCase<Cart, String> {
  const RemoveFromCartUseCase(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, Cart>> call(String productId) async {
    if (productId.trim().isEmpty) return const Left(ValidationFailure('Invalid product.'));
    return repository.removeItem(productId);
  }
}
