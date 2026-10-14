part of 'watchlist_bloc.dart';

sealed class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();
}

class AddToWatchlist extends WatchlistEvent {
  const AddToWatchlist(this.product);
  final Product product;

  @override
  List<Object?> get props => [product];
}

class RemoveFromWatchlist extends WatchlistEvent {
  const RemoveFromWatchlist(this.productId);
  final String productId;

  @override
  List<Object?> get props => [productId];
}

/// Convenience event for the heart icon: adds if absent, removes if present.
class ToggleWatchlist extends WatchlistEvent {
  const ToggleWatchlist(this.product);
  final Product product;

  @override
  List<Object?> get props => [product];
}
