import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/sales/presentation/provider/my_sales_provider.dart';
import 'package:stock_control_app/features/sales/presentation/functions/load_my_sales.dart';

class MySalesPage extends ConsumerStatefulWidget {
  const MySalesPage({super.key});

  @override
  ConsumerState<MySalesPage> createState() => _MySalesPageState();
}

class _MySalesPageState extends ConsumerState<MySalesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadMySales(ref));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mySalesStateProvider);
    final result = ref.watch(mySalesResultProvider);
    final errorMessage = ref.watch(mySalesErrorMessageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("My Sales")),
      body: switch (state) {
        AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
        AppState.error => Center(child: Text(errorMessage)),
        AppState.success => result == null || result.sales.isEmpty
            ? const Center(child: Text("No sales recorded in the last 30 days."))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "${result.totalQuantity} units · ₦${result.totalValue.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: result.sales.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final sale = result.sales[index];
                        return ListTile(
                          title: Text("${sale.sku} × ${sale.quantity}"),
                          subtitle: Text(sale.createdAt.toLocal().toString()),
                          trailing: Text("₦${sale.totalValue.toStringAsFixed(2)}"),
                        );
                      },
                    ),
                  ),
                ],
              ),
      },
    );
  }
}