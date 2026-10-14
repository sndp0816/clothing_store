import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/widgets/loading_view.dart';
import 'package:clothing_store/core/widgets/state_message.dart';
import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:clothing_store/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:clothing_store/features/cart/presentation/widgets/cart_summary.dart';
import 'package:clothing_store/features/payment/presentation/pages/checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key, required this.onBrowse});

  final VoidCallback onBrowse;

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed from your cart.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Clear cart')),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<CartBloc>().add(const ClearCart());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.status == CartStatus.initial || state.status == CartStatus.loading) {
          return const LoadingView();
        }
        if (state.status == CartStatus.failure && state.cart.isEmpty) {
          return StateMessage(
            icon: Icons.error_outline,
            title: 'Cart didn\'t load',
            message: state.errorMessage,
            actionLabel: 'Try again',
            onAction: () => context.read<CartBloc>().add(const LoadCart()),
          );
        }

        final cart = state.cart;
        if (cart.isEmpty) {
          return StateMessage(
            icon: Icons.shopping_bag_outlined,
            title: 'Your cart is empty',
            message: 'Products you add will appear here.',
            actionLabel: 'Start shopping',
            onAction: onBrowse,
          );
        }

        final bloc = context.read<CartBloc>();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
              child: Row(
                children: [
                  Text(
                    '${cart.totalItems} ${cart.totalItems == 1 ? 'item' : 'items'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _confirmClear(context),
                    icon: const Icon(Icons.remove_shopping_cart_outlined),
                    label: const Text('Clear cart'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  final id = item.product.id;
                  return CartItemTile(
                    key: ValueKey(id),
                    item: item,
                    onIncrease: () => bloc.add(IncreaseQuantity(id)),
                    onDecrease: () => bloc.add(DecreaseQuantity(id)),
                    onRemove: () => bloc.add(RemoveFromCart(id)),
                  );
                },
              ),
            ),
            CartSummary(
              totalItems: cart.totalItems,
              totalAmount: cart.totalAmount,
              onCheckout: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => CheckoutPage(cart: cart)),
              ),
            ),
          ],
        );
      },
    );
  }
}
