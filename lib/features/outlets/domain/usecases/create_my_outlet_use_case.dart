import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/create_my_outlet_repository.dart';

class CreateMyOutletUseCase implements UseCase<CreatedOutletResult, CreateMyOutletParams> {
  final CreateMyOutletRepository repository;

  const CreateMyOutletUseCase({required this.repository});

  @override
  Future<Either<CreatedOutletResult, StockControlAppError>> call(
    CreateMyOutletParams params,
  ) async {
    return await repository.create(params);
  }
}