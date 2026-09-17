import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/pages/pickup_request_page.dart';

final List<GoRoute> pickupRequestFeatureRoutes = [
  GoRoute(
    path: Pages.pickupRequest.path,
    builder: (context, state) => const PickupRequestPage(),
  ),
];