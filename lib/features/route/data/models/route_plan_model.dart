class RoutePlanStopResponse {
  final String outletId;
  final String outletName;
  final double latitude;
  final double longitude;
  final String address;
  final int sequence;

  const RoutePlanStopResponse({
    required this.outletId,
    required this.outletName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.sequence,
  });

  factory RoutePlanStopResponse.fromJson(Map<String, dynamic> map) {
    return RoutePlanStopResponse(
      outletId: map["outlet_id"] ?? "",
      outletName: map["outlet_name"] ?? "",
      latitude: (map["latitude"] ?? 0).toDouble(),
      longitude: (map["longitude"] ?? 0).toDouble(),
      address: map["address"] ?? "",
      sequence: map["sequence"] ?? 0,
    );
  }
}

class RoutePlanResponse {
  final String salesAssociateId;
  final String routeDay;
  final bool approved;
  final List<RoutePlanStopResponse> stops;
  final DateTime updatedAt;

  const RoutePlanResponse({
    required this.salesAssociateId,
    required this.routeDay,
    required this.approved,
    required this.stops,
    required this.updatedAt,
  });

  factory RoutePlanResponse.fromJson(Map<String, dynamic> map) {
    return RoutePlanResponse(
      salesAssociateId: map["sales_associate_id"] ?? "",
      routeDay: map["route_day"] ?? "",
      approved: map["approved"] ?? false,
      stops: ((map["stops"] as List?) ?? [])
          .map((s) => RoutePlanStopResponse.fromJson(s as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.tryParse(map["updated_at"] ?? "") ?? DateTime.now(),
    );
  }
}