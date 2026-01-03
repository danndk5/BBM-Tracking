// lib/presentation/bloc/trip/trip_state.dart

import 'package:equatable/equatable.dart';
import 'package:mobile_flutter/domain/entities/spbu.dart';
import 'package:mobile_flutter/domain/entities/trip.dart';

abstract class TripState extends Equatable {
  const TripState();

  @override
  List<Object?> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripCreated extends TripState {
  final Trip trip;

  const TripCreated(this.trip);

  @override
  List<Object?> get props => [trip];
}

class TripLoaded extends TripState {
  final Trip? trip;

  const TripLoaded(this.trip);

  @override
  List<Object?> get props => [trip];
}

class SpbuListLoaded extends TripState {
  final List<Spbu> spbuList;

  const SpbuListLoaded(this.spbuList);

  @override
  List<Object?> get props => [spbuList];
}

class TripError extends TripState {
  final String message;

  const TripError(this.message);

  @override
  List<Object?> get props => [message];
}