part of 'cart_bloc.dart';

enum CartStatus { initial, loading, loaded, failure }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.initial,
    this.cart = Cart.empty,
    this.errorMessage,
  });

  final CartStatus status;
  final Cart cart;
  final String? errorMessage;

  /// [errorMessage] is cleared unless explicitly passed.
  CartState copyWith({CartStatus? status, Cart? cart, String? errorMessage}) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cart, errorMessage];
}
