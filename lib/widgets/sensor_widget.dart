import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class SensorWidget extends StatelessWidget {
  final String title;
  final String categoryName;
  final Function onPressed;
  const SensorWidget({Key? key,required this.title, required this.categoryName, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            color: Color(0xFF125B50),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0.5.h,horizontal: 3.w),
              minLeadingWidth: 1.w,
              leading: Icon(Icons.sensors,color: Colors.white,),
              title: Text(title,style: TextStyle(fontSize: 4.5.w,fontWeight: FontWeight.w500,color: Colors.white),),
              subtitle: Text(categoryName,style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w300,color: Colors.white),),
              trailing: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 4.5.w,),
            ),
          ),
    );
  }
}
