import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/features/auth/data/datasources/pin_login_datasource.dart';
import 'package:stock_control_app/features/auth/data/models/pin_login_model.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';

class PinLoginRepositoryImpl implements PinLoginRepository {
  final PinLoginDataSource dataSource;

  PinLoginRepositoryImpl({required this.dataSource});

  @override
  Future<Either<PinLoginResult, StockControlAppError>> login(
    PinLoginParams params,
  ) async {
    PinLoginPayload payload = PinLoginPayload(
      userId: params.userId,
      pin: params.pin,
      latitude: params.latitude,
      longitude: params.longitude,
      deviceRef: params.deviceRef,
    );

    try {
      PinLoginResponse response = await dataSource.login(payload);

      // Same in-place mutation pattern as UserCredentials.sellerid — the
      // singleton is updated here so the rest of the app can read it via
      // GetIt immediately after a successful login.
      final session = GetIt.I<SalesSession>();
      session.userId = response.userId;
      session.role = response.role;
      session.verified = response.verified;
      session.token = response.token;

      return Either.left(
        PinLoginResult(
          userId: response.userId,
          role: response.role,
          verified: response.verified,
          token: response.token,
        ),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}