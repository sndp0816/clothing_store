import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/widgets/loading_view.dart';
import 'package:clothing_store/core/widgets/state_message.dart';
import 'package:clothing_store/features/products/presentation/bloc/product_bloc.dart';
import 'package:clothing_store/features/products/presentation/widgets/product_grid.dart';
import 'package:clothing_store/injection_container.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(const LoadProducts()),
      child: const _ProductListView(),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) => switch (state) {
        ProductInitial() || ProductLoading() => const LoadingView(message: 'Loading products...'),
        ProductEmpty() => StateMessage(
            icon: Icons.inventory_2_outlined,
            title: 'No products available',
            message: 'New arrivals will show up here.',
            actionLabel: 'Refresh',
            onAction: () => context.read<ProductBloc>().add(const LoadProducts()),
          ),
        ProductError(:final message) => StateMessage(
            icon: Icons.cloud_off_outlined,
            title: 'Products didn\'t load',
            message: message,
            actionLabel: 'Try again',
            onAction: () => context.read<ProductBloc>().add(const LoadProducts()),
          ),
        ProductLoaded(:final products) => ProductGrid(products: products),
      },
    );
  }
}
