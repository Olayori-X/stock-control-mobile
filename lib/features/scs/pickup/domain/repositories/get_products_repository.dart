import 'package:stock_control_app/core/error/error.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class GetProductsRepository {
  Future<Either<List<ProductResult>, StockControlAppError>> getProducts();
}

class ProductResult {
  final String sku;
  final String name;

  const ProductResult({required this.sku, required this.name});
}