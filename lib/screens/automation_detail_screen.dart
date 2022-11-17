import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot_project/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class AutomationDetailScreen extends StatefulWidget {
  final String sensorName;
  const AutomationDetailScreen({Key? key,required this.sensorName}) : super(key: key);

  @override
  State<AutomationDetailScreen> createState() => _AutomationDetailScreenState();
}

class _AutomationDetailScreenState extends State<AutomationDetailScreen> {
  bool lightStatus = false;
  bool fanStatus = false;
  bool acStatus = false;
  bool tvStatus = false;

  bool manualStatus = false;
  Future<void> readAutomationStatus() async {
    await FirebaseDatabase.instance.ref().once().then((event) {
      final response = event.snapshot.value as Map;
      setState((){
        manualStatus =
        response["System"]["Config"]["System1"]["Activate"]["isAutomation"];
        lightStatus = response["System"]["Config"]["System1"]["Automation"]["Light"];
        fanStatus = response["System"]["Config"]["System1"]["Automation"]["Fan"];
      });
    });
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
          "Automation Control",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 4.w, color: Colors.black),
        ),
        actions: [
          Switch(
              value: manualStatus,
              onChanged: (value) {
                FirebaseDatabase.instance
                    .ref()
                    .child("System")
                    .child("Config")
                    .child("System1")
                .child("Activate")
                    .update({
                  "isAutomation": value,
                });
                setState(() {
                  manualStatus = value;
                });
              },
              activeColor: const Color(0xFF007FFF),
          )
        ],
      ),
      body: FutureBuilder(
        future: readAutomationStatus(),
        builder: (context, snapshot) => SafeArea(
          child: Container(
              width: 100.w,
              height: 100.h,
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sensorName,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 6.w),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "Take Control of your Place",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 4.w,
                        color: const Color(0xFF7A5CE0)),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    height: 70.h,
                    width: 100.w,
                    child: manualStatus
                    ? GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: [
                        SizedBox(
                          height: 20.h,
                          child: Card(
                            margin: EdgeInsets.all(2.w),
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: lightStatus
                                        ? const Color(0xFFffdf00)
                                        : Colors.transparent,
                                    width: 2.0)),
                            shadowColor: lightStatus
                                ? const Color(0xFFffdf00)
                                : Colors.grey.withOpacity(0.4),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.lightbulb,
                                    color: lightStatus
                                        ? const Color(0xFFffdf00)
                                        : Colors.grey,
                                    size: 8.w,
                                  ),
                                  Text(
                                    "Light Bulb",
                                    style: TextStyle(
                                        color: themeViolet,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 5.w),
                                  ),
                                  Text(
                                    "Power Rating : 100W",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 3.w),
                                  ),
                                  FlutterSwitch(
                                    width: 40.0,
                                    height: 20.0,
                                    toggleSize: 15.0,
                                    value: lightStatus,
                                    borderRadius: 30.0,
                                    padding: 2.0,
                                    activeColor: const Color(0xFFffdf00),
                                    inactiveColor: Colors.black38,
                                    onToggle: (val) {
                                      setState(() {
                                        lightStatus = !lightStatus;
                                      });
                                      FirebaseDatabase.instance
                                          .ref()
                                          .child("System")
                                          .child("Config")
                                          .child("System1")
                                          .child("Automation")
                                          .update({
                                        "Light": lightStatus,
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                          child: Card(
                            margin: EdgeInsets.all(2.w),
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: fanStatus
                                        ? const Color(0xFF007FFF)
                                        : Colors.transparent,
                                    width: 2.0)),
                            shadowColor: fanStatus
                                ? const Color(0xFF007FFF)
                                : Colors.grey.withOpacity(0.4),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.fan,
                                    color: fanStatus
                                        ? const Color(0xFF007FFF)
                                        : Colors.grey,
                                    size: 8.w,
                                  ),
                                  Text(
                                    "Fan",
                                    style: TextStyle(
                                        color: themeViolet,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 5.w),
                                  ),
                                  Text(
                                    "Power Rating : 75W",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 3.w),
                                  ),
                                  FlutterSwitch(
                                    width: 40.0,
                                    height: 20.0,
                                    toggleSize: 15.0,
                                    value: fanStatus,
                                    borderRadius: 30.0,
                                    padding: 2.0,
                                    activeColor: const Color(0xFF007FFF),
                                    inactiveColor: Colors.black38,
                                    onToggle: (val) {
                                      setState(() {
                                        fanStatus = !fanStatus;
                                      });
                                      FirebaseDatabase.instance
                                          .ref()
                                          .child("System")
                                          .child("Config")
                                          .child("System1")
                                          .child("Automation")
                                          .update({
                                        "Fan": fanStatus,
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                          child: Card(
                            margin: EdgeInsets.all(2.w),
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: acStatus
                                        ? const Color(0xFF32CD32)
                                        : Colors.transparent,
                                    width: 2.0)),
                            shadowColor: acStatus
                                ? const Color(0xFF32CD32)
                                : Colors.grey.withOpacity(0.4),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.ac_unit,
                                    color: acStatus
                                        ? const Color(0xFF32CD32)
                                        : Colors.grey,
                                    size: 8.w,
                                  ),
                                  Text(
                                    "Air Conditioner",
                                    style: TextStyle(
                                        color: themeViolet,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 5.w),
                                  ),
                                  Text(
                                    "Power Rating : 2000W",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 3.w),
                                  ),
                                  FlutterSwitch(
                                    width: 40.0,
                                    height: 20.0,
                                    toggleSize: 15.0,
                                    value: acStatus,
                                    borderRadius: 30.0,
                                    padding: 2.0,
                                    activeColor: const Color(0xFF32CD32),
                                    inactiveColor: Colors.black38,
                                    onToggle: (val) {
                                      setState(() {
                                        acStatus = !acStatus;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                          child: Card(
                            margin: EdgeInsets.all(2.w),
                            elevation: 3.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: tvStatus
                                        ? const Color(0xFFFF6700)
                                        : Colors.transparent,
                                    width: 2.0)),
                            shadowColor: tvStatus
                                ? const Color(0xFFFF6700)
                                : Colors.grey.withOpacity(0.4),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.tv,
                                    color: tvStatus
                                        ? const Color(0xFFFF6700)
                                        : Colors.grey,
                                    size: 8.w,
                                  ),
                                  Text(
                                    "Television",
                                    style: TextStyle(
                                        color: themeViolet,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 5.w),
                                  ),
                                  Text(
                                    "Power Rating : 100W",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 3.w),
                                  ),
                                  FlutterSwitch(
                                    width: 40.0,
                                    height: 20.0,
                                    toggleSize: 15.0,
                                    value: tvStatus,
                                    borderRadius: 30.0,
                                    padding: 2.0,
                                    activeColor: const Color(0xFFFF6700),
                                    inactiveColor: Colors.black38,
                                    onToggle: (val) {
                                      setState(() {
                                        tvStatus = !tvStatus;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                        : Column(
                      children: [
                        Lottie.asset("assets/light_bulb.json"),
                        Text("Auto Mode is Set. Convert to Manual mode to take Full Control",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 4.w),)
                      ],
                    )
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
