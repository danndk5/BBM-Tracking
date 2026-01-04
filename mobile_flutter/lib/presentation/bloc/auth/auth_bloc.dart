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
      (failure) {
        print('❌ LOGIN FAILED: ${failure.message}');
        emit(AuthError(failure.message));
      },
      (user) {
        // DEBUG: Print user data
        print('✅ LOGIN SUCCESS!');
        print('🔑 TOKEN RECEIVED: ${user.token}');
        print('👤 USER ID: "${user.id}"');
        print('👤 USER ID LENGTH: ${user.id.length}');
        print('👤 USER ID IS EMPTY: ${user.id.isEmpty}');
        print('📛 NAMA: ${user.nama}');
        print('🔢 NO PEKERJA: ${user.noPekerja}');
        
        // Validasi token tidak kosong
        if (user.token == null || user.token!.isEmpty) {
          print('❌ TOKEN KOSONG! Backend tidak mengirim token');
          emit(AuthError('Token tidak valid, silakan hubungi admin'));
          return;
        }
        
        // Set token to DioClient
        final dioClient = sl<DioClient>();
        dioClient.setAuthToken(user.token!);
        
        // DEBUG: Verify token is set
        print('✅ Token sudah di-set ke DioClient');
        print('📏 Token length: ${user.token!.length} characters');
        
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
        print('🚪 LOGOUT: Clearing token...');
        
        // Clear token from DioClient
        final dioClient = sl<DioClient>();
        dioClient.clearAuthToken();
        
        print('✅ Token cleared');
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
      (failure) {
        print('⚠️ CHECK AUTH: No cached user');
        emit(Unauthenticated());
      },
      (user) {
        if (user != null && user.token != null && user.token!.isNotEmpty) {
          print('🔄 RESTORING SESSION');
          print('🔑 Cached token: ${user.token}');
          
          // Set token to DioClient
          final dioClient = sl<DioClient>();
          dioClient.setAuthToken(user.token!);
          
          print('✅ Session restored');
          emit(Authenticated(user));
        } else {
          print('⚠️ No valid cached session');
          emit(Unauthenticated());
        }
      },
    );
  }
}