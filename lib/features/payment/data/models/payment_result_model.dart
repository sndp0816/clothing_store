import 'package:clothing_store/features/payment/domain/entities/payment_result.dart';

class PaymentResultModel {
  const PaymentResultModel({
    required this.orderId,
    required this.amount,
    required this.itemCount,
    required this.paidAt,
  });

  final String orderId;
  final double amount;
  final int itemCount;
  final DateTime paidAt;

  PaymentResult toEntity() =>
      PaymentResult(orderId: orderId, amount: amount, itemCount: itemCount, paidAt: paidAt);
}
