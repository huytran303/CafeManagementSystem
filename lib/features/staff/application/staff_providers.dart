import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/shift.dart';
import '../../auth/application/auth_providers.dart';
import '../data/shift_repository.dart';

final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => ShiftRepository(FirebaseFirestore.instance),
);

/// Open shift of the signed-in user. Emits null when none or signed out.
final openShiftProvider = StreamProvider.autoDispose<Shift?>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(shiftRepositoryProvider).watchOpenShift(uid);
});
