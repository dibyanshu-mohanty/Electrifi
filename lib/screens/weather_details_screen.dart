import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_project/provider/weather_data_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// ignore: prefer_const_constructors
class WeatherDetailScreen extends StatefulWidget {
  final String sensorName;
  const WeatherDetailScreen({Key? key, required this.sensorName})
      : super(key: key);

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  bool weatherMonitorStatus = false;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  Future<void> readWeatherMonitorStatus() async {
    await FirebaseDatabase.instance.ref().once().then((event) async {
      final response = event.snapshot.value as Map;
      if (!mounted) {
        setState(() {
          weatherMonitorStatus =
              response["System"]["Config"]["System1"]["Activate"]["isWeather"];
        });
      }
      print(weatherMonitorStatus);
      await Provider.of<WeatherDataProvider>(context, listen: false)
          .fetchWeatherData();
      await Provider.of<WeatherDataProvider>(context, listen: false)
          .setMaxData();
    });
  }

  void dispose() {
    super.dispose();
    _maxController.dispose();
    _minController.dispose();
  }

  showModelAlertDialog(String type) async {
    return await showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Set Min and Max Values for the $type, All are in Standard Values. \n"
                      "(Temperature : °C, Humidity : %, Pressure : Pa",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 4.w, fontWeight: FontWeight.w300),
                    ),
                    TextField(
                      controller: _minController,
                      style: TextStyle(fontSize: 4.w),
                      cursorColor: const Color(0xFF7A5CE0),
                      decoration: InputDecoration(
                        hintText: "Set Minimum Value",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 3.w),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7A5CE0))),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7A5CE0))),
                      ),
                    ),
                    TextField(
                      controller: _maxController,
                      style: TextStyle(fontSize: 4.w),
                      cursorColor: const Color(0xFF7A5CE0),
                      decoration: InputDecoration(
                        hintText: "Set Maximum Value",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 3.w),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7A5CE0))),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF7A5CE0))),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_minController.text.isEmpty ||
                            _maxController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please Enter Valid Values");
                          return;
                        }
                        if (double.parse(_minController.text) >
                            double.parse(_maxController.text)) {
                          Fluttertoast.showToast(
                              msg:
                                  "Minimum value can't be greater then Maximum");
                          return;
                        }
                        if (type == "Temperature") {
                          FirebaseDatabase.instance
                              .ref()
                              .child("System")
                              .child("Config")
                              .child("System1")
                              .child("Activate")
                              .child("ranges")
                              .child("t")
                              .update({
                            "maxval": double.parse(_maxController.text).floor(),
                            "minval": double.parse(_minController.text).floor(),
                          });
                          setState(() {});
                        } else if (type == "Humidity") {
                          FirebaseDatabase.instance
                              .ref()
                              .child("System")
                              .child("Config")
                              .child("System1")
                              .child("Activate")
                              .child("ranges")
                              .child("h")
                              .update({
                            "maxval": double.parse(_maxController.text).floor(),
                            "minval": double.parse(_minController.text).floor(),
                          });
                          setState(() {});
                        } else if (type == "Pressure") {
                          FirebaseDatabase.instance
                              .ref()
                              .child("System")
                              .child("Config")
                              .child("System1")
                              .child("Activate")
                              .child("ranges")
                              .child("p")
                              .update({
                            "maxval": double.parse(_maxController.text).floor(),
                            "minval": double.parse(_minController.text).floor(),
                          });
                          setState(() {});
                        }
                        _maxController.clear();
                        _minController.clear();
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7A5CE0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          "Set Alert",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 3.w,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20.0,
          ),
        ),
        title: Text(
          "Weather Monitor Statistics",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 4.w, color: Colors.black),
        ),
        actions: [
          Switch(
            value: weatherMonitorStatus,
            onChanged: (value) async{
              await FirebaseDatabase.instance
                  .ref()
                  .child("System")
                  .child("Config")
                  .child("System1")
                  .child("Activate")
                  .update({
                "isWeather": value,
              });
              setState(() {
                weatherMonitorStatus = value;
              });
            },
            activeColor: const Color(0xFFffdf00),
          )
        ],
      ),
      body: FutureBuilder(
          future: readWeatherMonitorStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Color(0xFF7A5CE0),
              ));
            }
            return SafeArea(
              child: Consumer<WeatherDataProvider>(
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF7A5CE0),
                  )),
                  builder: (context, weather, child) {
                    if (weather.weather == null) {
                      return child!;
                    }
                    return Container(
                      width: 100.w,
                      height: 100.h,
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: ListView(
                        children: [
                          Text(
                            widget.sensorName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 6.w),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Monitor the Conditions at your Place",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 4.w,
                                color: const Color(0xFF7A5CE0)),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: weather.weather!.tempPercent,
                            center: Text(
                              "${weather.weather!.temperature.ceil()} °C",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 5.w),
                            ),
                            header: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Temperature",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 5.w),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        showModelAlertDialog("Temperature");
                                      },
                                      child: Text(
                                        "Set Alert",
                                        style: TextStyle(
                                            color: const Color(0xFF7A5CE0),
                                            fontSize: 4.w,
                                            fontWeight: FontWeight.w300),
                                      ))
                                ],
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            arcType: ArcType.FULL,
                            arcBackgroundColor: Colors.grey.withOpacity(0.25),
                            linearGradient: const LinearGradient(colors: [
                              Color(0xFF7294DC),
                              Color(0xFF5677CF),
                              Color(0xFF2357FE),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Min : ${weather.tempMin} °C",
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "Max : ${weather.tempMax} °C",
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: weather.weather!.humidityPercent,
                            center: Text(
                              "${weather.weather!.humidity.ceil()} %",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 5.w),
                            ),
                            header: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Humidity",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 5.w),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      showModelAlertDialog("Humidity");
                                    },
                                    child: Text(
                                      "Set Alert",
                                      style: TextStyle(
                                          color: const Color(0xFF7A5CE0),
                                          fontSize: 4.w,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            arcType: ArcType.FULL,
                            arcBackgroundColor: Colors.grey.withOpacity(0.25),
                            linearGradient: const LinearGradient(colors: [
                              Color(0xFFF96666),
                              Color(0xFFFA7070),
                              Color(0xFFCD104D),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Min : ${weather.humidMin} %",
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "Max : ${weather.humidMax} %",
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            percent: weather.weather!.pressurePercent,
                            center: Text(
                              "${weather.weather!.pressure.ceil()} Pa",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 5.w),
                            ),
                            header: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Pressure",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 5.w),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      showModelAlertDialog("Pressure");
                                    },
                                    child: Text(
                                      "Set Alert",
                                      style: TextStyle(
                                          color: const Color(0xFF7A5CE0),
                                          fontSize: 4.w,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            arcType: ArcType.FULL,
                            arcBackgroundColor: Colors.grey.withOpacity(0.25),
                            linearGradient: const LinearGradient(colors: [
                              Color(0xFFC7F2A4),
                              Color(0xFFB6E388),
                              Color(0xFF367E18),
                            ]),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Min : ${weather.pressureMin} Pa",
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w300),
                              ),
                              Text(
                                "Max : ${weather.pressureMax} Pa",
                                style: TextStyle(
                                    fontSize: 4.w, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }),
    );
  }
}

// SizedBox(
//   height: 8.h,
//   child: FlutterSlider(
//     min: 0,
//     max: 2500.0,
//     trackBar: FlutterSliderTrackBar(
//       activeTrackBar: BoxDecoration(
//         color: Color(0xFF2357FE).withOpacity(0.5)
//       )
//     ),
//     rangeSlider: true,
//     handlerAnimation: const FlutterSliderHandlerAnimation(
//         curve: Curves.easeIn,
//         reverseCurve: Curves.easeInOut,
//         duration: Duration(milliseconds: 500),
//         scale: 1.5),
//     values: [
//       0.0,
//       900.0
//     ],
//     handler: FlutterSliderHandler(
//       child: const Icon(Icons.chevron_right, color: Colors.black45, size: 18,),
//     ),
//     rightHandler: FlutterSliderHandler(
//       child: const Icon(Icons.chevron_left, color: Colors.black45, size: 18,),
//     ),
//   ),
// ),
