import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';

class ConfirmOutletVisitUseCase
    implements UseCase<ConfirmVisitResult, ConfirmVisitParams> {
  final ConfirmOutletVisitRepository repository;

  const ConfirmOutletVisitUseCase({required this.repository});

  @override
  Future<Either<ConfirmVisitResult, StockControlAppError>> call(
    ConfirmVisitParams params,
  ) async {
    return await repository.confirmVisit(params);
  }
}