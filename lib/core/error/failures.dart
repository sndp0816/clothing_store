import 'package:equatable/equatable.dart';

/// Failures are returned (not thrown) from repositories and use cases
/// as the Left side of `Either<Failure, T>`.
abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class DataSourceFailure extends Failure {
  const DataSourceFailure(super.message);
}

class CartFailure extends Failure {
  const CartFailure(super.message);
}

class PaymentFailure extends Failure {
  const PaymentFailure(super.message);
}
