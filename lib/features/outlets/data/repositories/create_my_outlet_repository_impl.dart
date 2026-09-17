import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/outlets/data/datasources/create_my_outlet_datasource.dart';
import 'package:stock_control_app/features/outlets/data/models/create_outlet_model.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/create_my_outlet_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class CreateMyOutletRepositoryImpl implements CreateMyOutletRepository {
  final CreateMyOutletDataSource dataSource;

  CreateMyOutletRepositoryImpl({required this.dataSource});

  @override
  Future<Either<CreatedOutletResult, StockControlAppError>> create(
    CreateMyOutletParams params,
  ) async {
    final payload = CreateOutletPayload(
      name: params.name,
      address: params.address,
      outletType: params.outletType,
      phone: params.phone,
      latitude: params.latitude,
      longitude: params.longitude,
      area: params.area,
      zone: params.zone,
    );

    try {
      final response = await dataSource.create(payload);
      return Either.left(
        CreatedOutletResult(
          outletId: response.outletId,
          name: response.name,
          latitude: response.latitude,
          longitude: response.longitude,
        ),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}