import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/watchlist/domain/repositories/watchlist_repository.dart';

class RemoveFromWatchlistUseCase implements UseCase<List<Product>, String> {
  const RemoveFromWatchlistUseCase(this.repository);

  final WatchlistRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(String productId) async {
    if (productId.trim().isEmpty) {
      return const Left(ValidationFailure('Invalid product.'));
    }
    return repository.removeFromWatchlist(productId);
  }
}
