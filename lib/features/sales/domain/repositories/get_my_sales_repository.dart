import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GetMySalesRepository {
  Future<Either<MySalesResult, StockControlAppError>> getMySales();
}

class SaleRecord {
  final String transactionId;
  final String outletId;
  final String sku;
  final int quantity;
  final double totalValue;
  final String geofenceStatus;
  final DateTime createdAt;

  const SaleRecord({
    required this.transactionId,
    required this.outletId,
    required this.sku,
    required this.quantity,
    required this.totalValue,
    required this.geofenceStatus,
    required this.createdAt,
  });
}

class MySalesResult {
  final List<SaleRecord> sales;
  final int totalQuantity;
  final double totalValue;

  const MySalesResult({
    required this.sales,
    required this.totalQuantity,
    required this.totalValue,
  });
}