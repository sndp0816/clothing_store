import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/constants/app_constants.dart';
import 'package:clothing_store/core/theme/app_theme.dart';
import 'package:clothing_store/features/auth/presentation/pages/login_page.dart';
import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:clothing_store/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:clothing_store/injection_container.dart';

class ClothingStoreApp extends StatelessWidget {
  const ClothingStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Cart and Watchlist BLoCs are provided ABOVE MaterialApp, so every
    // route (catalogue, watchlist, cart, checkout) reads the same instance.
    // This is what keeps state synchronized across screens.
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistBloc>(create: (_) => sl<WatchlistBloc>()..add(const LoadWatchlist())),
        BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()..add(const LoadCart())),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const LoginPage(),
      ),
    );
  }
}
