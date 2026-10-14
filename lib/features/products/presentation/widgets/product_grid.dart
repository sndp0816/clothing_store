import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/products/presentation/widgets/product_card.dart';
import 'package:clothing_store/features/watchlist/presentation/bloc/watchlist_bloc.dart';

/// Responsive grid of products, wired to the shared Cart and Watchlist BLoCs.
/// Reused by both the catalogue and the watchlist screens — so favourite
/// status and cart quantity are always rendered from the same state.
class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        mainAxisExtent: 330,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _ConnectedProductCard(product: products[index]),
    );
  }
}

class _ConnectedProductCard extends StatelessWidget {
  const _ConnectedProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    // `select` rebuilds this card only when ITS favourite flag / quantity changes.
    final isFavourite = context.select<WatchlistBloc, bool>((bloc) => bloc.state.contains(product.id));
    final quantity = context.select<CartBloc, int>((bloc) => bloc.state.cart.quantityOf(product.id));

    return ProductCard(
      product: product,
      isFavourite: isFavourite,
      quantityInCart: quantity,
      onFavouriteToggle: () => context.read<WatchlistBloc>().add(ToggleWatchlist(product)),
      onAddToCart: () => context.read<CartBloc>().add(AddToCart(product)),
    );
  }
}
