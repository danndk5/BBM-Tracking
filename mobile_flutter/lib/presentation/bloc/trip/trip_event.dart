// lib/presentation/bloc/trip/trip_event.dart

import 'package:equatable/equatable.dart';

abstract class TripEvent extends Equatable {
  const TripEvent();

  @override
  List<Object?> get props => [];
}

class CreateTripRequested extends TripEvent {
  final String noKendaraan;
  final String namaDriver;
  final String? namaAwak2;
  final String spbuId;

  const CreateTripRequested({
    required this.noKendaraan,
    required this.namaDriver,
    this.namaAwak2,
    required this.spbuId,
  });

  @override
  List<Object?> get props => [noKendaraan, namaDriver, namaAwak2, spbuId];
}

class LoadActiveTrip extends TripEvent {}

class LoadSpbuList extends TripEvent {}