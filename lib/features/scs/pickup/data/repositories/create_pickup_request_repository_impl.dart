import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/scs/pickup/data/datasources/pickup_request_datasource.dart';
import 'package:stock_control_app/features/scs/pickup/data/models/pickup_request_model.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/create_pickup_request_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class CreatePickupRequestRepositoryImpl implements CreatePickupRequestRepository {
  final PickupRequestDataSource dataSource;

  CreatePickupRequestRepositoryImpl({required this.dataSource});

  @override
  Future<Either<PickupRequestResult, StockControlAppError>> create(
    CreatePickupRequestParams params,
  ) async {
    final payload = CreatePickupRequestPayload(
      distributorId: params.distributorId,
      products: params.products.map((p) => p.toJson()).toList(),
    );

    try {
      final response = await dataSource.createPickupRequest(payload);
      return Either.left(
        PickupRequestResult(
          requestId: response.requestId,
          confirmed: response.confirmed,
          createdAt: response.createdAt,
        ),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}