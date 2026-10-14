import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clothing_store/core/constants/app_constants.dart';
import 'package:clothing_store/core/widgets/primary_button.dart';
import 'package:clothing_store/features/auth/presentation/bloc/login_bloc.dart';
import 'package:clothing_store/features/home/presentation/pages/home_page.dart';
import 'package:clothing_store/injection_container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  // Pure UI state (not business logic), so it lives in the widget.
  bool _obscurePassword = true;

  OutlineInputBorder get _border => OutlineInputBorder(borderRadius: BorderRadius.circular(14));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.checkroom_rounded, size: 56, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to start shopping',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),

                    // Email
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (p, c) => p.emailError != c.emailError,
                      builder: (context, state) => TextField(
                        key: const Key('login_email_field'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        onChanged: (v) => context.read<LoginBloc>().add(LoginEmailChanged(v)),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.mail_outline),
                          border: _border,
                          errorText: state.emailError,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (p, c) => p.passwordError != c.passwordError,
                      builder: (context, state) => TextField(
                        key: const Key('login_password_field'),
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: (v) => context.read<LoginBloc>().add(LoginPasswordChanged(v)),
                        onSubmitted: (_) => context.read<LoginBloc>().add(const LoginSubmitted()),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: _border,
                          errorText: state.passwordError,
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                            icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                    ),

                    // Authentication error
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (p, c) => p.status != c.status || p.errorMessage != c.errorMessage,
                      builder: (context, state) {
                        if (state.status != LoginStatus.failure || state.errorMessage == null) {
                          return const SizedBox.shrink();
                        }
                        final scheme = theme.colorScheme;
                        return Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: scheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: scheme.onErrorContainer),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(state.errorMessage!, style: TextStyle(color: scheme.onErrorContainer)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login button — enabled only when the form is valid
                    BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (p, c) => p.isFormValid != c.isFormValid || p.status != c.status,
                      builder: (context, state) {
                        final submitting = state.status == LoginStatus.submitting;
                        return PrimaryButton(
                          label: 'Log in',
                          isLoading: submitting,
                          onPressed: state.isFormValid && !submitting
                              ? () => context.read<LoginBloc>().add(const LoginSubmitted())
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const _DemoCredentialsHint(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoCredentialsHint extends StatelessWidget {
  const _DemoCredentialsHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Demo account', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const SelectableText('Email: ${AppConstants.demoEmail}\nPassword: ${AppConstants.demoPassword}'),
        ],
      ),
    );
  }
}
