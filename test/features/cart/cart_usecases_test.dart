import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:clothing_store/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/update_cart_quantity_usecase.dart';

import '../../helpers/test_data.dart';

/// Uses the real repository + in-memory data source, so these tests
/// exercise the full domain -> data path for cart business logic.
void main() {
  late AddToCartUseCase addToCart;
  late UpdateCartQuantityUseCase updateQuantity;
  late RemoveFromCartUseCase removeFromCart;
  late ClearCartUseCase clearCart;

  setUp(() {
    final repository = CartRepositoryImpl(CartLocalDataSourceImpl());
    addToCart = AddToCartUseCase(repository);
    updateQuantity = UpdateCartQuantityUseCase(repository);
    removeFromCart = RemoveFromCartUseCase(repository);
    clearCart = ClearCartUseCase(repository);
  });

  test('adding the same product twice increments quantity instead of duplicating it', () async {
    await addToCart(tShirt);
    final cart = (await addToCart(tShirt)).getOrElse(() => Cart.empty);

    expect(cart.items.length, 1);
    expect(cart.quantityOf(tShirt.id), 2);
    expect(cart.totalAmount, 1000);
  });

  test('total is recalculated after quantity changes across products', () async {
    await addToCart(tShirt);
    await addToCart(tJeans);
    final cart = (await updateQuantity(const UpdateQuantityParams(productId: 'p1', quantity: 3)))
        .getOrElse(() => Cart.empty);

    expect(cart.totalItems, 4); // 3 shirts + 1 jeans
    expect(cart.totalAmount, 3000); // 3*500 + 1500
  });

  test('setting quantity to 0 removes the item', () async {
    await addToCart(tShirt);
    final cart = (await updateQuantity(const UpdateQuantityParams(productId: 'p1', quantity: 0)))
        .getOrElse(() => Cart.empty);

    expect(cart.isEmpty, isTrue);
  });

  test('rejects quantities above the per-item limit', () async {
    await addToCart(tShirt);
    final result = await updateQuantity(
      const UpdateQuantityParams(productId: 'p1', quantity: Cart.maxQuantityPerItem + 1),
    );

    expect(result.isLeft(), isTrue);
    result.fold((f) => expect(f, isA<CartFailure>()), (_) => fail('expected a failure'));
  });

  test('remove and clear empty the cart', () async {
    await addToCart(tShirt);
    await addToCart(tJeans);

    final afterRemove = (await removeFromCart('p1')).getOrElse(() => Cart.empty);
    expect(afterRemove.items.single.product, tJeans);

    final afterClear = (await clearCart(const NoParams())).getOrElse(() => Cart.empty);
    expect(afterClear.isEmpty, isTrue);
  });
}
