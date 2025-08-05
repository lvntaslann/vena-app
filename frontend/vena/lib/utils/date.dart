import 'package:intl/intl.dart';

class Date {
static String formatDate(String dateStr) {
  try {
    final date = DateTime.parse(dateStr);
    final formatter = DateFormat('d MMMM yyyy', 'tr_TR');
    return formatter.format(date);
  } catch (e) {
    return dateStr;
  }
}
}