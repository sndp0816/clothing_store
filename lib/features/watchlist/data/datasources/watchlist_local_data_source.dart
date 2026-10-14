import 'package:clothing_store/features/products/data/models/product_model.dart';

abstract class WatchlistLocalDataSource {
  Future<List<ProductModel>> getWatchlist();
  Future<void> add(ProductModel product);
  Future<void> remove(String productId);
}

/// In-memory storage. Swap this class for a Hive / SharedPreferences
/// implementation to persist data — nothing above the data layer changes.
class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  // Map literals are insertion-ordered, so items keep the order they were saved.
  final Map<String, ProductModel> _items = {};

  @override
  Future<List<ProductModel>> getWatchlist() async => _items.values.toList(growable: false);

  @override
  Future<void> add(ProductModel product) async {
    _items[product.id] = product;
  }

  @override
  Future<void> remove(String productId) async {
    _items.remove(productId);
  }
}
