import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/products/data/models/product_model.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:clothing_store/features/watchlist/domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  const WatchlistRepositoryImpl(this.dataSource);

  final WatchlistLocalDataSource dataSource;

  @override
  Future<Either<Failure, List<Product>>> getWatchlist() => _guard(() async {});

  @override
  Future<Either<Failure, List<Product>>> addToWatchlist(Product product) =>
      _guard(() => dataSource.add(ProductModel.fromEntity(product)));

  @override
  Future<Either<Failure, List<Product>>> removeFromWatchlist(String productId) =>
      _guard(() => dataSource.remove(productId));

  /// Runs [action], then returns the fresh watchlist, mapping any error to a Failure.
  Future<Either<Failure, List<Product>>> _guard(Future<void> Function() action) async {
    try {
      await action();
      final models = await dataSource.getWatchlist();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return const Left(DataSourceFailure('Watchlist couldn\'t be updated. Try again.'));
    }
  }
}
