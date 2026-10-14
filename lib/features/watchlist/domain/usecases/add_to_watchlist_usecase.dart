import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/watchlist/domain/repositories/watchlist_repository.dart';

/// Business rule: a product can appear in the watchlist only once.
class AddToWatchlistUseCase implements UseCase<List<Product>, Product> {
  const AddToWatchlistUseCase(this.repository);

  final WatchlistRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(Product product) async {
    final current = await repository.getWatchlist();
    if (current.isLeft()) return current;

    final items = current.getOrElse(() => const <Product>[]);
    if (items.any((p) => p.id == product.id)) return Right(items);

    return repository.addToWatchlist(product);
  }
}
