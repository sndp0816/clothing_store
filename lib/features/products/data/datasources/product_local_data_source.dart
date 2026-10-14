import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:clothing_store/core/constants/app_constants.dart';
import 'package:clothing_store/core/error/exceptions.dart';
import 'package:clothing_store/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  /// Throws [DataSourceException] if the file can't be read or parsed.
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl({
    AssetBundle? bundle,
    this.assetPath = AppConstants.productsAssetPath,
    this.simulatedDelay = const Duration(milliseconds: 600),
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String assetPath;
  final Duration simulatedDelay;

  @override
  Future<List<ProductModel>> getProducts() async {
    // Small delay so the loading state is visible in the demo.
    await Future<void>.delayed(simulatedDelay);
    try {
      final raw = await _bundle.loadString(assetPath);
      final decoded = json.decode(raw) as Map<String, dynamic>;
      final list = decoded['products'] as List<dynamic>;
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw DataSourceException('Could not load products ($e)');
    }
  }
}
