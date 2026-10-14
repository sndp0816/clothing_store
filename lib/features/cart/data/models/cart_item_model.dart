import 'package:clothing_store/features/cart/domain/entities/cart_item.dart';
import 'package:clothing_store/features/products/data/models/product_model.dart';

class CartItemModel {
  const CartItemModel({required this.product, required this.quantity});

  factory CartItemModel.fromEntity(CartItem item) =>
      CartItemModel(product: ProductModel.fromEntity(item.product), quantity: item.quantity);

  final ProductModel product;
  final int quantity;

  CartItem toEntity() => CartItem(product: product.toEntity(), quantity: quantity);
}
