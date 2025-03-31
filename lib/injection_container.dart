import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/authentication/data/datasources/auth_local_data_source.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/sign_in.dart';
import 'features/authentication/domain/usecases/sign_up.dart';
import 'features/authentication/domain/usecases/verify_id.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'core/network/network_info.dart';
import 'features/schedule/data/datasources/schedule_local_data_source.dart';
import 'features/schedule/data/datasources/schedule_remote_data_source.dart';
import 'features/schedule/data/repositories/schedule_repository_impl.dart';
import 'features/schedule/domain/repositories/schedule_repository.dart';
import 'features/schedule/domain/usecases/get_attendance_records.dart';
import 'features/schedule/domain/usecases/get_salary_info.dart';
import 'features/schedule/presentation/bloc/schedule_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Authentication
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      verifyId: sl(),
    ),
  );
    sl.registerFactory(
    () => ScheduleBloc(
      getAttendanceRecords: sl(),
      getSalaryInfo: sl(),
      repository: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => VerifyId(sl()));
  sl.registerLazySingleton(() => GetAttendanceRecords(sl()));
  sl.registerLazySingleton(() => GetSalaryInfo(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
   sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
   sl.registerLazySingleton<ScheduleRemoteDataSource>(
    () => ScheduleRemoteDataSourceImpl(
      client: sl(),
      baseUrl: 'https://67a70d51510789ef0dfcd43d.mockapi.io/', 
    ),
  );

  sl.registerLazySingleton<ScheduleLocalDataSource>(
    () => ScheduleLocalDataSourceImpl(sharedPreferences: sl()),
  );
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());

  
}