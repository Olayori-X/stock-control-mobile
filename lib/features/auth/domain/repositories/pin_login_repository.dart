import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PinLoginRepository {
  Future<Either<PinLoginResult, StockControlAppError>> login(
    PinLoginParams params,
  );
}

class PinLoginParams {
  final String userId;
  final String pin;
  final double latitude;
  final double longitude;
  final String deviceRef;

  const PinLoginParams({
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

class PinLoginResult {
  final String userId;
  final String role;
  final bool verified;
  final String token;

  const PinLoginResult({
    required this.userId,
    required this.role,
    required this.verified,
    required this.token,
  });
}