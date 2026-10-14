/// Exceptions are thrown by the DATA layer (data sources).
/// Repositories catch them and convert them into [Failure]s,
/// so the domain and presentation layers never deal with exceptions.
class DataSourceException implements Exception {
  const DataSourceException(this.message);
  final String message;

  @override
  String toString() => 'DataSourceException: $message';
}

class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException();
}

class PaymentException implements Exception {
  const PaymentException(this.message);
  final String message;
}
