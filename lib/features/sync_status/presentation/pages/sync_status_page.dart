import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/core/sync/pending_action_type.dart';
import 'package:stock_control_app/features/sync_status/presentation/provider/sync_status_provider.dart';
import 'package:stock_control_app/features/sync_status/presentation/functions/load_sync_status.dart';

class SyncStatusPage extends ConsumerStatefulWidget {
  const SyncStatusPage({super.key});

  @override
  ConsumerState<SyncStatusPage> createState() => _SyncStatusPageState();
}

class _SyncStatusPageState extends ConsumerState<SyncStatusPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadSyncStatus(ref));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(syncStatusStateProvider);
    final items = ref.watch(pendingActionsProvider);
    final syncing = ref.watch(manualSyncInProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sync Status"),
        actions: [
          IconButton(
            icon: syncing
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.sync),
            onPressed: syncing ? null : () => triggerManualSync(ref),
            tooltip: "Sync now",
          ),
        ],
      ),
      body: switch (state) {
        AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
        AppState.error => const Center(child: Text("Could not load sync status.")),
        AppState.success => items.isEmpty
            ? const Center(child: Text("Everything is synced."))
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final type = PendingActionType.values.byName(item.type);
                  return ListTile(
                    leading: _statusIcon(item.status),
                    title: Text(type == PendingActionType.outletVisit ? "Outlet visit" : "Sale"),
                    subtitle: Text(
                      "${_statusLabel(item.status)} · captured ${item.capturedAt.toLocal()}"
                      "${item.lastError != null ? '\n${item.lastError}' : ''}",
                    ),
                    isThreeLine: item.lastError != null,
                  );
                },
              ),
      },
    );
  }

  Widget _statusIcon(String status) {
    return switch (status) {
      "pending" => const Icon(Icons.schedule, color: Colors.amber),
      "syncing" => const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)),
      "failed" => const Icon(Icons.error_outline, color: Colors.red),
      _ => const Icon(Icons.check_circle_outline, color: Colors.green),
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      "pending" => "Waiting to sync",
      "syncing" => "Syncing…",
      "failed" => "Failed — will retry automatically",
      _ => status,
    };
  }
}