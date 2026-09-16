import 'dart:convert';
import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/core/sync/pending_action_type.dart';
import 'package:stock_control_app/core/sync/sync_queue_repository.dart';
import 'package:stock_control_app/features/sales/data/datasources/submit_sale_datasource.dart';
import 'package:stock_control_app/features/sales/data/models/sale_model.dart';
import 'package:stock_control_app/features/sales/domain/repositories/submit_sale_repository.dart';
import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:fpdart/fpdart.dart';

class SubmitSaleRepositoryImpl implements SubmitSaleRepository {
  final SubmitSaleDataSource dataSource;
  final SyncQueueRepository syncQueue;

  SubmitSaleRepositoryImpl({
    required this.dataSource,
    required this.syncQueue,
  });

  static const _connectivityFailureTypes = {
    DioExceptionType.connectionError,
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  };

  @override
  Future<Either<SubmitSaleResult, StockControlAppError>> submitSale(
    SubmitSaleParams params,
  ) async {
    final payload = SubmitSalePayload(
      transactionId: params.transactionId,
      outletId: params.outletId,
      routeDay: params.routeDay,
      sku: params.sku,
      quantity: params.quantity,
      latitude: params.latitude,
      longitude: params.longitude,
    );

    try {
      final response = await dataSource.submitSale(payload);
      return Either.left(
        SubmitSaleResult(
          queued: false,
          blockReason: response.blockReason,
          message: response.message,
          totalValue: response.totalValue,
        ),
      );
    } on DioException catch (e) {
      if (_connectivityFailureTypes.contains(e.type)) {
        // transactionId was already generated at capture time by the
        // caller (see confirm_visit-equivalent presentation function
        // below) — enqueue carries it through so a later sync retry uses
        // the SAME id, guaranteeing the backend's idempotency check
        // actually prevents a duplicate.
        await syncQueue.enqueue(
          type: PendingActionType.sale,
          payloadJson: jsonEncode(params.toJson()),
          transactionId: params.transactionId,
          capturedAt: DateTime.now(),
        );
        return Either.left(const SubmitSaleResult(queued: true));
      }
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}