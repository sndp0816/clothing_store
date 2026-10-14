part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  const ProductLoaded(this.products);
  final List<Product> products;

  @override
  List<Object?> get props => [products];
}

class ProductEmpty extends ProductState {
  const ProductEmpty();
}

class ProductError extends ProductState {
  const ProductError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
