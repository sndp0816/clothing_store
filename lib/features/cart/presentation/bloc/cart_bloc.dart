import 'package:dartz/dartz.dart' show Either;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/bloc/event_transformers.dart';
import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';

part 'cart_event.dart';
part 'cart_state.dart';

/// App-wide BLoC. Every cart operation goes through a use case;
/// the BLoC only translates events into use-case calls and results into states.
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required GetCartUseCase getCart,
    required AddToCartUseCase addToCart,
    required RemoveFromCartUseCase removeFromCart,
    required UpdateCartQuantityUseCase updateCartQuantity,
    required ClearCartUseCase clearCart,
  })  : _getCart = getCart,
        _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateCartQuantity = updateCartQuantity,
        _clearCart = clearCart,
        super(const CartState()) {
    on<CartEvent>(_onEvent, transformer: sequential());
  }

  final GetCartUseCase _getCart;
  final AddToCartUseCase _addToCart;
  final RemoveFromCartUseCase _removeFromCart;
  final UpdateCartQuantityUseCase _updateCartQuantity;
  final ClearCartUseCase _clearCart;

  Future<void> _onEvent(CartEvent event, Emitter<CartState> emit) {
    return switch (event) {
      LoadCart() => _load(emit),
      AddToCart(:final product) => _apply(_addToCart(product), emit),
      RemoveFromCart(:final productId) => _apply(_removeFromCart(productId), emit),
      IncreaseQuantity(:final productId) => _changeQuantity(productId, 1, emit),
      DecreaseQuantity(:final productId) => _changeQuantity(productId, -1, emit),
      ClearCart() => _apply(_clearCart(const NoParams()), emit),
    };
  }

  Future<void> _load(Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCart(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: CartStatus.failure, errorMessage: failure.message)),
      (cart) => emit(state.copyWith(status: CartStatus.loaded, cart: cart)),
    );
  }

  Future<void> _changeQuantity(String productId, int delta, Emitter<CartState> emit) async {
    final current = state.cart.quantityOf(productId);
    if (current == 0) return;
    await _apply(
      _updateCartQuantity(UpdateQuantityParams(productId: productId, quantity: current + delta)),
      emit,
    );
  }

  Future<void> _apply(Future<Either<Failure, Cart>> operation, Emitter<CartState> emit) async {
    final result = await operation;
    result.fold(
      (failure) {
        // Emit failure (UI shows a snackbar), then return to loaded keeping the current cart.
        emit(state.copyWith(status: CartStatus.failure, errorMessage: failure.message));
        emit(state.copyWith(status: CartStatus.loaded));
      },
      (cart) => emit(state.copyWith(status: CartStatus.loaded, cart: cart)),
    );
  }
}
