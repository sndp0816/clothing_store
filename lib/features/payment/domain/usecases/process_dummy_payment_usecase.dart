import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/core/usecases/usecase.dart';
import 'package:clothing_store/features/payment/domain/entities/payment_result.dart';
import 'package:clothing_store/features/payment/domain/repositories/payment_repository.dart';

/// Business rule: an order must contain items and have a positive amount.
class ProcessDummyPaymentUseCase implements UseCase<PaymentResult, PaymentParams> {
  const ProcessDummyPaymentUseCase(this.repository);

  final PaymentRepository repository;

  @override
  Future<Either<Failure, PaymentResult>> call(PaymentParams params) async {
    if (params.itemCount <= 0 || params.amount <= 0) {
      return const Left(ValidationFailure('Your cart is empty. Add items before paying.'));
    }
    return repository.processPayment(amount: params.amount, itemCount: params.itemCount);
  }
}

class PaymentParams extends Equatable {
  const PaymentParams({required this.amount, required this.itemCount});

  final double amount;
  final int itemCount;

  @override
  List<Object?> get props => [amount, itemCount];
}
