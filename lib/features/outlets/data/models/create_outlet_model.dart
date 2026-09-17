class CreateOutletPayload {
  final String name;
  final String address;
  final String outletType;
  final String phone;
  final double latitude;
  final double longitude;
  final String area;
  final String zone;

  const CreateOutletPayload({
    required this.name,
    required this.address,
    required this.outletType,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.area,
    required this.zone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "outlet_type": outletType,
      "phone": phone,
      "latitude": latitude,
      "longitude": longitude,
      "area": area,
      "zone": zone,
    };
  }
}

class CreateOutletResponse {
  final String outletId;
  final String name;
  final double latitude;
  final double longitude;

  const CreateOutletResponse({
    required this.outletId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory CreateOutletResponse.fromJson(Map<String, dynamic> map) {
    return CreateOutletResponse(
      outletId: map["outlet_id"] ?? "",
      name: map["name"] ?? "",
      latitude: (map["latitude"] as num?)?.toDouble() ?? 0,
      longitude: (map["longitude"] as num?)?.toDouble() ?? 0,
    );
  }
}