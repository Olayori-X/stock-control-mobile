import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/sales/presentation/provider/sales_capture_provider.dart';
import 'package:stock_control_app/features/sales/presentation/functions/submit_sale.dart';

class SalesCapturePage extends ConsumerStatefulWidget {
  final String outletId;
  final String outletName;
  final String routeDay;

  const SalesCapturePage({
    super.key,
    required this.outletId,
    required this.outletName,
    required this.routeDay,
  });

  @override
  ConsumerState<SalesCapturePage> createState() => _SalesCapturePageState();
}

class _SalesCapturePageState extends ConsumerState<SalesCapturePage> {
  final _skuController = TextEditingController();
  final _quantityController = TextEditingController(text: "1");

  @override
  void dispose() {
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(submitSaleStateProvider);
    final result = ref.watch(submitSaleResultProvider);
    final errorMessage = ref.watch(submitSaleErrorMessageProvider);
    final isLoading = state == AppState.loading;

    return Scaffold(
      appBar: AppBar(title: Text("Sale at ${widget.outletName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _skuController,
              decoration: const InputDecoration(labelText: "SKU"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Quantity"),
            ),
            const SizedBox(height: 20),
            if (state == AppState.success && result != null) _buildResultCard(result),
            if (state == AppState.error) ...[
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: isLoading ? null : _handleSubmit,
              child: isLoading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Submit sale"),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    final sku = _skuController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (sku.isEmpty || quantity <= 0) return;

    submitSale(ref, widget.outletId, widget.routeDay, sku, quantity);
  }

  Widget _buildResultCard(result) {
    if (result.queued) {
      return const Card(
        color: Colors.amber,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Text("No connection — sale saved and will sync automatically."),
        ),
      );
    }
    if (result.blockReason != null) {
      return Card(
        color: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(result.message ?? "This sale could not be completed."),
        ),
      );
    }
    return Card(
      color: Colors.green.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text("Sale recorded — ₦${result.totalValue?.toStringAsFixed(2) ?? ''}"),
      ),
    );
  }
}