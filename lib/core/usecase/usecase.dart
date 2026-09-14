import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/core/error/error.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<SuccessType, StockControlAppError>> call(Params params);
}

class NoParams {
  const NoParams();
}
