import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/outlets/presentation/pages/create_outlet_page.dart';
import 'package:stock_control_app/features/outlets/presentation/pages/outlet_detail_page.dart';
import 'package:stock_control_app/features/route/domain/repositories/get_route_plan_repository.dart';

final List<GoRoute> outletFeatureRoutes = [
  GoRoute(
    path: Pages.outletDetail.path,
    builder: (context, state) {
      final args = state.extra as OutletDetailArgs;
      return OutletDetailPage(stop: args.stop, routeDay: args.routeDay);
    },
  ),

  GoRoute(
    path: Pages.createOutlet.path,
    builder: (context, state) => const CreateOutletPage(),
  ),
];

class OutletDetailArgs {
  final RoutePlanStop stop;
  final String routeDay;

  const OutletDetailArgs({required this.stop, required this.routeDay});
}