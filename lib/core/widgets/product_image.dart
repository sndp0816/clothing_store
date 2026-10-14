import 'package:flutter/material.dart';

/// Loads a product image from the network or from bundled assets
/// (any path starting with "assets/"), with a placeholder for
/// loading and error states.
class ProductImage extends StatelessWidget {
  const ProductImage({super.key, required this.imageUrl, this.fit = BoxFit.cover});

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Center(child: Icon(Icons.checkroom_outlined, size: 40, color: scheme.outline)),
    );

    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl, fit: fit, errorBuilder: (_, __, ___) => placeholder);
    }
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (_, child, progress) => progress == null ? child : placeholder,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
