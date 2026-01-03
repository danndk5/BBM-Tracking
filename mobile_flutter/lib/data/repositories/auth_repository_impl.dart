// lib/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/core/network/network_info.dart';
import 'package:mobile_flutter/data/datasources/local/auth_local_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/auth_remote_datasource.dart';
import 'package:mobile_flutter/domain/entities/user.dart';
import 'package:mobile_flutter/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter/injection_container.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String noPekerja, String password) async {
    try {
      // Check internet connection
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      // Call remote API
      final user = await remoteDataSource.login(noPekerja, password);

      // Cache user locally
      await localDataSource.cacheUser(user);

      // Set token to DioClient
      final dioClient = sl<DioClient>();
      dioClient.setAuthToken(user.token ?? '');

      return Right(user);
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Login gagal: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register(Map<String, dynamic> data) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure('Tidak ada koneksi internet'));
      }

      final user = await remoteDataSource.register(data);
      await localDataSource.cacheUser(user);

      // Set token to DioClient
      final dioClient = sl<DioClient>();
      dioClient.setAuthToken(user.token ?? '');

      return Right(user);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Register gagal: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      
      // Set token if user exists
      if (user != null && user.token != null) {
        final dioClient = sl<DioClient>();
        dioClient.setAuthToken(user.token!);
      }
      
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Gagal mendapatkan user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCachedUser();
      
      // Clear token from DioClient
      final dioClient = sl<DioClient>();
      dioClient.clearAuthToken();
      
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Logout gagal: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return const Right(false);
    }
  }
}