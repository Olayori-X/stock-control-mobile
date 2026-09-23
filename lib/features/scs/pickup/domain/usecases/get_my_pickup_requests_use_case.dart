import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_my_pickup_requests_repository.dart';

class GetMyPickupRequestsUseCase implements UseCase<List<MyPickupRequestResult>, NoParams> {
  final GetMyPickupRequestsRepository repository;

  const GetMyPickupRequestsUseCase({required this.repository});

  @override
  Future<Either<List<MyPickupRequestResult>, StockControlAppError>> call(NoParams params) async {
    return await repository.getMyPickupRequests();
  }
}