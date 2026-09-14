import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';

class GetRoutePlanUseCase implements UseCase<RoutePlanResult, NoParams> {
  final GetRoutePlanRepository repository;

  const GetRoutePlanUseCase({required this.repository});

  @override
  Future<Either<RoutePlanResult, StockControlAppError>> call(NoParams params) async {
    return await repository.getMyRoutePlan();
  }
}