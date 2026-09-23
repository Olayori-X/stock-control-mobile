import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/get_my_outlets_repository.dart';

class GetMyOutletsUseCase implements UseCase<List<OutletResult>, NoParams> {
  final GetMyOutletsRepository repository;

  const GetMyOutletsUseCase({required this.repository});

  @override
  Future<Either<List<OutletResult>, StockControlAppError>> call(NoParams params) async {
    return await repository.getMyOutlets();
  }
}