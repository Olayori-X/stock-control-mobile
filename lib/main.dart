import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/database/configuration.dart';
import 'package:stock_control_app/core/extensions/string.dart';

import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/core/session/session_storage.dart';
import 'package:stock_control_app/core/sync/sync_service.dart';
import 'package:stock_control_app/features/dashboard/presentation/pages/dashboard_home_page.dart';
import 'package:stock_control_app/features/outlets/presentation/routes.dart';
import 'package:stock_control_app/features/route/presentation/routes.dart';
import 'package:stock_control_app/features/sales/presentation/routes.dart';
import 'package:stock_control_app/features/scs/invoices/presentation/routes.dart';
import 'package:stock_control_app/features/scs/pickup/presentation/routes.dart';
import 'package:stock_control_app/features/sync_status/presentation/routes.dart';
import 'package:stock_control_app/init.dart';
import 'package:stock_control_app/features/auth/presentation/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeAllDependencies();
  await DatabaseHandler.init(); // must run before SyncService.start()
  await SessionStorage.restore();
  await ScreenUtil.ensureScreenSize();

  GetIt.I<SyncService>().start(); // was: SyncService().start() — must reuse the registered singleton, not a fresh instance

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
        ...outletFeatureRoutes,
        ...salesFeatureRoutes,
        ...syncStatusFeatureRoutes,
        ...pickupRequestFeatureRoutes,
        ...invoicesFeatureRoutes,
        GoRoute(
          path: Pages.home.path,
          builder: (context, state) => const DashboardHomePage(), // was TodayRoutePage
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