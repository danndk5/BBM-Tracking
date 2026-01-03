// lib/domain/usecases/delivery/update_mulai_bongkar_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';

class UpdateMulaiBongkarUseCase {
  final DeliveryRepository repository;

  UpdateMulaiBongkarUseCase(this.repository);

  Future<Either<Failure, Delivery>> call(String deliveryId) async {
    return await repository.updateMulaiBongkar(deliveryId);
  }
}