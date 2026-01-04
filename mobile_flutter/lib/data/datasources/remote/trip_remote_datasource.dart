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
      print('\n📤 CREATE TRIP REQUEST');
      print('Endpoint: ${ApiEndpoints.trips}');
      print('Data: $data');
      
      final response = await dioClient.post(
        ApiEndpoints.trips,
        data: data,
      );

      print('📥 CREATE TRIP RESPONSE');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle both direct object and object with 'data' or 'trip' key
        final tripData = responseData['data'] ?? responseData['trip'] ?? responseData;
        
        print('✅ Trip created successfully');
        return TripModel.fromJson(tripData as Map<String, dynamic>);
      } else {
        print('❌ Failed to create trip: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to create trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('💥 CREATE TRIP ERROR: $e');
      
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      
      // Handle UnauthorizedException specifically
      if (e is UnauthorizedException) {
        print('🚫 UNAUTHORIZED: User tidak ditemukan atau token invalid');
        throw UnauthorizedException(
          message: 'User tidak ditemukan, silakan login ulang',
        );
      }
      
      throw ServerException(message: 'Create trip error: $e');
    }
  }

  @override
  Future<TripModel?> getActiveTrip() async {
    try {
      print('\n📤 GET ACTIVE TRIP REQUEST');
      print('Endpoint: ${ApiEndpoints.activeTrip}');
      
      final response = await dioClient.get(ApiEndpoints.activeTrip);

      print('📥 GET ACTIVE TRIP RESPONSE');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Handle null/empty response
        if (responseData == null || 
            (responseData is Map && responseData.isEmpty) ||
            responseData['data'] == null) {
          print('ℹ️ No active trip found');
          return null;
        }
        
        final tripData = responseData['data'] ?? responseData['trip'] ?? responseData;
        
        print('✅ Active trip found');
        return TripModel.fromJson(tripData as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        print('ℹ️ No active trip (404)');
        return null; // No active trip
      } else {
        print('❌ Failed to get active trip: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to get active trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('💥 GET ACTIVE TRIP ERROR: $e');
      
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      
      if (e is UnauthorizedException) {
        rethrow;
      }
      
      throw ServerException(message: 'Get active trip error: $e');
    }
  }

  @override
  Future<TripModel> getTripById(String id) async {
    try {
      print('\n📤 GET TRIP BY ID REQUEST');
      print('Endpoint: ${ApiEndpoints.trips}/$id');
      
      final response = await dioClient.get('${ApiEndpoints.trips}/$id');

      print('📥 GET TRIP BY ID RESPONSE');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final tripData = responseData['data'] ?? responseData['trip'] ?? responseData;
        
        print('✅ Trip found');
        return TripModel.fromJson(tripData as Map<String, dynamic>);
      } else {
        print('❌ Failed to get trip: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to get trip',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('💥 GET TRIP BY ID ERROR: $e');
      
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      
      if (e is UnauthorizedException) {
        rethrow;
      }
      
      throw ServerException(message: 'Get trip error: $e');
    }
  }

  @override
  Future<void> updateTrip(String id, Map<String, dynamic> data) async {
    try {
      print('\n📤 UPDATE TRIP REQUEST');
      print('Endpoint: ${ApiEndpoints.trips}/$id');
      print('Data: $data');
      
      final response = await dioClient.put(
        '${ApiEndpoints.trips}/$id',
        data: data,
      );

      print('📥 UPDATE TRIP RESPONSE');
      print('Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        print('❌ Failed to update trip: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to update trip',
          statusCode: response.statusCode,
        );
      }
      
      print('✅ Trip updated successfully');
    } catch (e) {
      print('💥 UPDATE TRIP ERROR: $e');
      
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      
      if (e is UnauthorizedException) {
        rethrow;
      }
      
      throw ServerException(message: 'Update trip error: $e');
    }
  }
}