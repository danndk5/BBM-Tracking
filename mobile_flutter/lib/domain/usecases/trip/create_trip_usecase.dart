// lib/domain/usecases/trip/create_trip_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/trip.dart';
import 'package:mobile_flutter/domain/repositories/trip_repository.dart';

class CreateTripUseCase {
  final TripRepository repository;

  CreateTripUseCase(this.repository);

  Future<Either<Failure, Trip>> call(Map<String, dynamic> data) async {
    return await repository.createTrip(data);
  }
}