import 'package:clothing_store/core/constants/app_constants.dart';
import 'package:clothing_store/core/error/exceptions.dart';
import 'package:clothing_store/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Throws [InvalidCredentialsException] when credentials don't match.
  Future<UserModel> login({required String email, required String password});
}

/// Dummy authentication against predefined credentials. No backend.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({this.simulatedDelay = const Duration(milliseconds: 800)});

  final Duration simulatedDelay;

  @override
  Future<UserModel> login({required String email, required String password}) async {
    await Future<void>.delayed(simulatedDelay);
    if (email == AppConstants.demoEmail && password == AppConstants.demoPassword) {
      return const UserModel(id: 'u_001', email: AppConstants.demoEmail, name: 'Demo User');
    }
    throw const InvalidCredentialsException();
  }
}
