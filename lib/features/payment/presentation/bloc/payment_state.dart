part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

class PaymentSuccess extends PaymentState {
  const PaymentSuccess(this.result);
  final PaymentResult result;

  @override
  List<Object?> get props => [result];
}

class PaymentError extends PaymentState {
  const PaymentError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
