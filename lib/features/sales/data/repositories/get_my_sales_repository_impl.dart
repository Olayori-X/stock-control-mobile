import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/sales/data/datasources/get_my_sales_datasource.dart';
import 'package:stock_control_app/features/sales/domain/repositories/get_my_sales_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class GetMySalesRepositoryImpl implements GetMySalesRepository {
  final GetMySalesDataSource dataSource;

  GetMySalesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<MySalesResult, StockControlAppError>> getMySales() async {
    try {
      final response = await dataSource.getMySales();

      return Either.left(
        MySalesResult(
          sales: response.sales
              .map((s) => SaleRecord(
                    transactionId: s.transactionId,
                    outletId: s.outletId,
                    sku: s.sku,
                    quantity: s.quantity,
                    totalValue: s.totalValue,
                    geofenceStatus: s.geofenceStatus,
                    createdAt: s.createdAt,
                  ))
              .toList(),
          totalQuantity: response.totalQuantity,
          totalValue: response.totalValue,
        ),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}