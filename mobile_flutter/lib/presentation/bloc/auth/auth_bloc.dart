// lib/presentation/bloc/auth/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter/injection_container.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_event.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.login(
      event.noPekerja,
      event.password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) {
        // Set token to DioClient
        final dioClient = sl<DioClient>();
        dioClient.setAuthToken(user.token ?? '');
        
        emit(Authenticated(user));
      },
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) {
        // Clear token from DioClient
        final dioClient = sl<DioClient>();
        dioClient.clearAuthToken();
        
        emit(Unauthenticated());
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await authRepository.getCachedUser();

    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          // Set token to DioClient
          final dioClient = sl<DioClient>();
          dioClient.setAuthToken(user.token ?? '');
          
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }
}