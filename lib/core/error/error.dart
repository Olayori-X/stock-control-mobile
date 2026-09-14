class StockControlAppError extends Error {
  final String message;

  StockControlAppError({
    required this.message,
  });
}
