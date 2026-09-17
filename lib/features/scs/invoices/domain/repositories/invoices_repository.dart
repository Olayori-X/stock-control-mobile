import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class InvoicesRepository {
  Future<Either<List<InvoiceResult>, StockControlAppError>> getMyInvoices();
  Future<Either<List<ReceiptResult>, StockControlAppError>> getMyReceipts();
}

class InvoiceResult {
  final String invoiceId;
  final String requestId;
  final double totalValue;
  final double outstandingValue;
  final String status; // open | paid | overdue
  final DateTime dueAt;
  final DateTime createdAt;

  const InvoiceResult({
    required this.invoiceId,
    required this.requestId,
    required this.totalValue,
    required this.outstandingValue,
    required this.status,
    required this.dueAt,
    required this.createdAt,
  });
}

class ReceiptResult {
  final String receiptId;
  final String invoiceId;
  final double amountPaid;
  final DateTime paidAt;

  const ReceiptResult({
    required this.receiptId,
    required this.invoiceId,
    required this.amountPaid,
    required this.paidAt,
  });
}