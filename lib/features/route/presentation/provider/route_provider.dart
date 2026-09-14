import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final StateProvider<AppState> routeStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<String> routeErrorMessageProvider = StateProvider(
  (ref) => "",
);

final StateProvider<RoutePlanResult?> routePlanProvider = StateProvider(
  (ref) => null,
);