import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/get_products_repository.dart';

class GetProductsUseCase implements UseCase<List<ProductResult>, NoParams> {
  final GetProductsRepository repository;

  const GetProductsUseCase({required this.repository});

  @override
  Future<Either<List<ProductResult>, StockControlAppError>> call(NoParams params) async {
    return await repository.getProducts();
  }
}