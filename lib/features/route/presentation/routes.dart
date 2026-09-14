import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/route/presentation/pages/today_route_page.dart';


final List<GoRoute> routeFeatureRoutes = [
  GoRoute(
    path: Pages.todayRoute.path,
    builder: (context, state) => const TodayRoutePage(),
  ),
];