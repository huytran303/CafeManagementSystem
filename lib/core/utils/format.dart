import 'package:intl/intl.dart';

final _vnd = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);
final _dateTime = DateFormat('dd/MM/yyyy HH:mm');
final _time = DateFormat('HH:mm');

String formatVnd(int amount) => _vnd.format(amount);
String formatDateTime(DateTime d) => _dateTime.format(d);
String formatTime(DateTime d) => _time.format(d);

/// "2h 05m" style, for shift length.
String formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  return '${h}h ${m}m';
}
