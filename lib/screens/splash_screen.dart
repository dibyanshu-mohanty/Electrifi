import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iot_project/screens/auth_screen.dart';
import 'package:iot_project/screens/home_screen.dart';
import 'package:sizer/sizer.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      currentUser == null
          ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()))
          : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: 100.h,
          width: 100.w,
          child: Image.asset("assets/logo.png",height: 80.h,width: 80.w,),
        )
    );
  }
}
