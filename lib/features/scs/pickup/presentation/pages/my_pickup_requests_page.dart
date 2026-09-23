import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/provider/my_pickup_requests_provider.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/functions/load_my_pickup_requests.dart';

class MyPickupRequestsPage extends ConsumerStatefulWidget {
  const MyPickupRequestsPage({super.key});

  @override
  ConsumerState<MyPickupRequestsPage> createState() => _MyPickupRequestsPageState();
}

class _MyPickupRequestsPageState extends ConsumerState<MyPickupRequestsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMyPickupRequests(ref));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myPickupRequestsStateProvider);
    final errorMessage = ref.watch(myPickupRequestsErrorMessageProvider);
    final requests = ref.watch(myPickupRequestsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Pickup Requests")),
      body: switch (state) {
        AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
        AppState.error => Center(child: Text(errorMessage)),
        AppState.success => requests.isEmpty
            ? const Center(child: Text("You haven't made any pickup requests yet."))
            : ListView.separated(
                itemCount: requests.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final req = requests[index];
                  final itemCount = req.products.length;
                  return ExpansionTile(
                    title: Text(req.distributorName.isEmpty ? req.distributorId : req.distributorName),
                    subtitle: Text(
                      "$itemCount item${itemCount == 1 ? '' : 's'} · "
                      "${req.createdAt.toLocal().toString().split('.').first}",
                    ),
                    trailing: _statusChip(req.confirmed),
                    children: req.products
                        .map((p) => ListTile(
                              dense: true,
                              title: Text(p.name.isEmpty ? p.sku : p.name),
                              subtitle: Text(p.sku),
                              trailing: Text("×${p.quantity}"),
                            ))
                        .toList(),
                  );
                },
              ),
      },
    );
  }

  Widget _statusChip(bool confirmed) {
    return Chip(
      label: Text(
        confirmed ? "CONFIRMED" : "PENDING",
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: confirmed ? Colors.green : Colors.amber,
      padding: EdgeInsets.zero,
    );
  }
}