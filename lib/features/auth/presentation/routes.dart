import 'package:go_router/go_router.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/features/auth/presentation/pages/login_page.dart';

final List<GoRoute> authenticationRoutes = [
  GoRoute(
    path: Pages.login.path,
    builder: (context, state) => const LoginPage(),
  ),
];