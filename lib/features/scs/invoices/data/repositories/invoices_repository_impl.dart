import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/scs/invoices/data/datasources/invoices_datasource.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class InvoicesRepositoryImpl implements InvoicesRepository {
  final InvoicesDataSource dataSource;

  InvoicesRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<InvoiceResult>, StockControlAppError>> getMyInvoices() async {
    try {
      final response = await dataSource.getMyInvoices();
      return Either.left(
        response
            .map((i) => InvoiceResult(
                  invoiceId: i.invoiceId,
                  requestId: i.requestId,
                  totalValue: i.totalValue,
                  outstandingValue: i.outstandingValue,
                  status: i.status,
                  dueAt: i.dueAt,
                  createdAt: i.createdAt,
                ))
            .toList(),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }

  @override
  Future<Either<List<ReceiptResult>, StockControlAppError>> getMyReceipts() async {
    try {
      final response = await dataSource.getMyReceipts();
      return Either.left(
        response
            .map((r) => ReceiptResult(
                  receiptId: r.receiptId,
                  invoiceId: r.invoiceId,
                  amountPaid: r.amountPaid,
                  paidAt: r.paidAt,
                ))
            .toList(),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}