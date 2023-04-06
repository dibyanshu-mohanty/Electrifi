import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iot_project/provider/smart_meter_provider.dart';
import 'package:iot_project/provider/weather_data_provider.dart';
import 'package:iot_project/screens/auth_screen.dart';
import 'package:iot_project/screens/home_screen.dart';
import 'package:iot_project/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);


  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WeatherDataProvider()),
        ChangeNotifierProvider(create: (context) => SmartMeterData()),
      ],
      child: Sizer(
        builder:(context,orientation,deviceType) => MaterialApp(
          title: 'IoT Project',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: "Satoshi"
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
