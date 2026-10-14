import 'package:dartz/dartz.dart' show Either;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/bloc/event_transformers.dart';
import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

/// App-wide BLoC (provided above MaterialApp), so the catalogue and the
/// watchlist screen read the SAME state — favourites are always in sync.
class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc({
    required GetWatchlistUseCase getWatchlist,
    required AddToWatchlistUseCase addToWatchlist,
    required RemoveFromWatchlistUseCase removeFromWatchlist,
  })  : _getWatchlist = getWatchlist,
        _addToWatchlist = addToWatchlist,
        _removeFromWatchlist = removeFromWatchlist,
        super(const WatchlistState()) {
    // One handler + sequential() => events are processed strictly in order.
    on<WatchlistEvent>(_onEvent, transformer: sequential());
  }

  final GetWatchlistUseCase _getWatchlist;
  final AddToWatchlistUseCase _addToWatchlist;
  final RemoveFromWatchlistUseCase _removeFromWatchlist;

  Future<void> _onEvent(WatchlistEvent event, Emitter<WatchlistState> emit) {
    return switch (event) {
      LoadWatchlist() => _load(emit),
      AddToWatchlist(:final product) => _apply(_addToWatchlist(product), emit),
      RemoveFromWatchlist(:final productId) => _apply(_removeFromWatchlist(productId), emit),
      ToggleWatchlist(:final product) => state.contains(product.id)
          ? _apply(_removeFromWatchlist(product.id), emit)
          : _apply(_addToWatchlist(product), emit),
    };
  }

  Future<void> _load(Emitter<WatchlistState> emit) async {
    emit(state.copyWith(status: WatchlistStatus.loading));
    final result = await _getWatchlist(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: WatchlistStatus.failure, errorMessage: failure.message)),
      (items) => emit(state.copyWith(status: WatchlistStatus.loaded, items: items)),
    );
  }

  Future<void> _apply(Future<Either<Failure, List<Product>>> operation, Emitter<WatchlistState> emit) async {
    final result = await operation;
    result.fold(
      (failure) {
        // Emit failure (UI shows a snackbar), then return to loaded keeping current items.
        emit(state.copyWith(status: WatchlistStatus.failure, errorMessage: failure.message));
        emit(state.copyWith(status: WatchlistStatus.loaded));
      },
      (items) => emit(state.copyWith(status: WatchlistStatus.loaded, items: items)),
    );
  }
}
