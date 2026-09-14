import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/core/error/error.dart';

abstract interface class GetRoutePlanRepository {
  Future<Either<RoutePlanResult, StockControlAppError>> getMyRoutePlan();
}

class RoutePlanStop {
  final String outletId;
  final String outletName;
  final double latitude;
  final double longitude;
  final String address;
  final int sequence;

  const RoutePlanStop({
    required this.outletId,
    required this.outletName,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.sequence,
  });
}

class RoutePlanResult {
  final String salesAssociateId;
  final String routeDay;
  final bool approved;
  final List<RoutePlanStop> stops;
  final DateTime updatedAt;

  const RoutePlanResult({
    required this.salesAssociateId,
    required this.routeDay,
    required this.approved,
    required this.stops,
    required this.updatedAt,
  });
}