// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:mobile_flutter/core/config/app_config.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';

class DioClient {
  final Dio _dio;
  String? _authToken;

  DioClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
            receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_authToken';
            print('✅ REQUEST WITH TOKEN');
            print('📍 PATH: ${options.path}');
            print('🔐 Authorization: Bearer ${_authToken!.substring(0, 20)}...');
          } else {
            print('❌ REQUEST WITHOUT TOKEN!');
            print('📍 PATH: ${options.path}');
            print('⚠️ _authToken status: ${_authToken == null ? "NULL" : "EMPTY"}');
          }
          
          print('🌐 REQUEST[${options.method}] => ${options.path}');
          print('📦 REQUEST DATA: ${options.data}');
          print('📋 HEADERS: ${options.headers}');
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
          print('📄 RESPONSE DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('❌ ERROR[${error.response?.statusCode}]');
          print('📍 PATH: ${error.requestOptions.path}');
          print('💬 MESSAGE: ${error.message}');
          print('📄 RESPONSE: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String token) {
    _authToken = token;
    print('🔐 DioClient: Token SET');
    print('📏 Token length: ${token.length} characters');
    print('🔑 Token preview: ${token.length > 20 ? token.substring(0, 20) : token}...');
    
    // Verify token is actually set
    if (_authToken == token) {
      print('✅ Token verification: SUCCESS');
    } else {
      print('❌ Token verification: FAILED');
    }
  }

  void clearAuthToken() {
    print('🗑️ DioClient: Clearing token...');
    _authToken = null;
    print('✅ Token cleared');
  }

  // GET Request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('\n🚀 STARTING GET REQUEST: $path');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('💥 GET REQUEST FAILED: $path');
      throw _handleError(e);
    }
  }

  // POST Request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('\n🚀 STARTING POST REQUEST: $path');
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('💥 POST REQUEST FAILED: $path');
      throw _handleError(e);
    }
  }

  // PUT Request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('\n🚀 STARTING PUT REQUEST: $path');
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('💥 PUT REQUEST FAILED: $path');
      throw _handleError(e);
    }
  }

  // DELETE Request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      print('\n🚀 STARTING DELETE REQUEST: $path');
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      print('💥 DELETE REQUEST FAILED: $path');
      throw _handleError(e);
    }
  }

  // Error Handler
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        print('⏱️ TIMEOUT ERROR');
        return NetworkException(message: 'Connection timeout');
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        print('🔴 BAD RESPONSE ERROR');
        print('Status Code: $statusCode');
        print('Response: $responseData');
        
        final message = responseData is Map 
            ? (responseData['message'] ?? responseData['error'] ?? 'Server error')
            : 'Server error';
        
        if (statusCode == 401) {
          print('🚫 UNAUTHORIZED: Token mungkin invalid/expired');
          return UnauthorizedException(message: message);
        } else if (statusCode == 422) {
          print('⚠️ VALIDATION ERROR');
          return ValidationException(
            message: message,
            errors: responseData is Map ? responseData['errors'] : null,
          );
        }
        
        return ServerException(
          message: message,
          statusCode: statusCode,
        );
        
      case DioExceptionType.cancel:
        print('🚫 REQUEST CANCELLED');
        return ServerException(message: 'Request cancelled');
        
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
      default:
        print('🌐 CONNECTION ERROR');
        return NetworkException(message: 'No internet connection');
    }
  }
}