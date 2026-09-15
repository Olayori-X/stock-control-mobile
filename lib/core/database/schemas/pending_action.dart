import 'package:isar/isar.dart';

part 'pending_action.g.dart';

@collection
class PendingAction {
  Id id = Isar.autoIncrement;

  // Stored as the enum's .name — Isar doesn't need a custom enum mapper
  // for simple string storage, and this keeps the schema stable even if
  // enum ordering changes later (unlike @Enumerated(EnumType.ordinal)).
  late String type;
  late String payloadJson;
  late String status; // pending | syncing | synced | failed

  String? transactionId; // used by actions that need idempotency (e.g. sales)
  late DateTime capturedAt; // when the GPS/action was actually captured
  int retryCount = 0;
  String? lastError;
}