import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_control_app/features/scs/invoices/domain/repositories/invoices_repository.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/provider/invoices_provider.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/functions/load_invoices.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/functions/load_receipts.dart';

class InvoicesPage extends ConsumerStatefulWidget {
  const InvoicesPage({super.key});

  @override
  ConsumerState<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends ConsumerState<InvoicesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMyInvoices(ref);
      loadMyReceipts(ref);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Control"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Invoices"),
            Tab(text: "Outstanding"),
            Tab(text: "Receipts"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _InvoicesTab(filterOutstandingOnly: false),
          _InvoicesTab(filterOutstandingOnly: true),
          _ReceiptsTab(),
        ],
      ),
    );
  }
}

class _InvoicesTab extends ConsumerWidget {
  final bool filterOutstandingOnly;

  const _InvoicesTab({required this.filterOutstandingOnly});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoicesStateProvider);
    final errorMessage = ref.watch(invoicesErrorMessageProvider);
    final all = ref.watch(invoicesListProvider);
    final invoices = filterOutstandingOnly
        ? all.where((i) => i.outstandingValue > 0).toList()
        : all;

    return switch (state) {
      AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
      AppState.error => Center(child: Text(errorMessage)),
      AppState.success => invoices.isEmpty
          ? Center(child: Text(filterOutstandingOnly ? "Nothing outstanding." : "No invoices yet."))
          : ListView.separated(
              itemCount: invoices.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final inv = invoices[index];
                return ListTile(
                  title: Text(inv.invoiceId),
                  subtitle: Text(
                    "Total: ₦${inv.totalValue.toStringAsFixed(2)} · "
                    "Outstanding: ₦${inv.outstandingValue.toStringAsFixed(2)}\n"
                    "Due ${inv.dueAt.toLocal().toString().split(' ').first}",
                  ),
                  isThreeLine: true,
                  trailing: _statusChip(inv.status),
                );
              },
            ),
    };
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      "paid" => Colors.green,
      "overdue" => Colors.red,
      _ => Colors.amber,
    };
    return Chip(
      label: Text(status.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.white)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }
}

class _ReceiptsTab extends ConsumerWidget {
  const _ReceiptsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(receiptsStateProvider);
    final errorMessage = ref.watch(receiptsErrorMessageProvider);
    final receipts = ref.watch(receiptsListProvider);

    return switch (state) {
      AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
      AppState.error => Center(child: Text(errorMessage)),
      AppState.success => receipts.isEmpty
          ? const Center(child: Text("No payments recorded yet."))
          : ListView.separated(
              itemCount: receipts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final r = receipts[index];
                return ListTile(
                  title: Text(r.receiptId),
                  subtitle: Text("Invoice: ${r.invoiceId}\nPaid ${r.paidAt.toLocal()}"),
                  isThreeLine: true,
                  trailing: Text("₦${r.amountPaid.toStringAsFixed(2)}"),
                );
              },
            ),
    };
  }
}