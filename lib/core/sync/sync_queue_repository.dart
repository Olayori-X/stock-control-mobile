import 'package:isar/isar.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/database/schemas/pending_action.dart';
import 'package:stock_control_app/core/sync/pending_action_type.dart';

class SyncQueueRepository {
  Isar get _isar => GetIt.I<Isar>();

  Future<void> enqueue({
    required PendingActionType type,
    required String payloadJson,
    String? transactionId,
    required DateTime capturedAt,
  }) async {
    final action = PendingAction()
      ..type = type.name
      ..payloadJson = payloadJson
      ..status = "pending"
      ..transactionId = transactionId
      ..capturedAt = capturedAt;

    await _isar.writeTxn(() => _isar.pendingActions.put(action));
  }

  Future<List<PendingAction>> getPending() async {
    return _isar.pendingActions
        .filter()
        .statusEqualTo("pending")
        .sortByCapturedAt()
        .findAll();
  }

  Future<void> markSyncing(Id id) async {
    await _updateStatus(id, "syncing");
  }

  Future<void> markSynced(Id id) async {
    await _updateStatus(id, "synced");
  }

  Future<void> markFailed(Id id, String error) async {
    final action = await _isar.pendingActions.get(id);
    if (action == null) return;
    action.status = "failed";
    action.lastError = error;
    action.retryCount += 1;
    await _isar.writeTxn(() => _isar.pendingActions.put(action));
  }

  // Failed items get one more chance on the next sync cycle rather than
  // staying stuck forever — a transient server hiccup shouldn't
  // permanently strand a legitimate offline action.
  Future<void> resetFailedToPending() async {
    final failed =
        await _isar.pendingActions.filter().statusEqualTo("failed").findAll();
    for (final action in failed) {
      action.status = "pending";
    }
    await _isar.writeTxn(() => _isar.pendingActions.putAll(failed));
  }

  Future<void> _updateStatus(Id id, String status) async {
    final action = await _isar.pendingActions.get(id);
    if (action == null) return;
    action.status = status;
    await _isar.writeTxn(() => _isar.pendingActions.put(action));
  }

  // For the Sync Status / Offline Queue screen — all non-synced items.
  Future<List<PendingAction>> getUnsynced() async {
    return _isar.pendingActions
        .filter()
        .not()
        .statusEqualTo("synced")
        .sortByCapturedAtDesc()
        .findAll();
  }
}