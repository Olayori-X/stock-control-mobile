import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/core/session/session_storage.dart';
import 'package:stock_control_app/features/route/presentation/pages/today_route_page.dart';
import 'package:stock_control_app/features/sales/presentation/pages/my_sales_page.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/pages/pickup_request_page.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/pages/invoices_page.dart';
import 'package:stock_control_app/features/outlets/presentation/pages/create_outlet_page.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Control"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: "Sync status",
            onPressed: () => context.push(Pages.syncStatus.path),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Log out",
            onPressed: () async {
              await SessionStorage.clear();
              GetIt.I<SalesSession>().clear();
              if (context.mounted) context.go(Pages.login.path);
            },
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _DashboardTile(
            icon: Icons.route,
            label: "Today's Route",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TodayRoutePage()),
            ),
          ),
          _DashboardTile(
            icon: Icons.point_of_sale,
            label: "My Sales",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MySalesPage()),
            ),
          ),
          _DashboardTile(
            icon: Icons.local_shipping,
            label: "Pickup Request",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PickupRequestPage()),
            ),
          ),
          _DashboardTile(
            icon: Icons.receipt_long,
            label: "Stock Control",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const InvoicesPage()),
            ),
          ),
          _DashboardTile(
            icon: Icons.add_business,
            label: "Add Outlet",
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateOutletPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}