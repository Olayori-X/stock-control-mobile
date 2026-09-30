import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/features/outlets/presentation/provider/my_outlets_provider.dart';
import 'package:stock_control_app/features/outlets/presentation/functions/load_my_outlets.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/get_my_outlets_repository.dart';
import 'package:stock_control_app/features/outlets/domain/usecases/delete_my_outlet_use_case.dart';

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

  Future<void> _refresh() async {
    loadMyOutlets(ref);
    await Future.delayed(const Duration(milliseconds: 400));
  }

  void _removeFromList(String outletId) {
    final current = ref.read(myOutletsListProvider);
    ref.watch(myOutletsListProvider.notifier).state =
        current.where((o) => o.outletId != outletId).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myOutletsStateProvider);
    final errorMessage = ref.watch(myOutletsErrorMessageProvider);
    final outlets = ref.watch(myOutletsListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(title: const Text("My Outlets"), elevation: 0),
      body: switch (state) {
        AppState.initial || AppState.loading => const Center(child: CircularProgressIndicator()),
        AppState.error => _ErrorState(message: errorMessage, onRetry: () => loadMyOutlets(ref)),
        AppState.success => outlets.isEmpty
            ? const _EmptyState()
            : RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: outlets.length,
                  itemBuilder: (context, index) => _OutletCard(
                    outlet: outlets[index],
                    onDeleted: () => _removeFromList(outlets[index].outletId),
                  ),
                ),
              ),
      },
    );
  }
}

class _OutletCard extends StatefulWidget {
  final OutletResult outlet;
  final VoidCallback onDeleted;

  const _OutletCard({required this.outlet, required this.onDeleted});

  @override
  State<_OutletCard> createState() => _OutletCardState();
}

class _OutletCardState extends State<_OutletCard> {
  bool _deleting = false;

  Future<void> _confirmAndDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove this outlet?"),
        content: Text(
          "\"${widget.outlet.name}\" will be deactivated. It won't appear in route planning "
          "or new pickups, but its history is kept.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _deleting = true);

    DeleteMyOutletUseCase useCase = GetIt.I.get();
    final response = await useCase(widget.outlet.outletId);

    if (!mounted) return;

    response.fold(
      (_) => widget.onDeleted(),
      (err) {
        setState(() => _deleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final outlet = widget.outlet;

    return Opacity(
      opacity: _deleting ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF16324F).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.storefront_outlined, color: Color(0xFF16324F), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(outlet.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.2)),
                        if (outlet.outletType.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(outlet.outletType, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ],
                    ),
                  ),
                  _StatusBadge(active: outlet.active),
                  IconButton(
                    icon: _deleting
                        ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    tooltip: "Remove outlet",
                    onPressed: _deleting ? null : _confirmAndDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _InfoRow(icon: Icons.place_outlined, text: outlet.address.isNotEmpty ? outlet.address : "No address on file"),
              if (outlet.area.isNotEmpty || outlet.zone.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.map_outlined, text: [outlet.area, outlet.zone].where((s) => s.isNotEmpty).join(" · ")),
              ],
              if (outlet.routeDay.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.calendar_today_outlined, text: outlet.routeDay),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;
  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF1E8E5A) : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          Text(active ? "Active" : "Inactive", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.3))),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF16324F).withOpacity(0.06), shape: BoxShape.circle),
              child: const Icon(Icons.storefront_outlined, size: 40, color: Color(0xFF16324F)),
            ),
            const SizedBox(height: 16),
            const Text("No outlets yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(
              "Outlets you create while out in the field will show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text("Try again")),
          ],
        ),
      ),
    );
  }
}