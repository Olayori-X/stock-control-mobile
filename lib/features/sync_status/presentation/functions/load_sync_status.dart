import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/core/sync/sync_queue_repository.dart';
import 'package:stock_control_app/core/sync/sync_service.dart';
import 'package:stock_control_app/features/sync_status/presentation/provider/sync_status_provider.dart';

final _syncQueue = SyncQueueRepository();
final _syncService = SyncService();

void loadSyncStatus(WidgetRef ref) {
  ref.watch(syncStatusStateProvider.notifier).state = AppState.loading;
  _fetchPendingActions(ref);
}

Future<void> _fetchPendingActions(WidgetRef ref) async {
  try {
    final items = await _syncQueue.getUnsynced();
    ref.watch(pendingActionsProvider.notifier).state = items;
    ref.watch(syncStatusStateProvider.notifier).state = AppState.success;
  } catch (e) {
    ref.watch(syncStatusStateProvider.notifier).state = AppState.error;
  }
}

// Manual "Sync now" — useful when a user regains connectivity but the
// connectivity_plus listener hasn't fired yet, or they just want
// reassurance rather than waiting passively.
Future<void> triggerManualSync(WidgetRef ref) async {
  ref.watch(manualSyncInProgressProvider.notifier).state = true;
  await _syncService.drainQueue();
  ref.watch(manualSyncInProgressProvider.notifier).state = false;
  await _fetchPendingActions(ref); // refresh the list to reflect what just synced
}