class SubmitSalePayload {
  final String transactionId;
  final String outletId;
  final String routeDay;
  final String sku;
  final int quantity;
  final double latitude;
  final double longitude;

  const SubmitSalePayload({
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
}

// The backend's SubmitSaleHandler returns two very different shapes:
// a blocked response ({block_reason, sale_recorded, message, ...}) or a
// full models.Sale on success. Parsed leniently here since block_reason's
// presence is what distinguishes them.
class SubmitSaleResponse {
  final bool blocked;
  final String? blockReason;
  final String? message;
  final double? totalValue;

  const SubmitSaleResponse({
    required this.blocked,
    this.blockReason,
    this.message,
    this.totalValue,
  });

  factory SubmitSaleResponse.fromJson(Map<String, dynamic> map) {
    if (map.containsKey("block_reason")) {
      return SubmitSaleResponse(
        blocked: true,
        blockReason: map["block_reason"],
        message: map["message"],
      );
    }
    return SubmitSaleResponse(
      blocked: false,
      totalValue: (map["total_value"] as num?)?.toDouble(),
    );
  }
}