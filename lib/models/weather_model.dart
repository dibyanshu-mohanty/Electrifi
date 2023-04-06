

import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class Weather{
  final double tempPercent;
  final double temperature;
  final double humidityPercent;
  final double humidity;
  final int epoch;

  Weather({
    required this.tempPercent,
    required this.temperature,
    required this.humidity,
    required this.humidityPercent,
    required this.epoch,
  });

  factory Weather.fromJson(Map<String,dynamic> json) => _$WeatherFromJson(json);
  Map<String,dynamic> toJson() => _$WeatherToJson(this);
}