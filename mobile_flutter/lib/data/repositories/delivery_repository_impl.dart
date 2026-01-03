// lib/data/repositories/delivery_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/core/network/network_info.dart';
import 'package:mobile_flutter/data/datasources/local/delivery_local_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/delivery_remote_datasource.dart';
import 'package:mobile_flutter/domain/entities/delivery.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource remoteDataSource;
  final DeliveryLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DeliveryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Delivery>> updateTiba(
    String deliveryId,
    double latitude,
    double longitude,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final delivery = await remoteDataSource.updateTiba(
        deliveryId,
        latitude,
        longitude,
      );
      
      await localDataSource.updateDelivery(delivery);

      return Right(delivery);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal update tiba: $e'));
    }
  }

  @override
  Future<Either<Failure, Delivery>> updateMulaiBongkar(String deliveryId) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final delivery = await remoteDataSource.updateMulaiBongkar(deliveryId);
      await localDataSource.updateDelivery(delivery);

      return Right(delivery);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal update mulai bongkar: $e'));
    }
  }

  @override
  Future<Either<Failure, Delivery>> updateSelesaiBongkar(
    String deliveryId,
    bool isLanjut,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final delivery = await remoteDataSource.updateSelesaiBongkar(
        deliveryId,
        isLanjut,
      );
      
      await localDataSource.updateDelivery(delivery);

      return Right(delivery);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal update selesai bongkar: $e'));
    }
  }

  @override
  Future<Either<Failure, Delivery>> createNextDelivery(
    Map<String, dynamic> data,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final delivery = await remoteDataSource.createNextDelivery(data);
      await localDataSource.cacheDelivery(delivery);

      return Right(delivery);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal membuat delivery berikutnya: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Delivery>>> getDeliveriesByTripId(
    String tripId,
  ) async {
    try {
      final deliveries = await localDataSource.getDeliveriesByTripId(tripId);
      return Right(deliveries);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal mendapatkan deliveries: $e'));
    }
  }

  @override
  Future<Either<Failure, Delivery?>> getCurrentDelivery(String tripId) async {
    try {
      final delivery = await localDataSource.getCurrentDelivery(tripId);
      return Right(delivery);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal mendapatkan delivery saat ini: $e'));
    }
  }
}