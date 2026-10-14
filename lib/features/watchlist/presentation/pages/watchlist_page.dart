import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/widgets/loading_view.dart';
import 'package:clothing_store/core/widgets/state_message.dart';
import 'package:clothing_store/features/products/presentation/widgets/product_grid.dart';
import 'package:clothing_store/features/watchlist/presentation/bloc/watchlist_bloc.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state.status == WatchlistStatus.initial || state.status == WatchlistStatus.loading) {
          return const LoadingView();
        }
        if (state.status == WatchlistStatus.failure && state.isEmpty) {
          return StateMessage(
            icon: Icons.error_outline,
            title: 'Watchlist didn\'t load',
            message: state.errorMessage,
            actionLabel: 'Try again',
            onAction: () => context.read<WatchlistBloc>().add(const LoadWatchlist()),
          );
        }
        if (state.isEmpty) {
          return StateMessage(
            icon: Icons.favorite_border,
            title: 'Your watchlist is empty',
            message: 'Tap the heart on any product to save it here.',
            actionLabel: 'Browse products',
            onAction: onBrowse,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                '${state.items.length} saved ${state.items.length == 1 ? 'item' : 'items'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(child: ProductGrid(products: state.items)),
          ],
        );
      },
    );
  }
}
