import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_control_app/core/database/schemas/pending_action.dart';

class DatabaseHandler {
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [PendingActionSchema],
      directory: dir.path,
    );
    GetIt.I.registerSingleton<Isar>(isar);
  }

  static Future<void> clearDatabase() async {
    final isar = GetIt.I<Isar>();
    await isar.writeTxn(() => isar.clear());
  }
}