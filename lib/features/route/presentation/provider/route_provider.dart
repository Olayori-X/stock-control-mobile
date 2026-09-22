import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final routeStateProvider = StateProvider.autoDispose<AppState>((ref) => AppState.initial);

final routeErrorMessageProvider = StateProvider.autoDispose<String>((ref) => "");

final routePlanProvider = StateProvider.autoDispose<RoutePlanResult?>((ref) => null);