import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const themeViolet = Color(0xFF125B50);

final kInputDecoration = InputDecoration(
  labelText: "Username",
  labelStyle: TextStyle(color: Colors.black,fontSize: 4.w,fontWeight: FontWeight.w400),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.black)
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.black)
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.redAccent)
  ),
);