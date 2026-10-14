import 'package:equatable/equatable.dart';

import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';

/// Aggregate entity. Totals are DERIVED from the items, never stored,
/// so they can never drift out of sync.
class Cart extends Equatable {
  const Cart({this.items = const []});

  static const int maxQuantityPerItem = 10;
  static const Cart empty = Cart();

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  /// Total number of units (2 shirts + 1 jeans = 3).
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.subtotal);

  CartItem? itemFor(String productId) {
    for (final item in items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  int quantityOf(String productId) => itemFor(productId)?.quantity ?? 0;

  @override
  List<Object?> get props => [items];
}
