import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SubmitSaleRepository {
  Future<Either<SubmitSaleResult, StockControlAppError>> submitSale(
    SubmitSaleParams params,
  );
}

class SubmitSaleParams {
  final String transactionId;
  final String outletId;
  final String routeDay;
  final String sku;
  final int quantity;
  final double latitude;
  final double longitude;

  const SubmitSaleParams({
    required this.transactionId,
    required this.outletId,
    required this.routeDay,
    required this.sku,
    required this.quantity,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "transaction_id": transactionId,
      "outlet_id": outletId,
      "route_day": routeDay,
      "sku": sku,
      "quantity": quantity,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory SubmitSaleParams.fromJson(Map<String, dynamic> map) {
    return SubmitSaleParams(
      transactionId: map["transaction_id"],
      outletId: map["outlet_id"],
      routeDay: map["route_day"],
      sku: map["sku"],
      quantity: map["quantity"],
      latitude: (map["latitude"] as num).toDouble(),
      longitude: (map["longitude"] as num).toDouble(),
    );
  }
}

// Mirrors the backend's three-way outcome exactly:
//   - queued: never reached the server (no connectivity)
//   - blocked: reached the server, but rejected (geofence FAIL or insufficient stock)
//   - otherwise: a real sale, either newly created or an idempotent replay
class SubmitSaleResult {
  final bool queued;
  final String? blockReason; // "geofence" | "insufficient_stock" | null
  final String? message;
  final double? totalValue;

  const SubmitSaleResult({
    required this.queued,
    this.blockReason,
    this.message,
    this.totalValue,
  });
}