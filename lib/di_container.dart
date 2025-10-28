import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_provider_feature_based_project_boilerplate/theme/controllers/theme_controller.dart';
import 'package:flutter_provider_feature_based_project_boilerplate/util/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/auth_repository_interface.dart';
import 'features/auth/domain/services/auth_service.dart';
import 'features/auth/domain/services/auth_service_interface.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'features/splash/controllers/splash_controller.dart';
import 'features/splash/domain/repositories/splash_repository.dart';
import 'features/splash/domain/repositories/splash_repository_interface.dart';
import 'features/splash/domain/services/splash_service.dart';
import 'features/splash/domain/services/splash_service_interface.dart';
import 'helper/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => OnBoardingRepository(dioClient: sl()));
  sl.registerLazySingleton(() => AuthRepository(dioClient: sl(), sharedPreferences: sl()));


  // Provider
  sl.registerFactory(() => ThemeController(sharedPreferences: sl()));
  sl.registerFactory(() => SplashController(splashServiceInterface: sl()));

  //interface
  AuthRepoInterface authRepoInterface = AuthRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => authRepoInterface);

  AuthServiceInterface authServiceInterface = AuthService(authRepoInterface: sl());
  sl.registerLazySingleton(() => authServiceInterface);


  SplashRepositoryInterface splashRepositoryInterface = SplashRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => splashRepositoryInterface);

  SplashServiceInterface splashServiceInterface = SplashService(splashRepositoryInterface: sl());
  sl.registerLazySingleton(() => splashServiceInterface);


  //services
  sl.registerLazySingleton(() => AuthService(authRepoInterface : sl()));
  sl.registerLazySingleton(() => SplashService(splashRepositoryInterface : sl()));
}
