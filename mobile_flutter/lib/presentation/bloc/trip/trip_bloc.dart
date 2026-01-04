// lib/presentation/bloc/trip/trip_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter/domain/usecases/trip/create_trip_usecase.dart';
import 'package:mobile_flutter/domain/usecases/trip/get_active_trip_usecase.dart';
import 'package:mobile_flutter/domain/repositories/trip_repository.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_event.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {
  final CreateTripUseCase createTripUseCase;
  final GetActiveTripUseCase getActiveTripUseCase;
  final TripRepository tripRepository;
  final AuthRepository authRepository;

  TripBloc({
    required this.createTripUseCase,
    required this.getActiveTripUseCase,
    required this.tripRepository,
    required this.authRepository,
  }) : super(TripInitial()) {
    on<CreateTripRequested>(_onCreateTripRequested);
    on<LoadActiveTrip>(_onLoadActiveTrip);
    on<LoadSpbuList>(_onLoadSpbuList);
  }

  Future<void> _onCreateTripRequested(
    CreateTripRequested event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());

    // Ambil user dari cache
    final userResult = await authRepository.getCachedUser();
    
    String? userId;
    userResult.fold(
      (failure) {
        print('❌ ERROR getting cached user: ${failure.message}');
        userId = null;
      },
      (user) {
        if (user != null) {
          userId = user.id;  // ← FIX INI! SET userId dari user.id
          print('✅ USER FOUND: ${user.nama}');
          print('✅ USER ID: $userId');
          print('✅ TOKEN EXISTS: ${user.token != null && user.token!.isNotEmpty}');
        } else {
          print('❌ User is null');
          userId = null;
        }
      },
    );

    print('📤 USER ID YANG AKAN DIKIRIM: $userId');

    if (userId == null || userId!.isEmpty) {
      print('❌ STOP: User ID null atau kosong, tidak bisa create trip');
      emit(const TripError('User tidak ditemukan, silakan login ulang'));
      return;
    }

    final data = {
      'user_id': userId,
      'no_kendaraan': event.noKendaraan,
      'nama_driver': event.namaDriver,
      'nama_awak2': event.namaAwak2,
      'spbu_id': event.spbuId,
    };

    print('📦 DATA CREATE TRIP:');
    print('   - user_id: ${data['user_id']}');
    print('   - no_kendaraan: ${data['no_kendaraan']}');
    print('   - nama_driver: ${data['nama_driver']}');
    print('   - nama_awak2: ${data['nama_awak2']}');
    print('   - spbu_id: ${data['spbu_id']}');
    print('🚀 Calling createTripUseCase...');

    final result = await createTripUseCase(data);

    result.fold(
      (failure) {
        print('❌ CREATE TRIP FAILED: ${failure.message}');
        emit(TripError(failure.message));
      },
      (trip) {
        print('✅ CREATE TRIP SUCCESS!');
        print('   Trip ID: ${trip.id}');
        emit(TripCreated(trip));
      },
    );
  }

  Future<void> _onLoadActiveTrip(
    LoadActiveTrip event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());

    final result = await getActiveTripUseCase();

    result.fold(
      (failure) => emit(TripError(failure.message)),
      (trip) => emit(TripLoaded(trip)),
    );
  }

  Future<void> _onLoadSpbuList(
    LoadSpbuList event,
    Emitter<TripState> emit,
  ) async {
    emit(TripLoading());

    final result = await tripRepository.getAllSpbu();

    result.fold(
      (failure) => emit(TripError(failure.message)),
      (spbuList) => emit(SpbuListLoaded(spbuList)),
    );
  }
}