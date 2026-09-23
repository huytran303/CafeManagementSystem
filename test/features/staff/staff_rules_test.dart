import 'package:cafe_shop_management_system/features/staff/application/staff_rules.dart';
import 'package:cafe_shop_management_system/models/shift.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final start = DateTime(2026, 9, 23, 8);
  final open = Shift(id: 's1', userId: 'u1', checkIn: start);

  group('BR-STAFF-01 canCheckIn', () {
    test('allowed when no open shift', () {
      expect(canCheckIn(null), isTrue);
    });

    test('blocked while a shift is open', () {
      expect(canCheckIn(open), isFalse);
    });
  });

  group('shiftDuration', () {
    test('closed shift uses checkOut', () {
      final closed = open.copyWith(
        checkOut: start.add(const Duration(hours: 8)),
      );
      expect(shiftDuration(closed), const Duration(hours: 8));
    });

    test('open shift measures up to now', () {
      final now = start.add(const Duration(minutes: 90));
      expect(shiftDuration(open, now: now), const Duration(minutes: 90));
    });
  });
}
