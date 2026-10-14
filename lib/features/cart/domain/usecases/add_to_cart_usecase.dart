import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';
import 'package:clothing_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';

/// Business rules:
/// - new product  -> insert with quantity 1
/// - existing one -> increment quantity
/// - never exceed [Cart.maxQuantityPerItem]
class AddToCartUseCase implements UseCase<Cart, Product> {
  const AddToCartUseCase(this.repository);

  final CartRepository repository;

  @override
  Future<Either<Failure, Cart>> call(Product product) async {
    final cartResult = await repository.getCart();
    if (cartResult.isLeft()) return cartResult;

    final existing = cartResult.getOrElse(() => Cart.empty).itemFor(product.id);
    if (existing == null) {
      return repository.saveItem(CartItem(product: product, quantity: 1));
    }
    if (existing.quantity >= Cart.maxQuantityPerItem) {
      return const Left(CartFailure('You can add up to ${Cart.maxQuantityPerItem} of each item.'));
    }
    return repository.saveItem(existing.copyWith(quantity: existing.quantity + 1));
  }
}
