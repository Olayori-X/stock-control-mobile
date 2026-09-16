import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';

class SubmitSaleUseCase implements UseCase<SubmitSaleResult, SubmitSaleParams> {
  final SubmitSaleRepository repository;

  const SubmitSaleUseCase({required this.repository});

  @override
  Future<Either<SubmitSaleResult, StockControlAppError>> call(
    SubmitSaleParams params,
  ) async {
    return await repository.submitSale(params);
  }
}