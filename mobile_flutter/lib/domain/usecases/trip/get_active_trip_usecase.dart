// lib/domain/usecases/trip/get_active_trip_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/trip.dart';
import 'package:mobile_flutter/domain/repositories/trip_repository.dart';

class GetActiveTripUseCase {
  final TripRepository repository;

  GetActiveTripUseCase(this.repository);

  Future<Either<Failure, Trip?>> call() async {
    return await repository.getActiveTrip();
  }
}