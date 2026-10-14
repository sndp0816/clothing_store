import 'dart:math';

import 'package:clothing_store/features/payment/data/models/payment_result_model.dart';

abstract class PaymentLocalDataSource {
  Future<PaymentResultModel> processPayment({required double amount, required int itemCount});
}

/// Simulates a payment gateway: waits, then returns a generated order id.
class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  PaymentLocalDataSourceImpl({
    this.simulatedDelay = const Duration(seconds: 2),
    Random? random,
  }) : _random = random ?? Random();

  final Duration simulatedDelay;
  final Random _random;

  @override
  Future<PaymentResultModel> processPayment({required double amount, required int itemCount}) async {
    await Future<void>.delayed(simulatedDelay);
    final now = DateTime.now();
    final stamp = now.millisecondsSinceEpoch.toString().substring(6);
    final orderId = 'ORD-$stamp-${1000 + _random.nextInt(9000)}';
    return PaymentResultModel(orderId: orderId, amount: amount, itemCount: itemCount, paidAt: now);
  }
}
