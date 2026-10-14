import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/exceptions.dart';
import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/products/data/datasources/product_local_data_source.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this.dataSource);

  final ProductLocalDataSource dataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final models = await dataSource.getProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DataSourceException {
      return const Left(DataSourceFailure('We couldn\'t load the catalogue. Check the product data and try again.'));
    }
  }
}
