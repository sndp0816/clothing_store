import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/products/domain/usecases/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required GetProductsUseCase getProducts})
      : _getProducts = getProducts,
        super(const ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  final GetProductsUseCase _getProducts;

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    final result = await _getProducts(const NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(products.isEmpty ? const ProductEmpty() : ProductLoaded(products)),
    );
  }
}
