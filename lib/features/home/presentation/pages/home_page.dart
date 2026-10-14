import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/constants/app_constants.dart';
import 'package:clothing_store/features/auth/presentation/pages/login_page.dart';
import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:clothing_store/features/cart/presentation/pages/cart_page.dart';
import 'package:clothing_store/features/products/presentation/pages/product_list_page.dart';
import 'package:clothing_store/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:clothing_store/features/watchlist/presentation/pages/watchlist_page.dart';

/// Shell with bottom navigation. IndexedStack keeps each tab alive,
/// and badges show live counts from the shared Cart / Watchlist BLoCs.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static const _titles = [AppConstants.appName, 'Watchlist', 'Cart'];

  void _goTo(int index) => setState(() => _index = index);

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final watchlistCount = context.select<WatchlistBloc, int>((b) => b.state.items.length);
    final cartCount = context.select<CartBloc, int>((b) => b.state.cart.totalItems);

    return MultiBlocListener(
      listeners: [
        BlocListener<CartBloc, CartState>(
          listenWhen: (_, c) => c.status == CartStatus.failure && c.errorMessage != null,
          listener: (context, state) => _showError(context, state.errorMessage!),
        ),
        BlocListener<WatchlistBloc, WatchlistState>(
          listenWhen: (_, c) => c.status == WatchlistStatus.failure && c.errorMessage != null,
          listener: (context, state) => _showError(context, state.errorMessage!),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_index], style: const TextStyle(fontWeight: FontWeight.w800)),
          actions: [
            IconButton(tooltip: 'Log out', icon: const Icon(Icons.logout), onPressed: _logout),
          ],
        ),
        body: IndexedStack(
          index: _index,
          children: [
            const ProductListPage(),
            WatchlistPage(onBrowse: () => _goTo(0)),
            CartPage(onBrowse: () => _goTo(0)),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _goTo,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.storefront_outlined),
              selectedIcon: Icon(Icons.storefront),
              label: 'Shop',
            ),
            NavigationDestination(
              icon: _CountBadge(count: watchlistCount, child: const Icon(Icons.favorite_border)),
              selectedIcon: _CountBadge(count: watchlistCount, child: const Icon(Icons.favorite)),
              label: 'Watchlist',
            ),
            NavigationDestination(
              icon: _CountBadge(count: cartCount, child: const Icon(Icons.shopping_bag_outlined)),
              selectedIcon: _CountBadge(count: cartCount, child: const Icon(Icons.shopping_bag)),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.child});

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Badge(isLabelVisible: count > 0, label: Text('$count'), child: child);
  }
}
