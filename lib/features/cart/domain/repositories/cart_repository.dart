import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';

/// Primitive storage operations only. Business rules
/// (increment vs insert, quantity limits) live in the use cases.
abstract class CartRepository {
  Future<Either<Failure, Cart>> getCart();
  Future<Either<Failure, Cart>> saveItem(CartItem item);
  Future<Either<Failure, Cart>> removeItem(String productId);
  Future<Either<Failure, Cart>> clearCart();
}
