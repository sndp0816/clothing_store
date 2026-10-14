import 'package:clothing_store/features/products/domain/entities/product.dart';

/// Data-layer representation: knows about JSON.
/// The domain [Product] entity stays free of serialization concerns.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String,
        name: json['name'] as String,
        subtitle: json['subtitle'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['image_url'] as String,
        category: json['category'] as String,
      );

  factory ProductModel.fromEntity(Product product) => ProductModel(
        id: product.id,
        name: product.name,
        subtitle: product.subtitle,
        price: product.price,
        imageUrl: product.imageUrl,
        category: product.category,
      );

  final String id;
  final String name;
  final String subtitle;
  final double price;
  final String imageUrl;
  final String category;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'price': price,
        'image_url': imageUrl,
        'category': category,
      };

  Product toEntity() => Product(
        id: id,
        name: name,
        subtitle: subtitle,
        price: price,
        imageUrl: imageUrl,
        category: category,
      );
}
