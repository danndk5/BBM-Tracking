// lib/data/datasources/remote/delivery_remote_datasource.dart

import 'package:mobile_flutter/core/constants/api_endpoints.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/data/models/delivery_model.dart';

abstract class DeliveryRemoteDataSource {
  Future<DeliveryModel> updateTiba(String deliveryId, double latitude, double longitude);
  Future<DeliveryModel> updateMulaiBongkar(String deliveryId);
  Future<DeliveryModel> updateSelesaiBongkar(String deliveryId, bool isLanjut);
  Future<DeliveryModel> createNextDelivery(Map<String, dynamic> data);
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final DioClient dioClient;

  DeliveryRemoteDataSourceImpl(this.dioClient);

  @override
  Future<DeliveryModel> updateTiba(
    String deliveryId,
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.deliveryTiba(deliveryId),
        data: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final deliveryData = responseData['data'] ?? responseData['delivery'] ?? responseData;
        
        return DeliveryModel.fromJson(deliveryData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to update tiba',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Update tiba error: $e');
    }
  }

  @override
  Future<DeliveryModel> updateMulaiBongkar(String deliveryId) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.deliveryMulaiBongkar(deliveryId),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final deliveryData = responseData['data'] ?? responseData['delivery'] ?? responseData;
        
        return DeliveryModel.fromJson(deliveryData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to update mulai bongkar',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      throw ServerException(message: 'Update mulai bongkar error: $e');
    }
  }

  @override
  Future<DeliveryModel> updateSelesaiBongkar(
    String deliveryId,
    bool isLanjut,
  ) async {
    try {
      final response = await dioClient.put(
        ApiEndpoints.deliverySelesaiBongkar(deliveryId),
        data: {
          'is_lanjut': isLanjut,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final deliveryData = responseData['data'] ?? responseData['delivery'] ?? responseData;
        
        return DeliveryModel.fromJson(deliveryData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to update selesai bongkar',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Update selesai bongkar error: $e');
    }
  }

  @override
  Future<DeliveryModel> createNextDelivery(Map<String, dynamic> data) async {
    try {
      final response = await dioClient.post(
        ApiEndpoints.deliveryNext,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data;
        final deliveryData = responseData['data'] ?? responseData['delivery'] ?? responseData;
        
        return DeliveryModel.fromJson(deliveryData as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to create next delivery',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException || e is ValidationException) {
        rethrow;
      }
      throw ServerException(message: 'Create next delivery error: $e');
    }
  }
}