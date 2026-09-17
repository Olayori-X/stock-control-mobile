import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';

class GetMyReceiptsUseCase implements UseCase<List<ReceiptResult>, NoParams> {
  final InvoicesRepository repository;

  const GetMyReceiptsUseCase({required this.repository});

  @override
  Future<Either<List<ReceiptResult>, StockControlAppError>> call(NoParams params) async {
    return await repository.getMyReceipts();
  }
}