import 'package:clothing_store/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getItems();
  Future<void> saveItem(CartItemModel item);
  Future<void> removeItem(String productId);
  Future<void> clear();
}

/// In-memory cart storage, keyed by product id.
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Map<String, CartItemModel> _items = {};

  @override
  Future<List<CartItemModel>> getItems() async => _items.values.toList(growable: false);

  @override
  Future<void> saveItem(CartItemModel item) async {
    _items[item.product.id] = item;
  }

  @override
  Future<void> removeItem(String productId) async {
    _items.remove(productId);
  }

  @override
  Future<void> clear() async {
    _items.clear();
  }
}
