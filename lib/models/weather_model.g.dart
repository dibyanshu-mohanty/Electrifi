// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      tempPercent: (json['tempPercent'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      humidityPercent: (json['humidityPercent'] as num).toDouble(),
      epoch: json['epoch'] as int,
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'tempPercent': instance.tempPercent,
      'temperature': instance.temperature,
      'humidityPercent': instance.humidityPercent,
      'humidity': instance.humidity,
      'epoch': instance.epoch,
    };
