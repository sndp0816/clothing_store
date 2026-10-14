part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
  const InitiatePayment({required this.amount, required this.itemCount});

  final double amount;
  final int itemCount;

  @override
  List<Object?> get props => [amount, itemCount];
}
