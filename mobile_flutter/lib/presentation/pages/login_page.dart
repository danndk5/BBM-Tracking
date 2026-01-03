// lib/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/core/constants/app_strings.dart';
import 'package:mobile_flutter/core/utils/validators.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_event.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_state.dart';
import 'package:mobile_flutter/presentation/widgets/custom_button.dart';
import 'package:mobile_flutter/presentation/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _noPekerjaController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _noPekerjaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final noPekerja = Validators.normalizeNoPekerja(_noPekerjaController.text);
      final password = _passwordController.text;

      context.read<AuthBloc>().add(
            LoginRequested(noPekerja: noPekerja, password: password),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  CustomTextField(
                    controller: _noPekerjaController,
                    label: AppStrings.noPekerja,
                    hint: 'DRV001',
                    validator: Validators.validateNoPekerja,
                    textCapitalization: TextCapitalization.characters,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    label: AppStrings.password,
                    hint: 'Masukkan password',
                    obscureText: true,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return CustomButton(
                        text: AppStrings.login,
                        onPressed: isLoading ? null : _handleLogin,
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}