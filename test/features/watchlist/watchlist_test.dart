import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/features/products/domain/entities/product.dart';
import 'package:clothing_store/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:clothing_store/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/presentation/bloc/watchlist_bloc.dart';

import '../../helpers/test_data.dart';

void main() {
  late AddToWatchlistUseCase add;
  late RemoveFromWatchlistUseCase remove;
  late GetWatchlistUseCase get;

  setUp(() {
    final repository = WatchlistRepositoryImpl(WatchlistLocalDataSourceImpl());
    add = AddToWatchlistUseCase(repository);
    remove = RemoveFromWatchlistUseCase(repository);
    get = GetWatchlistUseCase(repository);
  });

  group('Watchlist use cases', () {
    test('adds a product to the watchlist', () async {
      final items = (await add(tShirt)).getOrElse(() => const <Product>[]);
      expect(items, [tShirt]);
    });

    test('adding the same product twice does not create a duplicate', () async {
      await add(tShirt);
      final items = (await add(tShirt)).getOrElse(() => const <Product>[]);
      expect(items, [tShirt]);
    });

    test('removes a product from the watchlist', () async {
      await add(tShirt);
      await add(tJeans);
      final items = (await remove(tShirt.id)).getOrElse(() => const <Product>[]);
      expect(items, [tJeans]);
    });

    test('rejects an empty product id', () async {
      final result = await remove('  ');
      expect(result.isLeft(), isTrue);
    });
  });

  group('WatchlistBloc', () {
    blocTest<WatchlistBloc, WatchlistState>(
      'LoadWatchlist emits [loading, loaded(empty)]',
      build: () => WatchlistBloc(getWatchlist: get, addToWatchlist: add, removeFromWatchlist: remove),
      act: (bloc) => bloc.add(const LoadWatchlist()),
      expect: () => const [
        WatchlistState(status: WatchlistStatus.loading),
        WatchlistState(status: WatchlistStatus.loaded),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'ToggleWatchlist adds then removes, even when tapped rapidly',
      build: () => WatchlistBloc(getWatchlist: get, addToWatchlist: add, removeFromWatchlist: remove),
      act: (bloc) => bloc
        ..add(const ToggleWatchlist(tShirt))
        ..add(const ToggleWatchlist(tShirt)),
      expect: () => const [
        WatchlistState(status: WatchlistStatus.loaded, items: [tShirt]),
        WatchlistState(status: WatchlistStatus.loaded, items: []),
      ],
    );

    blocTest<WatchlistBloc, WatchlistState>(
      'contains() reflects favourite status used by product cards',
      build: () => WatchlistBloc(getWatchlist: get, addToWatchlist: add, removeFromWatchlist: remove),
      act: (bloc) => bloc
        ..add(const AddToWatchlist(tShirt))
        ..add(const AddToWatchlist(tJeans))
        ..add(const RemoveFromWatchlist('p2')),
      verify: (bloc) {
        expect(bloc.state.contains('p1'), isTrue);
        expect(bloc.state.contains('p2'), isFalse);
      },
    );
  });
}
