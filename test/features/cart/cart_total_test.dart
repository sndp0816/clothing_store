import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';

import '../../helpers/test_data.dart';

void main() {
  group('Cart totals', () {
    test('empty cart has zero items and zero total', () {
      expect(Cart.empty.totalItems, 0);
      expect(Cart.empty.totalAmount, 0);
      expect(Cart.empty.isEmpty, isTrue);
    });

    test('total amount = sum of price x quantity; total items = sum of quantities', () {
      const cart = Cart(items: [
        CartItem(product: tShirt, quantity: 2), // 2 x 500
        CartItem(product: tJeans, quantity: 1), // 1 x 1500
      ]);

      expect(cart.totalItems, 3);
      expect(cart.totalAmount, 2500);
    });

    test('quantityOf returns 0 for products not in the cart', () {
      const cart = Cart(items: [CartItem(product: tShirt, quantity: 2)]);
      expect(cart.quantityOf('p1'), 2);
      expect(cart.quantityOf('missing'), 0);
    });
  });
}
