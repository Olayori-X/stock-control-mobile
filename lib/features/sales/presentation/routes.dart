import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/sales/presentation/pages/sales_capture_page.dart';


final List<GoRoute> salesFeatureRoutes = [
  GoRoute(
    path: Pages.salesCapture.path,
    builder: (context, state) {
      final args = state.extra as SalesCaptureArgs;
      return SalesCapturePage(outletId: args.outletId, outletName: args.outletName, routeDay: args.routeDay);
    },
  ),
];


class SalesCaptureArgs {
  final String outletId;
  final String outletName;
  final String routeDay;

  const SalesCaptureArgs({required this.outletId, required this.outletName, required this.routeDay});
}