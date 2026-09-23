import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GetMyOutletsRepository {
  Future<Either<List<OutletResult>, StockControlAppError>> getMyOutlets();
}

class OutletResult {
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

  const OutletResult({
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
}