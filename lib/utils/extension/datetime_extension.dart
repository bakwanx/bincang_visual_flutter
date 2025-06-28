import 'package:intl/intl.dart';

extension HalmallDateFormatter on DateTime? {
  String asString(String format, [String? locale]) {
    return DateFormat(format, locale).format(this ?? DateTime.now());
  }
}