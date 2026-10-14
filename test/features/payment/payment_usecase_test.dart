import 'package:flutter_test/flutter_test.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/payment/data/datasources/payment_local_data_source.dart';
import 'package:clothing_store/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:clothing_store/features/payment/domain/usecases/process_dummy_payment_usecase.dart';

void main() {
  late ProcessDummyPaymentUseCase useCase;

  setUp(() {
    final dataSource = PaymentLocalDataSourceImpl(simulatedDelay: Duration.zero);
    useCase = ProcessDummyPaymentUseCase(PaymentRepositoryImpl(dataSource));
  });

  test('rejects payment for an empty cart', () async {
    final result = await useCase(const PaymentParams(amount: 0, itemCount: 0));
    result.fold((f) => expect(f, isA<ValidationFailure>()), (_) => fail('expected a failure'));
  });

  test('returns an order id and the paid amount on success', () async {
    final result = await useCase(const PaymentParams(amount: 2500, itemCount: 3));
    result.fold((_) => fail('expected success'), (payment) {
      expect(payment.orderId, startsWith('ORD-'));
      expect(payment.amount, 2500);
      expect(payment.itemCount, 3);
    });
  });
}
