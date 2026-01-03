// lib/presentation/bloc/delivery/delivery_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';
import 'package:mobile_flutter/domain/usecases/delivery/create_next_delivery_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/update_mulai_bongkar_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/update_selesai_bongkar_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/update_tiba_usecase.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_event.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final UpdateTibaUseCase updateTibaUseCase;
  final UpdateMulaiBongkarUseCase updateMulaiBongkarUseCase;
  final UpdateSelesaiBongkarUseCase updateSelesaiBongkarUseCase;
  final CreateNextDeliveryUseCase createNextDeliveryUseCase;
  final DeliveryRepository deliveryRepository;

  DeliveryBloc({
    required this.updateTibaUseCase,
    required this.updateMulaiBongkarUseCase,
    required this.updateSelesaiBongkarUseCase,
    required this.createNextDeliveryUseCase,
    required this.deliveryRepository,
  }) : super(DeliveryInitial()) {
    on<UpdateTibaRequested>(_onUpdateTibaRequested);
    on<UpdateMulaiBongkarRequested>(_onUpdateMulaiBongkarRequested);
    on<UpdateSelesaiBongkarRequested>(_onUpdateSelesaiBongkarRequested);
    on<CreateNextDeliveryRequested>(_onCreateNextDeliveryRequested);
    on<LoadCurrentDelivery>(_onLoadCurrentDelivery);
    on<LoadDeliveriesByTrip>(_onLoadDeliveriesByTrip);
  }

  Future<void> _onUpdateTibaRequested(
    UpdateTibaRequested event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(DeliveryLoading());

    final result = await updateTibaUseCase(
      event.deliveryId,
      event.latitude,
      event.longitude,
    );

    result.fold(
      (failure) => emit(DeliveryError(failure.message)),
      (delivery) => emit(DeliveryUpdated(delivery)),
    );
  }

  Future<void> _onUpdateMulaiBongkarRequested(
    UpdateMulaiBongkarRequested event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(DeliveryLoading());

    final result = await updateMulaiBongkarUseCase(event.deliveryId);

    result.fold(
      (failure) => emit(DeliveryError(failure.message)),
      (delivery) => emit(DeliveryUpdated(delivery)),
    );
  }

  Future<void> _onUpdateSelesaiBongkarRequested(
    UpdateSelesaiBongkarRequested event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(DeliveryLoading());

    final result = await updateSelesaiBongkarUseCase(
      event.deliveryId,
      event.isLanjut,
    );

    result.fold(
      (failure) => emit(DeliveryError(failure.message)),
      (delivery) => emit(DeliveryUpdated(delivery)),
    );
  }

  Future<void> _onCreateNextDeliveryRequested(
    CreateNextDeliveryRequested event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(DeliveryLoading());

    final data = {
      'trip_id': event.tripId,
      'spbu_id': event.spbuId,
      'urutan': event.urutan,
    };

    final result = await createNextDeliveryUseCase(data);

    result.fold(
      (failure) => emit(DeliveryError(failure.message)),
      (delivery) => emit(DeliveryCreated(delivery)),
    );
  }

  Future<void> _onLoadCurrentDelivery(
    LoadCurrentDelivery event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(DeliveryLoading());

    final result = await deliveryRepository.getCurrentDelivery(event.tripId);

    result.fold(
      (failure) => emit(DeliveryError(failure.message)),
      (delivery) => emit(CurrentDeliveryLoaded(delivery)),
    );
  }

  Future<void> _onLoadDeliveriesByTrip(
    LoadDeliveriesByTrip event,
    Emitter<DeliveryState> emit,
  ) async {
    emit(DeliveryLoading());

    final result = await deliveryRepository.getDeliveriesByTripId(event.tripId);

    result.fold(
      (failure) => emit(DeliveryError(failure.message)),
      (deliveries) => emit(DeliveriesLoaded(deliveries)),
    );
  }
}