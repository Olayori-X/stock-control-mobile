import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';

class GetMyInvoicesUseCase implements UseCase<List<InvoiceResult>, NoParams> {
  final InvoicesRepository repository;

  const GetMyInvoicesUseCase({required this.repository});

  @override
  Future<Either<List<InvoiceResult>, StockControlAppError>> call(NoParams params) async {
    return await repository.getMyInvoices();
  }
}
