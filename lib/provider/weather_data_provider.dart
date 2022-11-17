import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class WeatherData {
  final double tempPercent;
  final double temperature;
  final double humidityPercent;
  final double humidity;
  final double pressurePercent;
  final double pressure;
  final int epoch;

  WeatherData({
    required this.temperature,
    required this.tempPercent,
    required this.humidity,
    required this.humidityPercent,
    required this.pressure,
    required this.pressurePercent,
    required this.epoch,
  });
}

class WeatherDataProvider with ChangeNotifier {
  WeatherData? _weather;

  WeatherData? get weather {
    return _weather;
  }

  int _tempMax = 500;
  int _tempMin = 0;

  int _humidMax = 100;
  int _humidMin = 0;

  int _pressureMax = 1000;
  int _pressureMin = 0;

  int get tempMax{
    return _tempMax;
  }
  int get tempMin{
    return _tempMin;
  }
  int get humidMax{
    return _humidMax;
  }
  int get humidMin{
    return _humidMin;
  }
  int get pressureMax{
    return _pressureMax;
  }
  int get pressureMin{
    return _pressureMin;
  }



  double calculateTempPercent(double input) {
    return double.parse((input / 500).toStringAsFixed(1));
  }

  double calculateHumidityPercent(double input) {
    return double.parse((input / 100).toStringAsFixed(1));
  }

  double calculatePressurePercent(double input) {
    return double.parse((input / 1000).toStringAsFixed(1));
  }

  Future<void> fetchWeatherData() async {
    await FirebaseDatabase.instance.ref().once().then((event) {
      final response = event.snapshot.value as Map;
      Map tempo = response["System"]["Config"]["System1"]["Weather"];
      final data = tempo[tempo.keys.toList().last];
      double temperature = data["temprature"];
      final tempPercent =
          calculateTempPercent(data["temprature"]);
      double humidity = data["humidity"];
      final humidityPercent =
          calculateHumidityPercent(data["humidity"]);
      double pressure =data["pressure"];
      final pressurePercent =
          calculatePressurePercent(data["pressure"]);
      final epoch = data["epochtime"];
      _weather = WeatherData(
          temperature: temperature,
          tempPercent: tempPercent,
          humidity: humidity,
          humidityPercent: humidityPercent,
          pressure: pressure,
          pressurePercent: pressurePercent,
          epoch: epoch,
      );
      notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }

  Future<void> setMaxData() async{
    await FirebaseDatabase.instance.ref().once().then((event) {
      final response = event.snapshot.value as Map;
      Map tempo = response["System"]["Config"]["System1"]["Activate"]["ranges"];
      final tempData = tempo["t"];
      final humidData = tempo["h"];
      final pressureData = tempo["p"];
      _tempMin = tempData["minval"];
      _tempMax = tempData["maxval"];

      _humidMin = humidData["minval"];
      _humidMax = humidData["maxval"];

      _pressureMin = pressureData["minval"];
      _pressureMax = pressureData["maxval"];
      notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }
}
