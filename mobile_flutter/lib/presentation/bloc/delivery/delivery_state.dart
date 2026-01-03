// lib/presentation/bloc/delivery/delivery_state.dart

import 'package:equatable/equatable.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';

abstract class DeliveryState extends Equatable {
  const DeliveryState();

  @override
  List<Object?> get props => [];
}

class DeliveryInitial extends DeliveryState {}

class DeliveryLoading extends DeliveryState {}

class DeliveryUpdated extends DeliveryState {
  final Delivery delivery;

  const DeliveryUpdated(this.delivery);

  @override
  List<Object?> get props => [delivery];
}

class DeliveryCreated extends DeliveryState {
  final Delivery delivery;

  const DeliveryCreated(this.delivery);

  @override
  List<Object?> get props => [delivery];
}

class CurrentDeliveryLoaded extends DeliveryState {
  final Delivery? delivery;

  const CurrentDeliveryLoaded(this.delivery);

  @override
  List<Object?> get props => [delivery];
}

class DeliveriesLoaded extends DeliveryState {
  final List<Delivery> deliveries;

  const DeliveriesLoaded(this.deliveries);

  @override
  List<Object?> get props => [deliveries];
}

class DeliveryError extends DeliveryState {
  final String message;

  const DeliveryError(this.message);

  @override
  List<Object?> get props => [message];
}