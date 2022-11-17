import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_project/provider/qr_scanner_provider.dart';
import 'package:iot_project/screens/automation_detail_screen.dart';
import 'package:iot_project/screens/fire_detail_screen.dart';
import 'package:iot_project/screens/notification_screen.dart';
import 'package:iot_project/screens/weather_details_screen.dart';
import 'package:iot_project/widgets/sensor_widget.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;

  String username = "";

  bool isConnected = false;

  int selectedScreen = 1;

  Future<void> readData() async {
    await FirebaseDatabase.instance.ref().once().then((event) {
      final response = event.snapshot.value as Map;
      username = response["auth"][currentUser!.uid]["username"];
      isConnected = response["auth"][currentUser!.uid]["isConnected"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        actions: [
          PopupMenuButton<int>(
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                    const PopupMenuItem<int>(
                        value: 1, child: Text('All Sensors')),
                    const PopupMenuItem<int>(
                        value: 2, child: Text('Notifications')),
                  ],
              onSelected: (int value) {
                if(value==2){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
                }
              }),
        ],
      ),
      body: FutureBuilder(
        future: readData(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7A5CE0),
                ),
              )
            : SafeArea(
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: isConnected
                      ? ListView(
                          children: [
                            Text(
                              "Hi $username 👋",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 6.w),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "Let's control your trackers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 4.w,
                                  color: Color(0xFF7A5CE0)),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Image.asset(
                              "assets/homeScreen.jpg",
                              height: 35.h,
                              width: 80.w,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SensorWidget(
                              title: "Alexa",
                              categoryName: "Automation Control",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AutomationDetailScreen(
                                              sensorName: "Alexa",
                                            )));
                              },
                            ),
                            SensorWidget(
                              title: "NodeBlue",
                              categoryName: "Weather Monitor",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WeatherDetailScreen(
                                              sensorName: "NodeBlue",
                                            )));
                              },
                            ),
                            SensorWidget(
                              title: "FireStixx",
                              categoryName: "Fire Alarm",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FireDetailScreen(
                                              sensorName: "FireStixx",
                                            )));
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "Please Pair a Device first by clicking the + button",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 5.w,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                ),
              ),
      ),
      floatingActionButton:
          FutureBuilder(
            future: readData(),
            builder: (context,snapshot) =>
                isConnected
              ? SizedBox()
                : FloatingActionButton(
        onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => QrCodeView()));
            setState(() {});
        },
        child: const Icon(
            CupertinoIcons.add,
            color: Color(0xFF7A5CE0),
        ),
        backgroundColor: Colors.white,
      ),
          ),
    );
  }
}
