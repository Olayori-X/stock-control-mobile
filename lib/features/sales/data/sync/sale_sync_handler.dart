import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/sync/sync_handler.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';
import 'package:stock_control_app/features/sales/domain/usecases/submit_sale_use_case.dart';

class SaleSyncHandler implements SyncHandler {
  @override
  Future<bool> execute(String payloadJson, String? transactionId) async {
    final params = SubmitSaleParams.fromJson(jsonDecode(payloadJson));

    SubmitSaleUseCase useCase = GetIt.I.get();
    final response = await useCase(params);

    // Reaching the server counts as synced regardless of block_reason —
    // same reasoning as OutletVisitSyncHandler: a geofence/stock block
    // discovered on retry is a legitimate outcome the backend has now
    // recorded, not a sync failure. Only a genuine error (network still
    // down, or an unexpected exception) should cause a retry.
    return response.isLeft();
  }
}