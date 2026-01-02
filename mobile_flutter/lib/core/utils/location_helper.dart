

import 'package:geolocator/geolocator.dart';
import 'package:mobile_flutter/core/config/app_config.dart';
import 'package:mobile_flutter/core/errors/exceptions.dart';

class LocationHelper {
  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  // Get current position
  static Future<Position> getCurrentPosition() async {
    // Check if location services are enabled
    bool serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException(message: 'Location services are disabled');
    }

    // Check permission
    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException(message: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        message: 'Location permissions are permanently denied',
      );
    }

    // Get position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: AppConfig.gpsTimeoutSeconds),
      );
    } catch (e) {
      throw LocationException(message: 'Failed to get location: $e');
    }
  }

  // Calculate distance between two coordinates (in meters)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Validate if user is at SPBU location
  static bool isAtLocation({
    required double currentLat,
    required double currentLon,
    required double targetLat,
    required double targetLon,
    double threshold = 50.0, // default 50 meters
  }) {
    final distance = calculateDistance(
      currentLat,
      currentLon,
      targetLat,
      targetLon,
    );
    
    return distance <= threshold;
  }

  // Get location accuracy text
  static String getAccuracyText(double accuracy) {
    if (accuracy <= 10) return 'Sangat Akurat';
    if (accuracy <= 30) return 'Akurat';
    if (accuracy <= 50) return 'Cukup Akurat';
    return 'Kurang Akurat';
  }

  // Format coordinates to string
  static String formatCoordinates(double lat, double lon) {
    return '${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}';
  }
}