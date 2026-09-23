import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/my_outlets_provider.dart';
import 'package:stock_control_app/features/outlets/presentation/functions/load_my_outlets.dart';

class MyOutletsPage extends ConsumerStatefulWidget {
  const MyOutletsPage({super.key});

  @override
  ConsumerState<MyOutletsPage> createState() => _MyOutletsPageState();
}

class _MyOutletsPageState extends ConsumerState<MyOutletsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMyOutlets(ref));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myOutletsStateProvider);
    final errorMessage = ref.watch(myOutletsErrorMessageProvider);
    final outlets = ref.watch(myOutletsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Outlets")),
      body: switch (state) {
        AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
        AppState.error => Center(child: Text(errorMessage)),
        AppState.success => outlets.isEmpty
            ? const Center(child: Text("You haven't created any outlets yet."))
            : ListView.separated(
                itemCount: outlets.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final outlet = outlets[index];
                  return ListTile(
                    title: Text(outlet.name),
                    subtitle: Text(
                      "${outlet.address.isEmpty ? 'No address' : outlet.address}\n"
                      "${outlet.area.isEmpty ? 'No area' : outlet.area}"
                      "${outlet.routeDay.isNotEmpty ? ' · ${outlet.routeDay}' : ''}",
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      Icons.circle,
                      size: 10,
                      color: outlet.active ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
      },
    );
  }
}