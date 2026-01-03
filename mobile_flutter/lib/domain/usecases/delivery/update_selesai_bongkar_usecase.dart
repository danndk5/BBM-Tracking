// lib/domain/usecases/delivery/update_selesai_bongkar_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';

class UpdateSelesaiBongkarUseCase {
  final DeliveryRepository repository;

  UpdateSelesaiBongkarUseCase(this.repository);

  Future<Either<Failure, Delivery>> call(
    String deliveryId,
    bool isLanjut,
  ) async {
    return await repository.updateSelesaiBongkar(deliveryId, isLanjut);
  }
}