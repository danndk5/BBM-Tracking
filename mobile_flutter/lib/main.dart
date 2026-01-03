// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter/core/config/app_config.dart';
import 'package:mobile_flutter/core/constants/app_strings.dart';
import 'package:mobile_flutter/injection_container.dart' as di;
import 'package:mobile_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_bloc.dart';
import 'package:mobile_flutter/routes/app_router.dart';
import 'package:mobile_flutter/routes/route_names.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await AppConfig.load();

  // Initialize dependencies
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<TripBloc>()),
        BlocProvider(create: (_) => di.sl<DeliveryBloc>()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: RouteNames.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}