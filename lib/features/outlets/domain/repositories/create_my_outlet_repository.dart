import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CreateMyOutletRepository {
  Future<Either<CreatedOutletResult, StockControlAppError>> create(
    CreateMyOutletParams params,
  );
}

class CreateMyOutletParams {
  final String name;
  final String address;
  final String outletType;
  final String phone;
  final double latitude;
  final double longitude;
  final String area;
  final String zone;

  const CreateMyOutletParams({
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

class CreatedOutletResult {
  final String outletId;
  final String name;
  final double latitude;
  final double longitude;

  const CreatedOutletResult({
    required this.outletId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}