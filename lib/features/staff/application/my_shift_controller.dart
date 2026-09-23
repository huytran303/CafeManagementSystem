import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_providers.dart';
import 'staff_providers.dart';
import 'staff_rules.dart';

/// Mutations for S07 "My shift". State = loading/error of the last action.
class MyShiftController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> checkIn() => _run(() async {
    final uid = ref.read(currentUidProvider);
    if (uid == null) throw StateError('Bạn chưa đăng nhập');
    final open = ref.read(openShiftProvider).value;
    if (!canCheckIn(open)) {
      throw StateError('Bạn đang trong ca, hãy check-out trước');
    }
    await ref.read(shiftRepositoryProvider).checkIn(uid);
  });

  Future<bool> checkOut() => _run(() async {
    final open = ref.read(openShiftProvider).value;
    if (open == null) throw StateError('Bạn chưa check-in');
    await ref.read(shiftRepositoryProvider).checkOut(open.id);
  });

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    return !state.hasError;
  }
}

final myShiftControllerProvider =
    AsyncNotifierProvider.autoDispose<MyShiftController, void>(
      MyShiftController.new,
    );
