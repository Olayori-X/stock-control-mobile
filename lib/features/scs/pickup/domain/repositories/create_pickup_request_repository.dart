import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CreatePickupRequestRepository {
  Future<Either<PickupRequestResult, StockControlAppError>> create(
    CreatePickupRequestParams params,
  );
}

class PickupProductItem {
  final String sku;
  final String name;
  final int quantity;

  const PickupProductItem({
    required this.sku,
    required this.name,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {"sku": sku, "name": name, "quantity": quantity};
  }
}

class CreatePickupRequestParams {
  final String distributorId;
  final List<PickupProductItem> products;

  const CreatePickupRequestParams({
    required this.distributorId,
    required this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      "distributor_id": distributorId,
      "products": products.map((p) => p.toJson()).toList(),
    };
  }
}

class PickupRequestResult {
  final String requestId;
  final bool confirmed;
  final DateTime createdAt;

  const PickupRequestResult({
    required this.requestId,
    required this.confirmed,
    required this.createdAt,
  });
}