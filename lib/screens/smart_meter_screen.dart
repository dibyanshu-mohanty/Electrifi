import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iot_project/provider/smart_meter_provider.dart';
import 'package:iot_project/screens/smartMeterChartScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SmartMeterScreen extends StatelessWidget {
  const SmartMeterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meter = Provider.of<SmartMeterData>(context);
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
          "Smart Meter",
          style: TextStyle(
              fontWeight: FontWeight.w300, fontSize: 4.w, color: Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SmartChartScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                CupertinoIcons.chart_bar_alt_fill,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name :",
                    style: TextStyle(
                      fontSize: 3.w,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Dibyanshu Mohanty",
                    style: TextStyle(
                      fontSize: 4.w,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Installed on :",
                    style: TextStyle(
                      fontSize: 3.w,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "27/2/2023",
                    style: TextStyle(
                      fontSize: 4.w,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
              Expanded(
                  child: ListView(
                children: List.generate(
                    meter.meterData.length,
                    (index) => Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          leading: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                          ),
                          title: Text(
                            "${meter.meterData[index]["units"]} kWh",
                            style: TextStyle(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "${meter.meterData[index]["datetime"]}",
                            style: TextStyle(
                                fontSize: 3.w,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          trailing: Text(
                            "\u{20B9} ${meter.meterData[index]["amount"]}",
                            style: TextStyle(
                              fontSize: 4.w,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ))),
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 8.h,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.0,
              blurRadius: 2.0)
        ]),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: ",
              style: TextStyle(
                  fontSize: 4.w,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF125B50)),
            ),
            Text(
              "\u{20B9} ${meter.totalAmount.toStringAsFixed(2)}",
              style: TextStyle(
                  fontSize: 4.w,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF125B50)),
            ),
          ],
        ),
      ),
    );
  }
}
