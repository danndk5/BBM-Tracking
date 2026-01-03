// lib/domain/repositories/trip_repository.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/spbu.dart';
import 'package:mobile_flutter/domain/entities/trip.dart';

abstract class TripRepository {
  Future<Either<Failure, Trip>> createTrip(Map<String, dynamic> data);
  Future<Either<Failure, Trip?>> getActiveTrip();
  Future<Either<Failure, List<Spbu>>> getAllSpbu();
}