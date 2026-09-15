import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/network/session.dart';
import 'package:stock_control_app/core/session/session_storage.dart';
import 'package:stock_control_app/core/navigation/pages.dart';
import 'package:stock_control_app/core/extensions/string.dart';
import 'package:stock_control_app/main.dart' show StockControlApp;

// Reacts to a 401 from ANY request, anywhere in the app — clears the
// stale session and forces navigation back to login. Complements
// determineDioError, which only produces a message for the screen that
// made the failing call; this is the one place that actually DOES
// something in response to "the session is no longer valid."
class SessionExpiryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _handleSessionExpired();
    }
    handler.next(err);
  }

  Future<void> _handleSessionExpired() async {
    await SessionStorage.clear();
    GetIt.I<SalesSession>().clear();
    StockControlApp.router.go(Pages.login.path);
  }
}