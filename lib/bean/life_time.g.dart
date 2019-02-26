// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeTimeBean _$LifeTimeBeanFromJson(Map<String, dynamic> json) {
  return LifeTimeBean(json['type'] as int,
      json['millisecondsSinceEpoch'] as int, json['detail'] as String);
}

Map<String, dynamic> _$LifeTimeBeanToJson(LifeTimeBean instance) =>
    <String, dynamic>{
      'type': instance.type,
      'millisecondsSinceEpoch': instance.millisecondsSinceEpoch,
      'detail': instance.detail
    };
