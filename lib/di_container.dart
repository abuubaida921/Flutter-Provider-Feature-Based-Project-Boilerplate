import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  sl.registerFactory(() => CategoryController(categoryServiceInterface: sl()));

  //interface

  AuthRepoInterface authRepoInterface = AuthRepository(dioClient: sl(), sharedPreferences: sl());
  sl.registerLazySingleton(() => authRepoInterface);
  AuthServiceInterface authServiceInterface = AuthService(authRepoInterface: sl());
  sl.registerLazySingleton(() => authServiceInterface);


  //services
  sl.registerLazySingleton(() => AuthService(authRepoInterface : sl()));
}
