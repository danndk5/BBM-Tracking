// lib/domain/repositories/delivery_repository.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';

abstract class DeliveryRepository {
  Future<Either<Failure, Delivery>> updateTiba(
    String deliveryId,
    double latitude,
    double longitude,
  );
  
  Future<Either<Failure, Delivery>> updateMulaiBongkar(String deliveryId);
  
  Future<Either<Failure, Delivery>> updateSelesaiBongkar(
    String deliveryId,
    bool isLanjut,
  );
  
  Future<Either<Failure, Delivery>> createNextDelivery(Map<String, dynamic> data);
  
  Future<Either<Failure, List<Delivery>>> getDeliveriesByTripId(String tripId);
  
  Future<Either<Failure, Delivery?>> getCurrentDelivery(String tripId);
}