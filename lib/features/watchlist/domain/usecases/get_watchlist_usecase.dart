import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/watchlist/domain/repositories/watchlist_repository.dart';

class GetWatchlistUseCase implements UseCase<List<Product>, NoParams> {
  const GetWatchlistUseCase(this.repository);

  final WatchlistRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) => repository.getWatchlist();
}
