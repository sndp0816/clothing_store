import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/utils/formatters.dart';
import 'package:clothing_store/core/widgets/primary_button.dart';
import 'package:clothing_store/core/widgets/summary_row.dart';
import 'package:clothing_store/features/cart/domain/entities/cart.dart';
import 'package:clothing_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:clothing_store/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:clothing_store/features/payment/presentation/pages/payment_success_page.dart';
import 'package:clothing_store/injection_container.dart';

/// Receives a snapshot of the cart being paid for, so the order summary
/// stays stable while the cart is cleared after a successful payment.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentBloc>(),
      child: _CheckoutView(cart: cart),
    );
  }
}

class _CheckoutView extends StatelessWidget {
  const _CheckoutView({required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          // Coordination between BLoCs happens in the presentation layer:
          // BLoCs never depend on each other directly.
          context.read<CartBloc>().add(const ClearCart());
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => PaymentSuccessPage(result: state.result)),
          );
        } else if (state is PaymentError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final processing = state is PaymentProcessing;
        return PopScope(
          canPop: !processing, // block back navigation mid-payment
          child: Scaffold(
            appBar: AppBar(title: const Text('Checkout')),
            body: Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text('Order summary', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            for (final item in cart.items)
                              SummaryRow(
                                label: '${item.product.name}  ×${item.quantity}',
                                value: Formatters.price(item.subtotal),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Payment method', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Card(
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        leading: Icon(Icons.credit_card),
                        title: Text('Test card ending 4242'),
                        subtitle: Text('Simulated payment. No money is charged.'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SummaryRow(label: 'Items (${cart.totalItems})', value: Formatters.price(cart.totalAmount)),
                            const SummaryRow(label: 'Delivery', value: 'Free'),
                            const Divider(height: 16),
                            SummaryRow(label: 'Total payable', value: Formatters.price(cart.totalAmount), emphasize: true),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (processing) const _ProcessingOverlay(),
              ],
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: PrimaryButton(
                  label: 'Pay now ${Formatters.price(cart.totalAmount)}',
                  icon: Icons.lock_outline,
                  isLoading: processing,
                  onPressed: cart.isEmpty
                      ? null
                      : () => context.read<PaymentBloc>().add(
                            InitiatePayment(amount: cart.totalAmount, itemCount: cart.totalItems),
                          ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black38,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text('Processing payment...', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
