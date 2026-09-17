import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/core/network/token.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/sync/pending_action_type.dart';
import 'package:stock_control_app/core/sync/sync_handler.dart';
import 'package:stock_control_app/core/sync/sync_queue_repository.dart';
import 'package:stock_control_app/core/sync/sync_service.dart';
import 'package:stock_control_app/features/auth/data/datasources/pin_login_datasource.dart';
import 'package:stock_control_app/features/auth/data/repositories/pin_login_repository_impl.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';
import 'package:stock_control_app/features/auth/domain/usecases/pin_login_use_case.dart';
import 'package:stock_control_app/features/outlets/data/datasources/confirm_outlet_visit_datasource.dart';
import 'package:stock_control_app/features/outlets/data/datasources/create_my_outlet_datasource.dart';
import 'package:stock_control_app/features/outlets/data/repositories/confirm_outlet_visit_repository_impl.dart';
import 'package:stock_control_app/features/outlets/data/repositories/create_my_outlet_repository_impl.dart';
import 'package:stock_control_app/features/outlets/data/sync/outlet_visit_sync_handler.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/create_my_outlet_repository.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/confirm_outlet_visit_use_case.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/create_my_outlet_use_case.dart';
import 'package:stock_control_app/features/route/data/datasources/get_route_plan_datasource.dart';
import 'package:stock_control_app/features/route/data/repositories/get_route_plan_repository_impl.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';
import 'package:stock_control_app/features/route/domain/usecases/get_route_plan_use_case.dart';
import 'package:stock_control_app/features/sales/data/datasources/get_my_sales_datasource.dart';
import 'package:stock_control_app/features/sales/data/datasources/submit_sale_datasource.dart';
import 'package:stock_control_app/features/sales/data/repositories/get_my_sales_repository_impl.dart';
import 'package:stock_control_app/features/sales/data/repositories/submit_sale_repository_impl.dart';
import 'package:stock_control_app/features/sales/data/sync/sale_sync_handler.dart';
import 'package:stock_control_app/features/sales/domain/repositories/get_my_sales_repository.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';
import 'package:stock_control_app/features/sales/domain/usecases/get_my_sales_use_case.dart';
import 'package:stock_control_app/features/sales/domain/usecases/submit_sale_use_case.dart';
import 'package:stock_control_app/features/scs/invoices/data/datasources/invoices_datasource.dart';
import 'package:stock_control_app/features/scs/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';
import 'package:stock_control_app/features/scs/invoices/domain/usecases/get_my_invoices_use_case.dart';
import 'package:stock_control_app/features/scs/invoices/domain/usecases/get_my_receipts_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/data/datasources/pickup_request_datasource.dart';
import 'package:stock_control_app/features/scs/pickup/data/repositories/create_pickup_request_repository_impl.dart';
import 'package:stock_control_app/features/scs/pickup/data/repositories/get_products_repository_impl.dart';
import 'package:stock_control_app/features/scs/pickup/data/repositories/search_distributors_repository_impl.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/create_pickup_request_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_products_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/search_distributors_repository.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/create_pickup_request_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/get_products_use_case.dart';
import 'package:stock_control_app/features/scs/pickup/domain/usecases/search_distributors_use_case.dart';

final GetIt serviceLocator = GetIt.I;

Future<void> initializeAllDependencies() async {
  initSharedDependencies(); // must run first — every feature below relies on these
  initAuthenticationDependencies();
  initRouteDependencies();
  initOutletDependencies();
  initSaleDependencies();
  initPickupDependencies();
}

void initSharedDependencies() {
  serviceLocator.registerLazySingleton(() => AppTokens());
  serviceLocator.registerLazySingleton<UserCredentials>(
    () => UserCredentials(),
  );
  serviceLocator.registerLazySingleton<UserLocation>(() => UserLocation());
  serviceLocator.registerLazySingleton(() => SalesSession());
  serviceLocator.registerLazySingleton(() => SyncQueueRepository());
  serviceLocator.registerLazySingleton(() => SyncService());
}

void initAuthenticationDependencies() {
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

void initRouteDependencies() {
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

void initOutletDependencies() {
  //DATASOURCE
  serviceLocator.registerFactory<ConfirmOutletVisitDataSource>(
    () => ConfirmOutletVisitRemoteDataSource(),
  );

  serviceLocator.registerFactory<CreateMyOutletDataSource>(
    () => CreateMyOutletRemoteDataSource(),
  );

  //REPOSITORIES
  serviceLocator.registerFactory<ConfirmOutletVisitRepository>(
    () => ConfirmOutletVisitRepositoryImpl(
      dataSource: serviceLocator(),
      syncQueue: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<CreateMyOutletRepository>(
    () => CreateMyOutletRepositoryImpl(dataSource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => ConfirmOutletVisitUseCase(repository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => CreateMyOutletUseCase(repository: serviceLocator()),
  );

  serviceLocator.registerFactory<SyncHandler>(
    () => OutletVisitSyncHandler(),
    instanceName: PendingActionType.outletVisit.name,
  );
}

void initSaleDependencies() {
  //DATASOURCE
  serviceLocator.registerFactory<SubmitSaleDataSource>(
    () => SubmitSaleRemoteDataSource(),
  );

  serviceLocator.registerFactory<GetMySalesDataSource>(
    () => GetMySalesRemoteDataSource(),
  );

  //REPOSITORIES
  serviceLocator.registerFactory<SubmitSaleRepository>(
    () => SubmitSaleRepositoryImpl(
      dataSource: serviceLocator(),
      syncQueue: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<GetMySalesRepository>(
    () => GetMySalesRepositoryImpl(dataSource: serviceLocator()),
  );

  //USECASES
  serviceLocator.registerFactory(
    () => SubmitSaleUseCase(repository: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetMySalesUseCase(repository: serviceLocator()),
  );

  // Registers this feature's sync handler into the generic queue, keyed by
  // type — this is what lets SyncService call it without core/ ever
  // importing features/sales directly.
  serviceLocator.registerFactory<SyncHandler>(
    () => SaleSyncHandler(),
    instanceName: PendingActionType.sale.name,
  );
}


void initPickupDependencies() {

  //DATASOURCE
  serviceLocator.registerFactory<PickupRequestDataSource>(
    () => PickupRequestRemoteDataSource(),
  );

  //REPOSITORIES
  serviceLocator.registerFactory<SearchDistributorsRepository>(
    () => SearchDistributorsRepositoryImpl(dataSource: serviceLocator()),
  );
  serviceLocator.registerFactory<CreatePickupRequestRepository>(
    () => CreatePickupRequestRepositoryImpl(dataSource: serviceLocator()),
  );
  serviceLocator.registerFactory<GetProductsRepository>(
    () => GetProductsRepositoryImpl(dataSource: serviceLocator()),
  );

  //USECASES
  serviceLocator.registerFactory(
    () => SearchDistributorsUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => CreatePickupRequestUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => GetProductsUseCase(repository: serviceLocator()),
  );
}


void initInvoicesDependencies() {
  serviceLocator.registerFactory<InvoicesDataSource>(
    () => InvoicesRemoteDataSource(),
  );

  serviceLocator.registerFactory<InvoicesRepository>(
    () => InvoicesRepositoryImpl(dataSource: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => GetMyInvoicesUseCase(repository: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => GetMyReceiptsUseCase(repository: serviceLocator()),
  );
}