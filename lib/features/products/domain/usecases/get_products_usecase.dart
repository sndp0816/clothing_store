import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  const GetProductsUseCase(this.repository);

  final ProductRepository repository;

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) => repository.getProducts();
}
