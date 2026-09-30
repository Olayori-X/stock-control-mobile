// features/outlets/data/repositories/delete_my_outlet_repository_impl.dart
import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/outlets/data/datasources/delete_my_outlet_datasource.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/delete_my_outlet_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class DeleteMyOutletRepositoryImpl implements DeleteMyOutletRepository {
  final DeleteMyOutletDataSource dataSource;

  DeleteMyOutletRepositoryImpl({required this.dataSource});

  @override
  Future<Either<bool, StockControlAppError>> deleteOutlet(String outletId) async {
    try {
      await dataSource.deleteOutlet(outletId);
      return Either.left(true);
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}