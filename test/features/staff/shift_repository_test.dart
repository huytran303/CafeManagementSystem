import 'package:cafe_shop_management_system/features/staff/data/shift_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ShiftRepository repo;

  setUp(() => repo = ShiftRepository(FakeFirebaseFirestore()));

  test('checkIn creates an open shift, checkOut closes it', () async {
    expect(await repo.watchOpenShift('u1').first, isNull);

    await repo.checkIn('u1');
    final open = await repo.watchOpenShift('u1').first;
    expect(open, isNotNull);
    expect(open!.userId, 'u1');
    expect(open.checkOut, isNull);

    await repo.checkOut(open.id);
    expect(await repo.watchOpenShift('u1').first, isNull);
  });

  test('open shift is scoped per user', () async {
    await repo.checkIn('u1');
    expect(await repo.watchOpenShift('u2').first, isNull);
  });
}
