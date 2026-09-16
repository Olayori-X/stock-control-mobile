class SaleRecordResponse {
  final String transactionId;
  final String outletId;
  final String sku;
  final int quantity;
  final double totalValue;
  final String geofenceStatus;
  final DateTime createdAt;

  const SaleRecordResponse({
    required this.transactionId,
    required this.outletId,
    required this.sku,
    required this.quantity,
    required this.totalValue,
    required this.geofenceStatus,
    required this.createdAt,
  });

  factory SaleRecordResponse.fromJson(Map<String, dynamic> map) {
    return SaleRecordResponse(
      transactionId: map["transaction_id"] ?? "",
      outletId: map["outlet_id"] ?? "",
      sku: map["sku"] ?? "",
      quantity: map["quantity"] ?? 0,
      totalValue: (map["total_value"] as num?)?.toDouble() ?? 0,
      geofenceStatus: map["geofence_status"] ?? "",
      createdAt: DateTime.tryParse(map["created_at"] ?? "") ?? DateTime.now(),
    );
  }
}

class MySalesResponse {
  final List<SaleRecordResponse> sales;
  final int totalQuantity;
  final double totalValue;

  const MySalesResponse({
    required this.sales,
    required this.totalQuantity,
    required this.totalValue,
  });

  factory MySalesResponse.fromJson(Map<String, dynamic> map) {
    return MySalesResponse(
      sales: ((map["sales"] as List?) ?? [])
          .map((s) => SaleRecordResponse.fromJson(s as Map<String, dynamic>))
          .toList(),
      totalQuantity: map["total_quantity"] ?? 0,
      totalValue: (map["total_value"] as num?)?.toDouble() ?? 0,
    );
  }
}