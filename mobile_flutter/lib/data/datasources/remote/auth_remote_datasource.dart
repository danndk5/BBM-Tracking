// lib/data/datasources/remote/auth_remote_datasource.dart

import 'package:mobile_flutter/core/constants/api_endpoints.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String noPekerja, String password);
  Future<UserModel> register(Map<String, dynamic> data);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login(String noPekerja, String password) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.login,
        data: {
          'no_pekerja': noPekerja,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Combine user data with token
        final userData = data['user'] as Map<String, dynamic>;
        userData['token'] = data['token'];
        
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message: 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is UnauthorizedException) {
        rethrow;
      }
      throw ServerException(message: 'Login error: $e');
    }
  }

  @override
  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.register,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        // Combine user data with token
        final userData = responseData['user'] as Map<String, dynamic>;
        userData['token'] = responseData['token'];
        
        return UserModel.fromJson(userData);
      } else {
        throw ServerException(
          message: 'Register failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Register error: $e');
    }
  }
}