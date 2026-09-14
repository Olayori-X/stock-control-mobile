import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/auth/domain/repositories/pin_login_repository.dart';

class PinLoginUseCase implements UseCase<PinLoginResult, PinLoginParams> {
  final PinLoginRepository repository;

  const PinLoginUseCase({required this.repository});

  @override
  Future<Either<PinLoginResult, StockControlAppError>> call(
    PinLoginParams params,
  ) async {
    return await repository.login(params);
  }
}