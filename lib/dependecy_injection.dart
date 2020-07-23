import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:meet/features/login/data/datasources/login_datasource.dart';
import 'package:meet/features/login/data/repositories/login_repo_impl.dart';
import 'package:meet/features/login/domain/repositories/login_repository.dart';
import 'package:meet/features/login/domain/usecases/login_usecases.dart';
import 'package:meet/features/login/presentation/bloc/login_bloc.dart';
import 'package:meet/features/register/data/datasources/register_datasource.dart';
import 'package:meet/features/register/data/repositories/register_repo_impl.dart';
import 'package:meet/features/register/domain/repositories/register_repo.dart';
import 'package:meet/features/register/domain/usecases/register_usecase.dart';
import 'package:meet/features/register/presentation/bloc/register_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'network/netwrok_info.dart';

final GetIt sl = GetIt.instance;

void resetSL() {
  sl.reset();
}

Future<void> init() async {
  //! Features - Login User
  registerBlocs();
  registerUseCases();
  registerRepositories();
  registerDataSource();

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

void registerUseCases() {
  //* Use cases
  // ? Login Use Cases
  sl.registerLazySingleton(() => EmailPasswordUsecase(loginRepository: sl()));
  // ? Register Use Cases
  sl.registerLazySingleton(() => RegisterUsecase(registerRepository: sl()));
}

void registerDataSource() {
  //* Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSourceImpl(),
  );
}

void registerRepositories() {
  //* Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      loginRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<RegisterRepository>(
    () => RegisterRepositoryImpl(
      registerRemoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
}

void registerBlocs() {
  //* Bloc
  sl.registerFactory(
    () => LoginBloc(emailPasswordUsecase: sl()),
  );
  sl.registerFactory(
    () => RegisterBloc(registerUsecase: sl()),
  );
}
