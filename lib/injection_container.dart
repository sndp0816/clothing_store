import 'package:get_it/get_it.dart';

import 'package:clothing_store/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clothing_store/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clothing_store/features/auth/domain/repositories/auth_repository.dart';
import 'package:clothing_store/features/auth/domain/usecases/login_usecase.dart';
import 'package:clothing_store/features/auth/presentation/bloc/login_bloc.dart';
import 'package:clothing_store/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:clothing_store/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:clothing_store/features/cart/domain/repositories/cart_repository.dart';
import 'package:clothing_store/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:clothing_store/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:clothing_store/features/payment/data/datasources/payment_local_data_source.dart';
import 'package:clothing_store/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:clothing_store/features/payment/domain/repositories/payment_repository.dart';
import 'package:clothing_store/features/payment/domain/usecases/process_dummy_payment_usecase.dart';
import 'package:clothing_store/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:clothing_store/features/products/data/datasources/product_local_data_source.dart';
import 'package:clothing_store/features/products/data/repositories/product_repository_impl.dart';
import 'package:clothing_store/features/products/domain/repositories/product_repository.dart';
import 'package:clothing_store/features/products/domain/usecases/get_products_usecase.dart';
import 'package:clothing_store/features/products/presentation/bloc/product_bloc.dart';
import 'package:clothing_store/features/watchlist/data/datasources/watchlist_local_data_source.dart';
import 'package:clothing_store/features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'package:clothing_store/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/add_to_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/get_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/domain/usecases/remove_from_watchlist_usecase.dart';
import 'package:clothing_store/features/watchlist/presentation/bloc/watchlist_bloc.dart';

/// Service locator. Wiring follows the architecture bottom-up:
/// data sources -> repositories -> use cases -> BLoCs.
final GetIt sl = GetIt.instance;

void initDependencies() {
  // ---------------- Data sources (singletons: in-memory state lives here)
  sl
    ..registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl())
    ..registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSourceImpl())
    ..registerLazySingleton<WatchlistLocalDataSource>(() => WatchlistLocalDataSourceImpl())
    ..registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl())
    ..registerLazySingleton<PaymentLocalDataSource>(() => PaymentLocalDataSourceImpl());

  // ---------------- Repositories (registered against their INTERFACES)
  sl
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()))
    ..registerLazySingleton<WatchlistRepository>(() => WatchlistRepositoryImpl(sl()))
    ..registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()))
    ..registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(sl()));

  // ---------------- Use cases
  sl
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => GetProductsUseCase(sl()))
    ..registerLazySingleton(() => GetWatchlistUseCase(sl()))
    ..registerLazySingleton(() => AddToWatchlistUseCase(sl()))
    ..registerLazySingleton(() => RemoveFromWatchlistUseCase(sl()))
    ..registerLazySingleton(() => GetCartUseCase(sl()))
    ..registerLazySingleton(() => AddToCartUseCase(sl()))
    ..registerLazySingleton(() => RemoveFromCartUseCase(sl()))
    ..registerLazySingleton(() => UpdateCartQuantityUseCase(sl()))
    ..registerLazySingleton(() => ClearCartUseCase(sl()))
    ..registerLazySingleton(() => ProcessDummyPaymentUseCase(sl()));

  // ---------------- BLoCs (factories: a fresh instance per BlocProvider)
  sl
    ..registerFactory(() => LoginBloc(loginUseCase: sl()))
    ..registerFactory(() => ProductBloc(getProducts: sl()))
    ..registerFactory(() => WatchlistBloc(
          getWatchlist: sl(),
          addToWatchlist: sl(),
          removeFromWatchlist: sl(),
        ))
    ..registerFactory(() => CartBloc(
          getCart: sl(),
          addToCart: sl(),
          removeFromCart: sl(),
          updateCartQuantity: sl(),
          clearCart: sl(),
        ))
    ..registerFactory(() => PaymentBloc(processDummyPayment: sl()));
}
