// lib/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:mobile_flutter/presentation/pages/create_trip_page.dart';
import 'package:mobile_flutter/presentation/pages/delivery_tracking_page.dart';
import 'package:mobile_flutter/presentation/pages/home_page.dart';
import 'package:mobile_flutter/presentation/pages/login_page.dart';
import 'package:mobile_flutter/presentation/pages/splash_page.dart';
import 'package:mobile_flutter/routes/route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
        
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
        
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
        
      case RouteNames.createTrip:
        return MaterialPageRoute(builder: (_) => const CreateTripPage());
        
      case RouteNames.deliveryTracking:
        final tripId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DeliveryTrackingPage(tripId: tripId),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} tidak ditemukan'),
            ),
          ),
        );
    }
  }
}