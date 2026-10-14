part of 'watchlist_bloc.dart';

enum WatchlistStatus { initial, loading, loaded, failure }

class WatchlistState extends Equatable {
  const WatchlistState({
    this.status = WatchlistStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  final WatchlistStatus status;
  final List<Product> items;
  final String? errorMessage;

  bool get isEmpty => items.isEmpty;

  bool contains(String productId) => items.any((p) => p.id == productId);

  /// [errorMessage] is cleared unless explicitly passed.
  WatchlistState copyWith({WatchlistStatus? status, List<Product>? items, String? errorMessage}) {
    return WatchlistState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
