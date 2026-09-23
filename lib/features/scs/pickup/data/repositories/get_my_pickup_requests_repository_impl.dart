import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/scs/pickup/data/datasources/pickup_request_datasource.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_my_pickup_requests_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class GetMyPickupRequestsRepositoryImpl implements GetMyPickupRequestsRepository {
  final PickupRequestDataSource dataSource;

  GetMyPickupRequestsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<MyPickupRequestResult>, StockControlAppError>> getMyPickupRequests() async {
    try {
      final response = await dataSource.getMyPickupRequests();
      return Either.left(
        response
            .map((r) => MyPickupRequestResult(
                  requestId: r.requestId,
                  distributorId: r.distributorId,
                  distributorName: r.distributorName,
                  confirmed: r.confirmed,
                  products: r.products
                      .map((p) => PickupRequestProductItem(sku: p.sku, name: p.name, quantity: p.quantity))
                      .toList(),
                  createdAt: r.createdAt,
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