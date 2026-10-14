import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/features/products/data/models/product_model.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';

void main() {
  test('ProductModel.fromJson parses JSON into a strongly typed model and entity', () {
    final json = <String, dynamic>{
      'id': 'p001',
      'name': 'Everyday Crew Tee',
      'subtitle': 'Organic cotton',
      'price': 599, // int in JSON -> double in the model
      'category': 'T-Shirts',
      'image_url': 'https://example.com/tee.jpg',
    };

    final model = ProductModel.fromJson(json);

    expect(model.price, isA<double>());
    expect(
      model.toEntity(),
      const Product(
        id: 'p001',
        name: 'Everyday Crew Tee',
        subtitle: 'Organic cotton',
        price: 599,
        imageUrl: 'https://example.com/tee.jpg',
        category: 'T-Shirts',
      ),
    );
  });

  test('throws when a required field is missing', () {
    expect(() => ProductModel.fromJson({'id': 'p1'}), throwsA(isA<TypeError>()));
  });
}
