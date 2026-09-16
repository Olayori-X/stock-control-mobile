import 'package:flutter_riverpod/legacy.dart';
import 'package:stock_control_app/core/provider/global.dart';
import 'package:stock_control_app/features/sales/domain/repositories/get_my_sales_repository.dart';
export 'package:stock_control_app/core/provider/global.dart';

final StateProvider<AppState> mySalesStateProvider = StateProvider(
  (ref) => AppState.initial,
);

final StateProvider<String> mySalesErrorMessageProvider = StateProvider(
  (ref) => "",
);

final StateProvider<MySalesResult?> mySalesResultProvider = StateProvider(
  (ref) => null,
);