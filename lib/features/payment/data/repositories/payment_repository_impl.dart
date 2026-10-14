import 'package:dartz/dartz.dart';

import 'package:clothing_store/core/error/exceptions.dart';
import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/payment/data/datasources/payment_local_data_source.dart';
import 'package:clothing_store/features/payment/domain/entities/payment_result.dart';
import 'package:clothing_store/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this.dataSource);

  final PaymentLocalDataSource dataSource;

  @override
  Future<Either<Failure, PaymentResult>> processPayment({required double amount, required int itemCount}) async {
    try {
      final model = await dataSource.processPayment(amount: amount, itemCount: itemCount);
      return Right(model.toEntity());
    } on PaymentException catch (e) {
      return Left(PaymentFailure(e.message));
    } catch (_) {
      return const Left(PaymentFailure('Payment didn\'t go through. You haven\'t been charged — try again.'));
    }
  }
}
