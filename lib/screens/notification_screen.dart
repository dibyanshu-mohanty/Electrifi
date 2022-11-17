import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

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
            "Notifications",
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 4.w, color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Container(
            width: 100.w,
            height: 100.h,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              children: [
                Card(
                  elevation: 3.0,
                  child: SizedBox(
                    height: 12.h,
                    child: ListTile(
                      leading: Icon(Icons.dangerous_outlined,color: Colors.redAccent,),
                      title: Text("There is Fire at your Place",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w400),),
                      subtitle: Text("Water has been Dispatched",style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w300),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
