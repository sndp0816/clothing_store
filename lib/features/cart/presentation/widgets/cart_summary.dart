import 'package:flutter/material.dart';

import 'package:clothing_store/core/utils/formatters.dart';
import 'package:clothing_store/core/widgets/primary_button.dart';
import 'package:clothing_store/core/widgets/summary_row.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.totalItems,
    required this.totalAmount,
    required this.onCheckout,
  });

  final int totalItems;
  final double totalAmount;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SummaryRow(label: 'Subtotal ($totalItems ${totalItems == 1 ? 'item' : 'items'})', value: Formatters.price(totalAmount)),
            const SummaryRow(label: 'Delivery', value: 'Free'),
            const Divider(height: 16),
            SummaryRow(label: 'Total', value: Formatters.price(totalAmount), emphasize: true),
            const SizedBox(height: 12),
            PrimaryButton(label: 'Checkout', icon: Icons.lock_outline, onPressed: onCheckout),
          ],
        ),
      ),
    );
  }
}
