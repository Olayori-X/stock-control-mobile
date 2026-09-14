import 'package:stock_control_app/core/provider/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:stock_control_app/features/route/domain/usecases/get_route_plan_use_case.dart';
import 'package:stock_control_app/features/route/presentation/provider/route_provider.dart';

void loadTodayRoute(WidgetRef ref) {
  ref.watch(routeStateProvider.notifier).state = AppState.loading;
  _fetchRoutePlan(ref);
}

Future<void> _fetchRoutePlan(WidgetRef ref) async {
  GetRoutePlanUseCase useCase = GetIt.I.get();
  final response = await useCase(const NoParams());

  response.fold(
    (l) {
      ref.watch(routePlanProvider.notifier).state = l;
      ref.watch(routeStateProvider.notifier).state = AppState.success;
    },
    (r) {
      ref.watch(routeErrorMessageProvider.notifier).state = r.message;
      ref.watch(routeStateProvider.notifier).state = AppState.error;
    },
  );
}