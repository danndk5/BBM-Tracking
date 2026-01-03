// lib/data/repositories/trip_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/core/network/network_info.dart';
import 'package:mobile_flutter/data/datasources/local/trip_local_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/spbu_remote_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/trip_remote_datasource.dart';
import 'package:mobile_flutter/domain/entities/spbu.dart';
import 'package:mobile_flutter/domain/entities/trip.dart';
import 'package:mobile_flutter/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;
  final TripLocalDataSource localDataSource;
  final SpbuRemoteDataSource spbuRemoteDataSource;
  final NetworkInfo networkInfo;

  TripRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.spbuRemoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Trip>> createTrip(Map<String, dynamic> data) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final trip = await remoteDataSource.createTrip(data);
      await localDataSource.cacheTrip(trip);

      return Right(trip);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal membuat trip: $e'));
    }
  }

  @override
  Future<Either<Failure, Trip?>> getActiveTrip() async {
    try {
      // Try to get from local first
      final localTrip = await localDataSource.getActiveTrip();

      if (await networkInfo.isConnected) {
        // If online, sync with server
        try {
          final remoteTrip = await remoteDataSource.getActiveTrip();
          if (remoteTrip != null) {
            await localDataSource.cacheTrip(remoteTrip);
            return Right(remoteTrip);
          }
        } catch (e) {
          // If server fails, use local data
          print('Failed to get from server, using local: $e');
        }
      }

      return Right(localTrip);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal mendapatkan trip aktif: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Spbu>>> getAllSpbu() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final spbuList = await spbuRemoteDataSource.getAllSpbu();
      return Right(spbuList);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal mendapatkan daftar SPBU: $e'));
    }
  }
}