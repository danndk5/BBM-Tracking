

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // API Configuration
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://192.168.86.80:8080/api';
  static int get connectTimeout => 30000; // 30 seconds
  static int get receiveTimeout => 30000;
  
  // GPS Configuration
  static const double gpsAccuracyThreshold = 50.0; // meters
  static const int gpsTimeoutSeconds = 30;
  
  // Sync Configuration
  static const int syncIntervalMinutes = 5;
  static const int maxRetryAttempts = 3;
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyNoPekerja = 'no_pekerja';
  
  // Database
  static const String databaseName = 'bbm_tracking.db';
  static const int databaseVersion = 1;
  
  // Environment
  static bool get isProduction => dotenv.env['ENV'] == 'production';
  static bool get isDevelopment => !isProduction;
  
  // Load environment
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}