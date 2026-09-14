import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/route/data/datasources/get_route_plan_datasource.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class GetRoutePlanRepositoryImpl implements GetRoutePlanRepository {
  final GetRoutePlanDataSource dataSource;

  GetRoutePlanRepositoryImpl({required this.dataSource});

  @override
  Future<Either<RoutePlanResult, StockControlAppError>> getMyRoutePlan() async {
    try {
      final response = await dataSource.getMyRoutePlan();

      return Either.left(
        RoutePlanResult(
          salesAssociateId: response.salesAssociateId,
          routeDay: response.routeDay,
          approved: response.approved,
          stops: response.stops
              .map((s) => RoutePlanStop(
                    outletId: s.outletId,
                    outletName: s.outletName,
                    latitude: s.latitude,
                    longitude: s.longitude,
                    address: s.address,
                    sequence: s.sequence,
                  ))
              .toList(),
          updatedAt: response.updatedAt,
        ),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}