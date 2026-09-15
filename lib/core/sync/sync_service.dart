import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/database/schemas/pending_action.dart';
import 'package:stock_control_app/core/sync/pending_action_type.dart';
import 'package:stock_control_app/core/sync/sync_handler.dart';
import 'package:stock_control_app/core/sync/sync_queue_repository.dart';

class SyncService {
  final SyncQueueRepository _queue = SyncQueueRepository();
  bool _draining = false;

  // Call once, after DatabaseHandler.init() and initializeAllDependencies(),
  // so this listener lives for the app's lifetime.
  void start() {
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        drainQueue();
      }
    });

    // Also attempt a drain immediately at startup, in case the app was
    // opened already online with items queued from a previous offline
    // session.
    drainQueue();
  }

  Future<void> drainQueue() async {
    if (_draining) return; // avoid overlapping drains from rapid connectivity flapping
    _draining = true;

    try {
      await _queue.resetFailedToPending();
      final pending = await _queue.getPending();

      // Processed in capturedAt order — oldest action first, matching the
      // sequence things actually happened in the field.
      for (final action in pending) {
        await _processOne(action);
      }
    } finally {
      _draining = false;
    }
  }

  Future<void> _processOne(PendingAction action) async {
    await _queue.markSyncing(action.id);

    try {
      final type = PendingActionType.values.byName(action.type);
      final handler = GetIt.I<SyncHandler>(instanceName: type.name);

      final success = await handler.execute(action.payloadJson, action.transactionId);

      if (success) {
        await _queue.markSynced(action.id);
      } else {
        await _queue.markFailed(action.id, "Sync attempt did not succeed");
      }
    } catch (e) {
      await _queue.markFailed(action.id, e.toString());
    }
  }
}