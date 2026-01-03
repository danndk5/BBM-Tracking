// lib/domain/usecases/auth/login_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:mobile_flutter/core/errors/failures.dart';
import 'package:mobile_flutter/domain/entities/user.dart';
import 'package:mobile_flutter/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String noPekerja, String password) async {
    return await repository.login(noPekerja, password);
  }
}