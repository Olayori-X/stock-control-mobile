import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension BuildContextExtension on BuildContext {
  GoRouter get router => GoRouter.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;
  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);
}
