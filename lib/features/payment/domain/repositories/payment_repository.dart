import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/payment/domain/entities/payment_result.dart';

abstract class PaymentRepository {
  Future<Either<Failure, PaymentResult>> processPayment({required double amount, required int itemCount});
}
