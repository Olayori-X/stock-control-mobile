import 'package:dio/dio.dart';
export 'package:dio/dio.dart';

const String baseUrl = "https://bountains-backend.onrender.com/api";
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
);
