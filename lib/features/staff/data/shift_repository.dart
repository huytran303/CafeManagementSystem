import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/shift.dart';

/// I/O only. Business rules (BR-STAFF-01) live in staff_rules.dart.
class ShiftRepository {
  ShiftRepository(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _shifts =>
      _db.collection('shifts');

  /// The user's shift that has no checkOut yet, or null.
  Stream<Shift?> watchOpenShift(String userId) => _shifts
      .where('userId', isEqualTo: userId)
      .where('checkOut', isNull: true)
      .limit(1)
      .snapshots()
      .map((snap) => snap.docs.isEmpty ? null : _fromDoc(snap.docs.first));

  // ponytail: client clock, not FieldValue.serverTimestamp(). Server timestamps
  // read back as null on the local snapshot before the write is acked, which
  // would break Shift.fromJson. Switch when we need trustworthy times.
  Future<void> checkIn(String userId) => _shifts.add({
    'userId': userId,
    'checkIn': Timestamp.now(),
    'checkOut': null,
  });

  Future<void> checkOut(String shiftId) =>
      _shifts.doc(shiftId).update({'checkOut': Timestamp.now()});

  Shift _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Shift.fromJson({...doc.data()!, 'id': doc.id});
}
