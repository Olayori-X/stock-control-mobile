import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/create_pickup_request_repository.dart';

class CreatePickupRequestUseCase
    implements UseCase<PickupRequestResult, CreatePickupRequestParams> {
  final CreatePickupRequestRepository repository;

  const CreatePickupRequestUseCase({required this.repository});

  @override
  Future<Either<PickupRequestResult, StockControlAppError>> call(
    CreatePickupRequestParams params,
  ) async {
    return await repository.create(params);
  }
}