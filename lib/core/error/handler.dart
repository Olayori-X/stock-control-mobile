import 'package:dio/dio.dart';
import 'error.dart';

StockControlAppError determineDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.badResponse:
      final data = e.response?.data;

      // Guard: if data isn't a Map, we can't key into it
      if (data is! Map<String, dynamic>) {
        return StockControlAppError(message: "There was an error from the server");
      }

      if (e.response?.statusCode == 500) {
        return StockControlAppError(
          message: data["message"] ?? "There was an error from the server",
        );
      } else {
        final errorData = data["error"];

        if (errorData is Map<String, dynamic>) {
          List<String> errorMessages = [];
          errorData.forEach((key, value) {
            if (value is List) {
              errorMessages.addAll(value.map((msg) => msg.toString()));
            }
          });
          return StockControlAppError(message: errorMessages.join(" "));
        } else {
          return StockControlAppError(
            message: data["message"] ?? "There was an error from the server",
          );
        }
      }

    case DioExceptionType.connectionError:
      return StockControlAppError(
        message: "Unable to connect. Please check your internet connection",
      );
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return StockControlAppError(message: "Request timeout. Please try again");
    case DioExceptionType.badCertificate:
      return StockControlAppError(message: "Bad certificate.");
    case DioExceptionType.cancel:
      return StockControlAppError(message: "Request canceled. Please try again");
    case DioExceptionType.unknown:
      return StockControlAppError(
        message: "An unknown error occurred. Please try again.",
      );
    case DioExceptionType.transformTimeout:
      // TODO: Handle this case.
      throw UnimplementedError();
  }
}