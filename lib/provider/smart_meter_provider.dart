import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

class SmartMeterData with ChangeNotifier{
  List<Map<String,dynamic>> _meterData = [];

  List<Map<String,dynamic>> get meterData{
    return [..._meterData];
  }

  double _totalAmount = 0.0;
  double get totalAmount{
     return _totalAmount;
  }

  void updateSmartMeterData(){
    Timer.periodic(const Duration(seconds: 30), (timer) {
      double data = Random().nextInt(20).toDouble() * 0.024;
      double amount = data * 3.25;
      _meterData.add(
        {
          "datetime" : DateTime.now(),
          "units" : data.toStringAsFixed(2),
          "amount" : amount.toStringAsFixed(2),
        },
      );
      _totalAmount += amount;
    });
    notifyListeners();
  }

}