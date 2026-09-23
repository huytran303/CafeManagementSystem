// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Shift _$ShiftFromJson(Map<String, dynamic> json) => _Shift(
  id: json['id'] as String,
  userId: json['userId'] as String,
  checkIn: const TimestampConverter().fromJson(json['checkIn'] as Timestamp),
  checkOut: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['checkOut'],
    const TimestampConverter().fromJson,
  ),
);

Map<String, dynamic> _$ShiftToJson(_Shift instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'checkIn': const TimestampConverter().toJson(instance.checkIn),
  'checkOut': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.checkOut,
    const TimestampConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
