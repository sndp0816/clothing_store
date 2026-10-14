/// Pure validation rules shared by the Login BLoC (live field errors)
/// and the LoginUseCase (final guard before authentication).
class Validators {
  Validators._();

  static const int minPasswordLength = 6;

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z]{2,}$');

  /// Returns an error message, or null when the email is valid.
  static String? validateEmail(String email) {
    final value = email.trim();
    if (value.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  /// Returns an error message, or null when the password is valid.
  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters';
    }
    return null;
  }
}
