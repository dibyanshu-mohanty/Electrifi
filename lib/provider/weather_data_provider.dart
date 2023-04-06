import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_project/models/weather_model.dart';

class WeatherDataProvider with ChangeNotifier {
  Weather? _weather;

  Weather? get weather {
    return _weather;
  }

  int _tempMax = 500;
  int _tempMin = 0;

  int _humidMax = 100;
  int _humidMin = 0;


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



  double calculateTempPercent(double input) {
    return double.parse((input / 100).toStringAsFixed(1));
  }

  double calculateHumidityPercent(double input) {
    return double.parse((input / 100).toStringAsFixed(1));
  }


  Map<dynamic,dynamic> getLatest(List arr) {
      int max = 0;
      for(int i =0; i< arr.length; i++){
        if(arr[i]["epochtime"] > max){
          max = arr[i]["epochtime"];
        } else {
          continue ;
        }
      }
      return arr.firstWhere((element) => element["epochtime"] == max);
  }
  Future<void> fetchWeatherData() async {
    await FirebaseDatabase.instance.ref().once().then((event) async{
      final response = event.snapshot.value as Map;
      Map tempo = response["System"]["Config"]["System1"]["Weather"];
      final data = getLatest(tempo.values.toList());
      print(data);
      double temperature = data["temprature"];
      final tempPercent =
          calculateTempPercent(data["temprature"]);
      double humidity = data["humidity"];
      final humidityPercent =
          calculateHumidityPercent(data["humidity"]);
      final epoch = data["epochtime"];
      _weather = Weather(
          temperature: temperature,
          tempPercent: tempPercent,
          humidity: humidity,
          humidityPercent: humidityPercent,
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
      notifyListeners();
    }).catchError((error) {
      print(error);
    });
  }
}
