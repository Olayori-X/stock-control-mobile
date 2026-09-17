import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/pages/invoices_page.dart';

final List<GoRoute> invoicesFeatureRoutes = [
  GoRoute(
    path: Pages.invoices.path,
    builder: (context, state) => const InvoicesPage(),
  ),
];