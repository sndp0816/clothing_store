import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/repositories/cart_repository.dart';

/// Business rules:
/// - quantity <= 0 removes the item
/// - quantity above the limit is rejected
/// - the item must already be in the cart
class UpdateCartQuantityUseCase implements UseCase<Cart, UpdateQuantityParams> {
  const UpdateCartQuantityUseCase(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, Cart>> call(UpdateQuantityParams params) async {
    if (params.quantity <= 0) return repository.removeItem(params.productId);

    if (params.quantity > Cart.maxQuantityPerItem) {
      return const Left(CartFailure('You can add up to ${Cart.maxQuantityPerItem} of each item.'));
    }

    final cartResult = await repository.getCart();
    if (cartResult.isLeft()) return cartResult;

    final existing = cartResult.getOrElse(() => Cart.empty).itemFor(params.productId);
    if (existing == null) return const Left(CartFailure('This item is no longer in your cart.'));

    return repository.saveItem(existing.copyWith(quantity: params.quantity));
  }
}

class UpdateQuantityParams extends Equatable {
  const UpdateQuantityParams({required this.productId, required this.quantity});

  final String productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}
