class PinLoginPayload {
  final String userId;
  final String pin;
  final double latitude;
  final double longitude;
  final String deviceRef;

  const PinLoginPayload({
    required this.userId,
    required this.pin,
    required this.latitude,
    required this.longitude,
    required this.deviceRef,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "pin": pin,
      "latitude": latitude,
      "longitude": longitude,
      "device_ref": deviceRef,
    };
  }
}

class PinLoginResponse {
  final String userId;
  final String role;
  final bool verified;
  final String token;

  const PinLoginResponse({
    required this.userId,
    required this.role,
    required this.verified,
    required this.token,
  });

  factory PinLoginResponse.fromJson(Map<String, dynamic> map) {
    return PinLoginResponse(
      userId: map["user_id"] ?? "",
      role: map["role"] ?? "",
      verified: map["verified"] ?? false,
      token: map["token"] ?? "",
    );
  }
}