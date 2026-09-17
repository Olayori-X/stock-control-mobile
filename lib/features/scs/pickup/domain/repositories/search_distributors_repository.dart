import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SearchDistributorsRepository {
  Future<Either<List<DistributorResult>, StockControlAppError>> search(
    String query,
  );
}

class DistributorResult {
  final String userId;
  final String name;
  final String email;
  final String phone;

  const DistributorResult({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
  });
}