import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/core/database/schemas/pending_action.dart';
export 'package:stock_control_app/core/provider/global.dart';

final StateProvider<AppState> syncStatusStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<List<PendingAction>> pendingActionsProvider = StateProvider(
  (ref) => [],
);

final StateProvider<bool> manualSyncInProgressProvider = StateProvider(
  (ref) => false,
);