import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class FireDetailScreen extends StatefulWidget {
  final String sensorName;
  const FireDetailScreen({Key? key,required this.sensorName}) : super(key: key);

  @override
  State<FireDetailScreen> createState() => _FireDetailScreenState();
}

class _FireDetailScreenState extends State<FireDetailScreen> {

  int fireStatus = 0;
  Future<void> readFireStatus() async {
    await FirebaseDatabase.instance.ref().once().then((event) {
      final response = event.snapshot.value as Map;
      setState((){
        fireStatus =
        response["System"]["Config"]["System1"]["isFire"];
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
          "Fire Alarm Setup",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 4.w, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: readFireStatus(),
          builder: (context,snapshot) => Container(
            width: 100.w,
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: ListView(
              children: [
                Text(
                  widget.sensorName,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 6.w),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Prevent Fire before it burns you.",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 4.w,
                      color: const Color(0xFF7A5CE0)),
                ),
                SizedBox(
                  height: 4.h,
                ),
                fireStatus == 1
                ? Lottie.asset("assets/water_extinguisher.json",height: 40.h)
                : Lottie.asset("assets/fire.json",height: 40.h),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  fireStatus == 1
                  ? "Water has been Dispatched"
                  : "Your Fire alert is turned ON.",textAlign: TextAlign.center,style: TextStyle(fontSize: 5.w,fontWeight: FontWeight.w300, ),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
