// features/outlets/domain/usecases/delete_my_outlet_use_case.dart
import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/delete_my_outlet_repository.dart';

class DeleteMyOutletUseCase implements UseCase<bool, String> {
  final DeleteMyOutletRepository repository;

  const DeleteMyOutletUseCase({required this.repository});

  @override
  Future<Either<bool, StockControlAppError>> call(String outletId) async {
    return await repository.deleteOutlet(outletId);
  }
}