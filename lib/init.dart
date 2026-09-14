import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/core/network/token.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/features/auth/data/datasources/pin_login_datasource.dart';
import 'package:stock_control_app/features/auth/data/repositories/pin_login_repository_impl.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';
import 'package:stock_control_app/features/auth/domain/usecases/pin_login_use_case.dart';
import 'package:stock_control_app/features/route/data/datasources/get_route_plan_datasource.dart';
import 'package:stock_control_app/features/route/data/repositories/get_route_plan_repository_impl.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';
import 'package:stock_control_app/features/route/domain/usecases/get_route_plan_use_case.dart';

final GetIt serviceLocator = GetIt.I;

Future<void> initializeAllDependencies() async {
  initAuthenticationDependencies();
}


void initAuthenticationDependencies(){
  serviceLocator.registerLazySingleton(() => AppTokens());
  serviceLocator.registerLazySingleton<UserCredentials>(
    () => UserCredentials(),
  );
  serviceLocator.registerLazySingleton<UserLocation>(() => UserLocation());
  serviceLocator.registerLazySingleton(() => SalesSession());

  //DATASOURCE  
  serviceLocator.registerFactory<PinLoginDataSource>(
    () => PinLoginRemoteDataSource(),
  );

  //REPOSITORIES
  serviceLocator.registerFactory<PinLoginRepository>(
    () => PinLoginRepositoryImpl(dataSource: serviceLocator()),
  );

  //USECASES
  serviceLocator.registerFactory(
    () => PinLoginUseCase(repository: serviceLocator()),
  );
}


void initRouteDependencies(){
  serviceLocator.registerLazySingleton(() => AppTokens());
  serviceLocator.registerLazySingleton<UserCredentials>(
    () => UserCredentials(),
  );
  serviceLocator.registerLazySingleton<UserLocation>(() => UserLocation());
  serviceLocator.registerLazySingleton(() => SalesSession());

  //DATASOURCE  
  serviceLocator.registerFactory<GetRoutePlanDataSource>(
    () => GetRoutePlanRemoteDataSource(),
  );

  //REPOSITORIES
  serviceLocator.registerFactory<GetRoutePlanRepository>(
    () => GetRoutePlanRepositoryImpl(dataSource: serviceLocator()),
  );

  //USECASES
  serviceLocator.registerFactory(
    () => GetRoutePlanUseCase(repository: serviceLocator()),
  );
}