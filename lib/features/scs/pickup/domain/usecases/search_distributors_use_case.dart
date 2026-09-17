import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/search_distributors_repository.dart';

class SearchDistributorsUseCase implements UseCase<List<DistributorResult>, String> {
  final SearchDistributorsRepository repository;

  const SearchDistributorsUseCase({required this.repository});

  @override
  Future<Either<List<DistributorResult>, StockControlAppError>> call(String query) async {
    return await repository.search(query);
  }
}