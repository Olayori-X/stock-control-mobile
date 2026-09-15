import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/outlet_visit_provider.dart';
import 'package:stock_control_app/features/outlets/presentation/functions/confirm_visit.dart';

class OutletDetailPage extends ConsumerWidget {
  final RoutePlanStop stop;
  final String routeDay;

  const OutletDetailPage({super.key, required this.stop, required this.routeDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(confirmVisitStateProvider);
    final result = ref.watch(confirmVisitResultProvider);
    final errorMessage = ref.watch(confirmVisitErrorMessageProvider);
    final isLoading = state == AppState.loading;

    return Scaffold(
      appBar: AppBar(title: Text(stop.outletName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stop.address, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            if (state == AppState.success && result != null) ...[
              if (result.queued)
                const Card(
                  color: Colors.amber,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("No connection — visit saved and will sync automatically."),
                  ),
                )
              else
                Card(
                  color: result.geofenceStatus == "PASS" ? Colors.green.shade100 : Colors.red.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      result.geofenceStatus == "PASS"
                          ? "Visit confirmed — you're within range."
                          : "You're ${result.distanceM?.toStringAsFixed(0)}m from this outlet — too far to confirm a visit.",
                    ),
                  ),
                ),
              const SizedBox(height: 16),
            ],
            if (state == AppState.error) ...[
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: isLoading ? null : () => confirmOutletVisit(ref, stop.outletId, routeDay),
              child: isLoading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Confirm visit"),
            ),
          ],
        ),
      ),
    );
  }
}