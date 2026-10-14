import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/utils/validators.dart';
import 'package:clothing_store/features/auth/domain/entities/user.dart';
import 'package:clothing_store/features/auth/domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required LoginUseCase loginUseCase})
      : _login = loginUseCase,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase _login;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      email: event.email,
      emailError: () => Validators.validateEmail(event.email),
      status: LoginStatus.initial,
      errorMessage: () => null,
    ));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      password: event.password,
      passwordError: () => Validators.validatePassword(event.password),
      status: LoginStatus.initial,
      errorMessage: () => null,
    ));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;

    emit(state.copyWith(status: LoginStatus.submitting, errorMessage: () => null));

    final result = await _login(LoginParams(email: state.email, password: state.password));

    result.fold(
      (failure) => emit(state.copyWith(status: LoginStatus.failure, errorMessage: () => failure.message)),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: () => user)),
    );
  }
}
