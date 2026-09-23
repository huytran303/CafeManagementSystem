// Timestamp is used by the generated shift.g.dart, which is a `part` of this file.
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/utils/timestamp_converter.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

/// Firestore: shifts/{shiftId}. See docs/product-brief.md §9.2.
@freezed
abstract class Shift with _$Shift {
  const factory Shift({
    required String id,
    required String userId,
    @TimestampConverter() required DateTime checkIn,
    @TimestampConverter() DateTime? checkOut,
  }) = _Shift;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}
