import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/scs/pickup/data/datasources/pickup_request_datasource.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_products_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class GetProductsRepositoryImpl implements GetProductsRepository {
  final PickupRequestDataSource dataSource;

  GetProductsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<ProductResult>, StockControlAppError>> getProducts() async {
    try {
      final response = await dataSource.getProducts();
      return Either.left(
        response.map((p) => ProductResult(sku: p.sku, name: p.name)).toList(),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}