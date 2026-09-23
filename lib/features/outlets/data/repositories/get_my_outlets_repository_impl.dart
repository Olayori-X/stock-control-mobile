import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/outlets/data/datasources/get_my_outlets_datasource.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/get_my_outlets_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class GetMyOutletsRepositoryImpl implements GetMyOutletsRepository {
  final GetMyOutletsDataSource dataSource;

  GetMyOutletsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<OutletResult>, StockControlAppError>> getMyOutlets() async {
    try {
      final response = await dataSource.getMyOutlets();
      return Either.left(
        response
            .map((o) => OutletResult(
                  outletId: o.outletId,
                  name: o.name,
                  address: o.address,
                  outletType: o.outletType,
                  phone: o.phone,
                  latitude: o.latitude,
                  longitude: o.longitude,
                  area: o.area,
                  zone: o.zone,
                  routeDay: o.routeDay,
                  active: o.active,
                  createdAt: o.createdAt,
                ))
            .toList(),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}