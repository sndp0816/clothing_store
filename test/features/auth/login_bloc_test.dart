import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' show Left, Right;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:clothing_store/core/error/failures.dart';
import 'package:clothing_store/features/auth/domain/usecases/login_usecase.dart';
import 'package:clothing_store/features/auth/presentation/bloc/login_bloc.dart';

import '../../helpers/test_data.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase loginUseCase;

  const validEmail = 'demo@shop.com';
  const validPassword = 'Password@123';

  setUpAll(() => registerFallbackValue(const LoginParams(email: '', password: '')));
  setUp(() => loginUseCase = MockLoginUseCase());

  test('initial state is empty and the form is invalid', () {
    final bloc = LoginBloc(loginUseCase: loginUseCase);
    expect(bloc.state, const LoginState());
    expect(bloc.state.isFormValid, isFalse);
  });

  blocTest<LoginBloc, LoginState>(
    'shows an email error when the email format is invalid',
    build: () => LoginBloc(loginUseCase: loginUseCase),
    act: (bloc) => bloc.add(const LoginEmailChanged('bad-email')),
    expect: () => const [LoginState(email: 'bad-email', emailError: 'Enter a valid email address')],
  );

  blocTest<LoginBloc, LoginState>(
    'form becomes valid (button enabled) only when both fields are valid',
    build: () => LoginBloc(loginUseCase: loginUseCase),
    act: (bloc) => bloc
      ..add(const LoginEmailChanged(validEmail))
      ..add(const LoginPasswordChanged(validPassword)),
    verify: (bloc) => expect(bloc.state.isFormValid, isTrue),
  );

  blocTest<LoginBloc, LoginState>(
    'does not submit when the form is invalid',
    build: () => LoginBloc(loginUseCase: loginUseCase),
    seed: () => const LoginState(email: 'bad', password: '1'),
    act: (bloc) => bloc.add(const LoginSubmitted()),
    expect: () => const <LoginState>[],
    verify: (_) => verifyNever(() => loginUseCase(any())),
  );

  blocTest<LoginBloc, LoginState>(
    'emits [submitting, success] for valid credentials',
    setUp: () => when(() => loginUseCase(any())).thenAnswer((_) async => const Right(tUser)),
    build: () => LoginBloc(loginUseCase: loginUseCase),
    seed: () => const LoginState(email: validEmail, password: validPassword),
    act: (bloc) => bloc.add(const LoginSubmitted()),
    expect: () => const [
      LoginState(email: validEmail, password: validPassword, status: LoginStatus.submitting),
      LoginState(email: validEmail, password: validPassword, status: LoginStatus.success, user: tUser),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits [submitting, failure] with a message for wrong credentials',
    setUp: () => when(() => loginUseCase(any()))
        .thenAnswer((_) async => const Left(AuthFailure('Incorrect email or password.'))),
    build: () => LoginBloc(loginUseCase: loginUseCase),
    seed: () => const LoginState(email: validEmail, password: 'wrongpass'),
    act: (bloc) => bloc.add(const LoginSubmitted()),
    expect: () => const [
      LoginState(email: validEmail, password: 'wrongpass', status: LoginStatus.submitting),
      LoginState(
        email: validEmail,
        password: 'wrongpass',
        status: LoginStatus.failure,
        errorMessage: 'Incorrect email or password.',
      ),
    ],
  );
}
