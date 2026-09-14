import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/route/presentation/provider/route_provider.dart';
import 'package:stock_control_app/features/route/presentation/functions/load_route.dart';

class TodayRoutePage extends ConsumerStatefulWidget {
  const TodayRoutePage({super.key});

  @override
  ConsumerState<TodayRoutePage> createState() => _TodayRoutePageState();
}

class _TodayRoutePageState extends ConsumerState<TodayRoutePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadTodayRoute(ref));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(routeStateProvider);
    final plan = ref.watch(routePlanProvider);
    final errorMessage = ref.watch(routeErrorMessageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Today's Route")),
      body: switch (state) {
        AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
        AppState.error => Center(child: Text(errorMessage)),
        AppState.success => plan == null || plan.stops.isEmpty
            ? const Center(child: Text("No outlets planned for today."))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: plan.stops.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final stop = plan.stops[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${stop.sequence}")),
                      title: Text(stop.outletName),
                      subtitle: Text(stop.address),
                      onTap: () {
                        // TODO: navigate to Outlet Detail once features/outlets is built
                      },
                    ),
                  );
                },
              ),
      },
    );
  }
}