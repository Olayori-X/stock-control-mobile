extension DateTimeExtensions on DateTime {
  DateTime get startOfWeek =>
      DateTime(year, month, day - weekday + 1);

  DateTime get endOfWeek =>
      DateTime(year, month, day + (7 - weekday));

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth => DateTime(year, month + 1, 0);
}