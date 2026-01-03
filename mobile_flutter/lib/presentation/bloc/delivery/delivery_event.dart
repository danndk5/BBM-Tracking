// lib/presentation/bloc/delivery/delivery_event.dart

import 'package:equatable/equatable.dart';

abstract class DeliveryEvent extends Equatable {
  const DeliveryEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTibaRequested extends DeliveryEvent {
  final String deliveryId;
  final double latitude;
  final double longitude;

  const UpdateTibaRequested({
    required this.deliveryId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [deliveryId, latitude, longitude];
}

class UpdateMulaiBongkarRequested extends DeliveryEvent {
  final String deliveryId;

  const UpdateMulaiBongkarRequested(this.deliveryId);

  @override
  List<Object?> get props => [deliveryId];
}

class UpdateSelesaiBongkarRequested extends DeliveryEvent {
  final String deliveryId;
  final bool isLanjut;

  const UpdateSelesaiBongkarRequested({
    required this.deliveryId,
    required this.isLanjut,
  });

  @override
  List<Object?> get props => [deliveryId, isLanjut];
}

class CreateNextDeliveryRequested extends DeliveryEvent {
  final String tripId;
  final String spbuId;
  final int urutan;

  const CreateNextDeliveryRequested({
    required this.tripId,
    required this.spbuId,
    required this.urutan,
  });

  @override
  List<Object?> get props => [tripId, spbuId, urutan];
}

class LoadCurrentDelivery extends DeliveryEvent {
  final String tripId;

  const LoadCurrentDelivery(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class LoadDeliveriesByTrip extends DeliveryEvent {
  final String tripId;

  const LoadDeliveriesByTrip(this.tripId);

  @override
  List<Object?> get props => [tripId];
}