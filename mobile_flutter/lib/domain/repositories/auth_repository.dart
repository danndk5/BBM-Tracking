// lib/domain/repositories/auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String noPekerja, String password);
  Future<Either<Failure, User>> register(Map<String, dynamic> data);
  Future<Either<Failure, User?>> getCachedUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
}