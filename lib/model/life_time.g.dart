// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'life_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LifeTimeBean _$LifeTimeBeanFromJson(Map<String, dynamic> json) {
  return LifeTimeBean(
      type: json['type'] as int,
      millisecondsSinceEpoch: json['millisecondsSinceEpoch'] as int,
      title: json['title'] as String,
      detail: json['detail'] as String)
    ..lastUpdateMilliseconds = json['lastUpdateMilliseconds'] as int;
}

Map<String, dynamic> _$LifeTimeBeanToJson(LifeTimeBean instance) =>
    <String, dynamic>{
      'type': instance.type,
      'millisecondsSinceEpoch': instance.millisecondsSinceEpoch,
      'lastUpdateMilliseconds': instance.lastUpdateMilliseconds,
      'title': instance.title,
      'detail': instance.detail
    };
