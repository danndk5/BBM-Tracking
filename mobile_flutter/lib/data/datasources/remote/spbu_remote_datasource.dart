// lib/data/datasources/remote/spbu_remote_datasource.dart

import 'package:mobile_flutter/core/constants/api_endpoints.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/data/models/spbu_model.dart';

abstract class SpbuRemoteDataSource {
  Future<List<SpbuModel>> getAllSpbu();
  Future<SpbuModel> getSpbuById(String id);
}

class SpbuRemoteDataSourceImpl implements SpbuRemoteDataSource {
  final DioClient dioClient;

  SpbuRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<SpbuModel>> getAllSpbu() async {
    try {
      final response = await dioClient.get(ApiEndpoints.spbu);

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle both array and object with 'data' key
        final List spbuList = data is List ? data : data['data'] ?? data['spbu'] ?? [];
        
        return spbuList
            .map((json) => SpbuModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to get SPBU list',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Get SPBU error: $e');
    }
  }

  @override
  Future<SpbuModel> getSpbuById(String id) async {
    try {
      final response = await dioClient.get('${ApiEndpoints.spbu}/$id');

      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle both direct object and object with 'data' key
        final spbuData = data['data'] ?? data['spbu'] ?? data;
        
        return SpbuModel.fromJson(spbuData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to get SPBU',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Get SPBU by ID error: $e');
    }
  }
}