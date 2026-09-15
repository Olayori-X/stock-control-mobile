import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/outlets/presentation/pages/outlet_detail_page.dart';


final List<GoRoute> outletFeatureRoutes = [
  GoRoute(
    path: Pages.outletDetail.path,
    builder: (context, state) => const OutletDetailPage(stop: RoutePlanStop, routeDay: '',),
  ),
];