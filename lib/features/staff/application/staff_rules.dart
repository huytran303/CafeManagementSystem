import '../../../models/shift.dart';

/// BR-STAFF-01: a staff member cannot check in twice without checking out.
bool canCheckIn(Shift? openShift) => openShift == null;

/// Length of a shift; for an open shift, measured up to [now].
Duration shiftDuration(Shift shift, {DateTime? now}) =>
    (shift.checkOut ?? now ?? DateTime.now()).difference(shift.checkIn);
