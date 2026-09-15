import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ConfirmOutletVisitRepository {
  Future<Either<ConfirmVisitResult, StockControlAppError>> confirmVisit(
    ConfirmVisitParams params,
  );
}

class ConfirmVisitParams {
  final String outletId;
  final String routeDay;
  final double latitude;
  final double longitude;

  const ConfirmVisitParams({
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

  factory ConfirmVisitParams.fromJson(Map<String, dynamic> map) {
    return ConfirmVisitParams(
      outletId: map["outlet_id"],
      routeDay: map["route_day"],
      latitude: (map["latitude"] as num).toDouble(),
      longitude: (map["longitude"] as num).toDouble(),
    );
  }
}

// queued=true means this never reached the server — it was captured and
// stored locally because there was no connectivity. distanceM/geofenceStatus
// are null in that case, since we genuinely don't know the result yet;
// the UI must show "Pending Sync", not a fabricated PASS/FAIL.
class ConfirmVisitResult {
  final bool queued;
  final double? distanceM;
  final String? geofenceStatus;

  const ConfirmVisitResult({
    required this.queued,
    this.distanceM,
    this.geofenceStatus,
  });
}