import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/sync/sync_handler.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/confirm_outlet_visit_use_case.dart';

class OutletVisitSyncHandler implements SyncHandler {
  @override
  Future<bool> execute(String payloadJson, String? transactionId) async {
    final params = ConfirmVisitParams.fromJson(jsonDecode(payloadJson));

    ConfirmOutletVisitUseCase useCase = GetIt.I.get();
    final response = await useCase(params);

    // A queued retry landing on the server successfully counts as
    // success regardless of PASS/FAIL geofence result — the geofence
    // outcome itself was already recorded server-side either way (see
    // RecordOutletVisit's audit-trail-always principle). "Synced" means
    // "the attempt reached the server," not "the attempt passed."
    return response.isLeft();
  }
}