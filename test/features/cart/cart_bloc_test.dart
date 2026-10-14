import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:clothing_store/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';
import 'package:clothing_store/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';

import '../../helpers/test_data.dart';

CartBloc buildCartBloc() {
  final repository = CartRepositoryImpl(CartLocalDataSourceImpl());
  return CartBloc(
    getCart: GetCartUseCase(repository),
    addToCart: AddToCartUseCase(repository),
    removeFromCart: RemoveFromCartUseCase(repository),
    updateCartQuantity: UpdateCartQuantityUseCase(repository),
    clearCart: ClearCartUseCase(repository),
  );
}

CartState loaded(List<CartItem> items) => CartState(status: CartStatus.loaded, cart: Cart(items: items));

void main() {
  blocTest<CartBloc, CartState>(
    'add, add, increase, decrease, decrease-to-zero keeps quantities and totals correct',
    build: buildCartBloc,
    act: (bloc) => bloc
      ..add(const AddToCart(tShirt))
      ..add(const AddToCart(tJeans))
      ..add(const IncreaseQuantity('p1'))
      ..add(const DecreaseQuantity('p2')),
    expect: () => [
      loaded(const [CartItem(product: tShirt, quantity: 1)]),
      loaded(const [CartItem(product: tShirt, quantity: 1), CartItem(product: tJeans, quantity: 1)]),
      loaded(const [CartItem(product: tShirt, quantity: 2), CartItem(product: tJeans, quantity: 1)]),
      loaded(const [CartItem(product: tShirt, quantity: 2)]),
    ],
    verify: (bloc) {
      expect(bloc.state.cart.totalItems, 2);
      expect(bloc.state.cart.totalAmount, 1000);
    },
  );

  blocTest<CartBloc, CartState>(
    'ClearCart empties the cart',
    build: buildCartBloc,
    act: (bloc) => bloc
      ..add(const AddToCart(tShirt))
      ..add(const ClearCart()),
    expect: () => [
      loaded(const [CartItem(product: tShirt, quantity: 1)]),
      loaded(const []),
    ],
  );
}
