// features/outlets/domain/repositories/delete_my_outlet_repository.dart
import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DeleteMyOutletRepository {
  Future<Either<bool, StockControlAppError>> deleteOutlet(String outletId);
}