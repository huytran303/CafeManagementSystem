import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/format.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../models/shift.dart';
import '../application/my_shift_controller.dart';
import '../application/staff_providers.dart';
import '../application/staff_rules.dart';

/// S07 — Cashier / Barista check in and out of a shift (FR-STAFF-04).
class MyShiftScreen extends ConsumerWidget {
  const MyShiftScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openShift = ref.watch(openShiftProvider);
    final isBusy = ref.watch(myShiftControllerProvider).isLoading;

    ref.listen(myShiftControllerProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${next.error}')));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Ca làm của tôi')),
      body: openShift.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(openShiftProvider),
        ),
        data: (shift) => _ShiftBody(
          shift: shift,
          isBusy: isBusy,
          onCheckIn: () =>
              ref.read(myShiftControllerProvider.notifier).checkIn(),
          onCheckOut: () =>
              ref.read(myShiftControllerProvider.notifier).checkOut(),
        ),
      ),
    );
  }
}

class _ShiftBody extends StatelessWidget {
  const _ShiftBody({
    required this.shift,
    required this.isBusy,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  final Shift? shift;
  final bool isBusy;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  @override
  Widget build(BuildContext context) {
    final shift = this.shift;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (shift == null)
            const Text('Bạn chưa vào ca')
          else ...[
            Text('Vào ca lúc ${formatTime(shift.checkIn)}'),
            Text('Đã làm ${formatDuration(shiftDuration(shift))}'),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: isBusy ? null : (shift == null ? onCheckIn : onCheckOut),
            icon: Icon(shift == null ? Icons.login : Icons.logout),
            label: Text(shift == null ? 'Check-in' : 'Check-out'),
          ),
        ],
      ),
    );
  }
}
