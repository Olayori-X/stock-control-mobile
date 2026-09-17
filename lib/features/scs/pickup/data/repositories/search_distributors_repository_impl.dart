import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/features/scs/pickup/data/datasources/pickup_request_datasource.dart';
import 'package:stock_control_app/features/scs/pickup/domain/repositories/search_distributors_repository.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:fpdart/fpdart.dart';

class SearchDistributorsRepositoryImpl implements SearchDistributorsRepository {
  final PickupRequestDataSource dataSource;

  SearchDistributorsRepositoryImpl({required this.dataSource});

  @override
  Future<Either<List<DistributorResult>, StockControlAppError>> search(String query) async {
    try {
      final response = await dataSource.searchDistributors(query);
      return Either.left(
        response.users
            .map((u) => DistributorResult(
                  userId: u.userId,
                  name: u.name,
                  email: u.email,
                  phone: u.phone,
                ))
            .toList(),
      );
    } on DioException catch (e) {
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}