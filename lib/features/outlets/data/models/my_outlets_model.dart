class OutletResponse {
  final String outletId;
  final String name;
  final String address;
  final String outletType;
  final String phone;
  final double latitude;
  final double longitude;
  final String area;
  final String zone;
  final String routeDay;
  final bool active;
  final DateTime createdAt;

  const OutletResponse({
    required this.outletId,
    required this.name,
    required this.address,
    required this.outletType,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.zone,
    required this.routeDay,
    required this.active,
    required this.createdAt,
  });

  factory OutletResponse.fromJson(Map<String, dynamic> map) {
    return OutletResponse(
      outletId: map["outlet_id"] ?? "",
      name: map["name"] ?? "",
      address: map["address"] ?? "",
      outletType: map["outlet_type"] ?? "",
      phone: map["phone"] ?? "",
      latitude: (map["latitude"] as num?)?.toDouble() ?? 0,
      longitude: (map["longitude"] as num?)?.toDouble() ?? 0,
      area: map["area"] ?? "",
      zone: map["zone"] ?? "",
      routeDay: map["route_day"] ?? "",
      active: map["active"] ?? false,
      createdAt: DateTime.tryParse(map["created_at"] ?? "") ?? DateTime.now(),
    );
  }
}