import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/sales/domain/repositories/get_my_sales_repository.dart';

class GetMySalesUseCase implements UseCase<MySalesResult, NoParams> {
  final GetMySalesRepository repository;

  const GetMySalesUseCase({required this.repository});

  @override
  Future<Either<MySalesResult, StockControlAppError>> call(NoParams params) async {
    return await repository.getMySales();
  }
}