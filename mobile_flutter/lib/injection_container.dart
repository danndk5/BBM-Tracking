// lib/injection_container.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_flutter/core/network/dio_client.dart';
import 'package:mobile_flutter/core/network/network_info.dart';
import 'package:mobile_flutter/data/datasources/local/auth_local_datasource.dart';
import 'package:mobile_flutter/data/datasources/local/delivery_local_datasource.dart';
import 'package:mobile_flutter/data/datasources/local/local_database.dart';
import 'package:mobile_flutter/data/datasources/local/trip_local_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/auth_remote_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/delivery_remote_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/spbu_remote_datasource.dart';
import 'package:mobile_flutter/data/datasources/remote/trip_remote_datasource.dart';
import 'package:mobile_flutter/data/repositories/auth_repository_impl.dart';
import 'package:mobile_flutter/data/repositories/delivery_repository_impl.dart';
import 'package:mobile_flutter/data/repositories/trip_repository_impl.dart';
import 'package:mobile_flutter/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter/domain/repositories/delivery_repository.dart';
import 'package:mobile_flutter/domain/repositories/trip_repository.dart';
import 'package:mobile_flutter/domain/usecases/auth/login_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/create_next_delivery_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/update_mulai_bongkar_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/update_selesai_bongkar_usecase.dart';
import 'package:mobile_flutter/domain/usecases/delivery/update_tiba_usecase.dart';
import 'package:mobile_flutter/domain/usecases/trip/create_trip_usecase.dart';
import 'package:mobile_flutter/domain/usecases/trip/get_active_trip_usecase.dart';
import 'package:mobile_flutter/presentation/bloc/auth/auth_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/delivery/delivery_bloc.dart';
import 'package:mobile_flutter/presentation/bloc/trip/trip_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => TripBloc(
        createTripUseCase: sl(),
        getActiveTripUseCase: sl(),
        tripRepository: sl(),
      ));
  sl.registerFactory(() => DeliveryBloc(
        updateTibaUseCase: sl(),
        updateMulaiBongkarUseCase: sl(),
        updateSelesaiBongkarUseCase: sl(),
        createNextDeliveryUseCase: sl(),
        deliveryRepository: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => CreateTripUseCase(sl()));
  sl.registerLazySingleton(() => GetActiveTripUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTibaUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMulaiBongkarUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSelesaiBongkarUseCase(sl()));
  sl.registerLazySingleton(() => CreateNextDeliveryUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      spbuRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<DeliveryRepository>(
    () => DeliveryRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources - Remote
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DeliveryRemoteDataSource>(
    () => DeliveryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SpbuRemoteDataSource>(
    () => SpbuRemoteDataSourceImpl(sl()),
  );

  // Data Sources - Local
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TripLocalDataSource>(
    () => TripLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DeliveryLocalDataSource>(
    () => DeliveryLocalDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => LocalDatabase());

  // External
  sl.registerLazySingleton(() => Connectivity());
}