class ConfirmVisitPayload {
  final String outletId;
  final String routeDay;
  final double latitude;
  final double longitude;

  const ConfirmVisitPayload({
    required this.outletId,
    required this.routeDay,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "outlet_id": outletId,
      "route_day": routeDay,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}

class ConfirmVisitResponse {
  final double distanceM;
  final double radiusM;
  final String geofenceStatus;

  const ConfirmVisitResponse({
    required this.distanceM,
    required this.radiusM,
    required this.geofenceStatus,
  });

  factory ConfirmVisitResponse.fromJson(Map<String, dynamic> map) {
    return ConfirmVisitResponse(
      distanceM: (map["distance_m"] as num).toDouble(),
      radiusM: (map["radius_m"] as num).toDouble(),
      geofenceStatus: map["geofence_status"] ?? "",
    );
  }
}