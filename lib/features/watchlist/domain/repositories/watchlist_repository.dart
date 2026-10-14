import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';

/// Every mutation returns the updated watchlist, so callers always
/// receive the single source of truth after each operation.
abstract class WatchlistRepository {
  Future<Either<Failure, List<Product>>> getWatchlist();
  Future<Either<Failure, List<Product>>> addToWatchlist(Product product);
  Future<Either<Failure, List<Product>>> removeFromWatchlist(String productId);
}
