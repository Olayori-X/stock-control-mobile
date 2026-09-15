import 'dart:convert';
import 'package:stock_control_app/core/error/error.dart';
import 'package:stock_control_app/core/error/handler.dart';
import 'package:stock_control_app/core/sync/pending_action_type.dart';
import 'package:stock_control_app/core/sync/sync_queue_repository.dart';
import 'package:stock_control_app/features/outlets/data/datasources/confirm_outlet_visit_datasource.dart';
import 'package:stock_control_app/features/outlets/data/models/outlet_visit_model.dart';
import 'package:stock_control_app/features/outlets/domain/repositories/confirm_outlet_visit_repository.dart';
import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:fpdart/fpdart.dart';

class ConfirmOutletVisitRepositoryImpl implements ConfirmOutletVisitRepository {
  final ConfirmOutletVisitDataSource dataSource;
  final SyncQueueRepository syncQueue;

  ConfirmOutletVisitRepositoryImpl({
    required this.dataSource,
    required this.syncQueue,
  });

  // Only these DioExceptionTypes represent "we genuinely have no
  // connectivity right now" — everything else (bad response, bad
  // certificate, cancel) is a real error that retrying blindly wouldn't
  // fix, so those still surface as errors rather than being queued.
  static const _connectivityFailureTypes = {
    DioExceptionType.connectionError,
    DioExceptionType.connectionTimeout,
    DioExceptionType.sendTimeout,
    DioExceptionType.receiveTimeout,
  };

  @override
  Future<Either<ConfirmVisitResult, StockControlAppError>> confirmVisit(
    ConfirmVisitParams params,
  ) async {
    final payload = ConfirmVisitPayload(
      outletId: params.outletId,
      routeDay: params.routeDay,
      latitude: params.latitude,
      longitude: params.longitude,
    );

    try {
      final response = await dataSource.confirmVisit(payload);
      return Either.left(
        ConfirmVisitResult(
          queued: false,
          distanceM: response.distanceM,
          geofenceStatus: response.geofenceStatus,
        ),
      );
    } on DioException catch (e) {
      if (_connectivityFailureTypes.contains(e.type)) {
        await syncQueue.enqueue(
          type: PendingActionType.outletVisit,
          payloadJson: jsonEncode(params.toJson()),
          capturedAt: DateTime.now(),
        );
        return Either.left(const ConfirmVisitResult(queued: true));
      }
      return Either.right(determineDioError(e));
    } catch (e) {
      return Either.right(StockControlAppError(message: "Error: $e"));
    }
  }
}