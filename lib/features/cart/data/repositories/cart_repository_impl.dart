import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:clothing_store/features/cart/data/models/cart_item_model.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';
import 'package:clothing_store/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this.dataSource);

  final CartLocalDataSource dataSource;

  @override
  Future<Either<Failure, Cart>> getCart() => _guard(() async {});

  @override
  Future<Either<Failure, Cart>> saveItem(CartItem item) =>
      _guard(() => dataSource.saveItem(CartItemModel.fromEntity(item)));

  @override
  Future<Either<Failure, Cart>> removeItem(String productId) => _guard(() => dataSource.removeItem(productId));

  @override
  Future<Either<Failure, Cart>> clearCart() => _guard(dataSource.clear);

  /// Runs [action], then returns the fresh cart, mapping any error to a Failure.
  Future<Either<Failure, Cart>> _guard(Future<void> Function() action) async {
    try {
      await action();
      final models = await dataSource.getItems();
      return Right(Cart(items: models.map((m) => m.toEntity()).toList()));
    } catch (e) {
      return const Left(DataSourceFailure('Cart couldn\'t be updated. Try again.'));
    }
  }
}
