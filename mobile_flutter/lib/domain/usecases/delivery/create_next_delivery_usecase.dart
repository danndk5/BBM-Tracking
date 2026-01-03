// lib/domain/usecases/delivery/create_next_delivery_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';

class CreateNextDeliveryUseCase {
  final DeliveryRepository repository;

  CreateNextDeliveryUseCase(this.repository);

  Future<Either<Failure, Delivery>> call(Map<String, dynamic> data) async {
    return await repository.createNextDelivery(data);
  }
}