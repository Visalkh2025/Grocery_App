import 'package:intl/intl.dart';

final rielFormat = NumberFormat.currency(
  locale: 'km_KH',
  symbol: '៛',
  decimalDigits: 0, // riel normally has no cents
);
