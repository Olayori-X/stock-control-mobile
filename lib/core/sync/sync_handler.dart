// A feature that wants its failed-due-to-connectivity actions queued and
// retried later implements this and registers it in GetIt, keyed by
// PendingActionType via instanceName. core/sync never imports feature
// code directly — it only knows this interface.
abstract interface class SyncHandler {
  // Re-executes the action from its persisted JSON payload. Returns true
  // on success (action is marked synced), false on a genuine failure that
  // should be retried again later. Should NOT throw for expected failure
  // cases — only for truly unexpected ones.
  Future<bool> execute(String payloadJson, String? transactionId);
}