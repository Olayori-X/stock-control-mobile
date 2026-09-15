import 'package:dio/dio.dart';
import 'package:stock_control_app/core/network/auth_interceptor.dart';
import 'package:stock_control_app/core/network/session_expiry_interceptor.dart';
export 'package:dio/dio.dart';

const String baseUrl = "https://stockcontrol-6oel.onrender.com";
// const String baseUrl = "https://loyal-moth-ideally.ngrok-free.app/api";

// const String baseLink = "https://mansapay.net.ng/bountains/";
// const String baseLink = "https://loyal-moth-ideally.ngrok-free.app/";

final Dio dio = Dio(
  BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ),
)..interceptors.addAll([
    AuthInterceptor(),
    SessionExpiryInterceptor(),
  ]);
