import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/extensions/string.dart';

import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/core/session/session_storage.dart';
import 'package:stock_control_app/features/route/presentation/pages/today_route_page.dart';
import 'package:stock_control_app/features/route/presentation/routes.dart';
import 'package:stock_control_app/init.dart';
import 'package:stock_control_app/features/auth/presentation/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeAllDependencies();
  await SessionStorage.restore();
  await ScreenUtil.ensureScreenSize();

  runApp(const ProviderScope(child: StockControlApp()));
}

class StockControlApp extends ConsumerStatefulWidget {
  static late GoRouter router;

  const StockControlApp({super.key});

  @override
  ConsumerState<StockControlApp> createState() => _StockControlAppState();
}

class _StockControlAppState extends ConsumerState<StockControlApp> {
  @override
  void initState() {
    super.initState();
    setupNavigationRoutes();
  }

  void setupNavigationRoutes() {
    // A restored session (SessionStorage.restore, called before runApp)
    // skips straight past login — a field associate shouldn't have to
    // re-enter their PIN every time they open the app.
    final bool hasSession = GetIt.I<SalesSession>().isLoggedIn;

    StockControlApp.router = GoRouter(
      initialLocation: hasSession ? Pages.home.path : Pages.login.path,
      routes: [
        ...authenticationRoutes,
        ...routeFeatureRoutes,
        GoRoute(
          path: Pages.home.path,
          builder: (context, state) => const TodayRoutePage(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, widget) => MaterialApp.router(
        title: 'Stock Control',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        routerConfig: StockControlApp.router,
      ),
      splitScreenMode: true,
      designSize: const Size(437, 805), // matches Bountains' reference design size
      minTextAdapt: true,
    );
  }
}
