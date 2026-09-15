import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:stock_control_app/core/network/session.dart';

// Attaches the auth headers the backend's middleware.Authorization expects
// on every outgoing request: `userid` and `Authorization` (the raw session
// token — no Bearer scheme, matching the Go middleware's exact contract).
//
// Safe to apply globally, including to public routes like /auth/pinlogin —
// before login, SalesSession's fields are just empty strings, and the
// backend's public routes don't inspect these headers at all, so there's
// nothing to skip or special-case here.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final session = GetIt.I<SalesSession>();

    options.headers["userid"] = session.userId;
    options.headers["Authorization"] = session.token;

    handler.next(options);
  }
}