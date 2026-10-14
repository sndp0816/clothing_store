import 'package:flutter_bloc/flutter_bloc.dart';

/// Processes events one at a time, in the order they were added.
///
/// Used by the Cart and Watchlist BLoCs so that rapid taps
/// (e.g. pressing "+" five times quickly) can never race each other
/// and read a stale state. Equivalent to `sequential()` from
/// the bloc_concurrency package.
EventTransformer<E> sequential<E>() {
  return (events, mapper) => events.asyncExpand(mapper);
}
