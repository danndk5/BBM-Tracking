// lib/domain/usecases/delivery/update_tiba_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';

class UpdateTibaUseCase {
  final DeliveryRepository repository;

  UpdateTibaUseCase(this.repository);

  Future<Either<Failure, Delivery>> call(
    String deliveryId,
    double latitude,
    double longitude,
  ) async {
    return await repository.updateTiba(deliveryId, latitude, longitude);
  }
}