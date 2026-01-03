// lib/data/datasources/remote/trip_remote_datasource.dart

import 'package:mobile_flutter/core/constants/api_endpoints.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/data/models/trip_model.dart';

abstract class TripRemoteDataSource {
  Future<TripModel> createTrip(Map<String, dynamic> data);
  Future<TripModel?> getActiveTrip();
  Future<TripModel> getTripById(String id);
  Future<void> updateTrip(String id, Map<String, dynamic> data);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final DioClient dioClient;

  TripRemoteDataSourceImpl(this.dioClient);

  @override
  Future<TripModel> createTrip(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.trips,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle both direct object and object with 'data' or 'trip' key
        final tripData = responseData['data'] ?? responseData['trip'] ?? responseData;
        
        return TripModel.fromJson(tripData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to create trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Create trip error: $e');
    }
  }

  @override
  Future<TripModel?> getActiveTrip() async {
    try {
      final response = await dioClient.get(ApiEndpoints.activeTrip);

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle null/empty response
        if (responseData == null || 
            (responseData is Map && responseData.isEmpty) ||
            responseData['data'] == null) {
          return null;
        }
        
        final tripData = responseData['data'] ?? responseData['trip'] ?? responseData;
        
        return TripModel.fromJson(tripData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null; // No active trip
      } else {
        throw ServerException(
          message: 'Failed to get active trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Get active trip error: $e');
    }
  }

  @override
  Future<TripModel> getTripById(String id) async {
    try {
      final response = await dioClient.get('${ApiEndpoints.trips}/$id');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tripData = responseData['data'] ?? responseData['trip'] ?? responseData;
        
        return TripModel.fromJson(tripData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to get trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Get trip error: $e');
    }
  }

  @override
  Future<void> updateTrip(String id, Map<String, dynamic> data) async {
    try {
      final response = await dioClient.put(
        '${ApiEndpoints.trips}/$id',
        data: data,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to update trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Update trip error: $e');
    }
  }
}