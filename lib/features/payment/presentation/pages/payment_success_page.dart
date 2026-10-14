import 'package:flutter/material.dart';

import 'package:clothing_store/core/utils/formatters.dart';
import 'package:clothing_store/core/widgets/primary_button.dart';
import 'package:clothing_store/core/widgets/summary_row.dart';
import 'package:clothing_store/features/payment/domain/entities/payment_result.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key, required this.result});

  final PaymentResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                    child: Icon(Icons.check_rounded, size: 56, color: scheme.onPrimaryContainer),
                  ),
                  const SizedBox(height: 24),
                  Text('Payment successful', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                    'Your order is confirmed.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SummaryRow(label: 'Order ID', value: result.orderId, emphasize: true),
                          SummaryRow(label: 'Amount paid', value: Formatters.price(result.amount)),
                          SummaryRow(label: 'Items', value: '${result.itemCount}'),
                          SummaryRow(label: 'Date', value: Formatters.dateTime(result.paidAt)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Continue shopping',
                    icon: Icons.storefront_outlined,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
