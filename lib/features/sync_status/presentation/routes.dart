import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/sync_status/presentation/pages/sync_status_page.dart';

final List<GoRoute> syncStatusFeatureRoutes = [
  GoRoute(
    path: Pages.syncStatus.path,
    builder: (context, state) => const SyncStatusPage(),
  ),
];