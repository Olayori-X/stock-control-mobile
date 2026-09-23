import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GetMyPickupRequestsRepository {
  Future<Either<List<MyPickupRequestResult>, StockControlAppError>> getMyPickupRequests();
}

class PickupRequestProductItem {
  final String sku;
  final String name;
  final int quantity;

  const PickupRequestProductItem({
    required this.sku,
    required this.name,
    required this.quantity,
  });
}

class MyPickupRequestResult {
  final String requestId;
  final String distributorId;
  final String distributorName; // backend field is named sales_associate_name but holds the distributor's name for this endpoint — see note in datasource
  final bool confirmed;
  final List<PickupRequestProductItem> products;
  final DateTime createdAt;

  const MyPickupRequestResult({
    required this.requestId,
    required this.distributorId,
    required this.distributorName,
    required this.confirmed,
    required this.products,
    required this.createdAt,
  });
}