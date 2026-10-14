import 'package:flutter/material.dart';

import 'package:clothing_store/core/utils/formatters.dart';
import 'package:clothing_store/core/widgets/product_image.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';

/// Pure, reusable presentation widget.
/// It knows nothing about BLoC: it receives data and callbacks,
/// so it can be dropped into any screen (catalogue, watchlist, search...).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavourite,
    required this.quantityInCart,
    required this.onFavouriteToggle,
    required this.onAddToCart,
  });

  final Product product;
  final bool isFavourite;
  final int quantityInCart;
  final VoidCallback onFavouriteToggle;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final inCart = quantityInCart > 0;
    final buttonStyle = FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 8));

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(imageUrl: product.imageUrl),
                Positioned(left: 8, top: 8, child: _CategoryTag(label: product.category)),
                Positioned(
                  right: 4,
                  top: 4,
                  child: _FavouriteButton(isFavourite: isFavourite, onPressed: onFavouriteToggle),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 34,
                  child: Text(
                    product.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  Formatters.price(product.price),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: scheme.primary),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: inCart
                      ? FilledButton.tonalIcon(
                          style: buttonStyle,
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.check, size: 18),
                          label: Text('In cart ($quantityInCart)'),
                        )
                      : FilledButton.icon(
                          style: buttonStyle,
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text('Add to Cart'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavouriteButton extends StatelessWidget {
  const _FavouriteButton({required this.isFavourite, required this.onPressed});

  final bool isFavourite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 1,
      child: IconButton(
        tooltip: isFavourite ? 'Remove from watchlist' : 'Add to watchlist',
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavourite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFavourite),
            color: isFavourite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
