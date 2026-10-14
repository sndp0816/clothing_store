import 'package:equatable/equatable.dart';

class PaymentResult extends Equatable {
  const PaymentResult({
    required this.orderId,
    required this.amount,
    required this.itemCount,
    required this.paidAt,
  });

  final String orderId;
  final double amount;
  final int itemCount;
  final DateTime paidAt;

  @override
  List<Object?> get props => [orderId, amount, itemCount, paidAt];
}
