import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/features/payment/domain/entities/payment_result.dart';
import 'package:clothing_store/features/payment/domain/usecases/process_dummy_payment_usecase.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({required ProcessDummyPaymentUseCase processDummyPayment})
      : _processPayment = processDummyPayment,
        super(const PaymentInitial()) {
    on<InitiatePayment>(_onInitiatePayment);
  }

  final ProcessDummyPaymentUseCase _processPayment;

  Future<void> _onInitiatePayment(InitiatePayment event, Emitter<PaymentState> emit) async {
    if (state is PaymentProcessing) return; // ignore double taps
    emit(const PaymentProcessing());
    final result = await _processPayment(PaymentParams(amount: event.amount, itemCount: event.itemCount));
    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payment) => emit(PaymentSuccess(payment)),
    );
  }
}
