import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class SmartChartScreen extends StatefulWidget {
  const SmartChartScreen({Key? key}) : super(key: key);

  @override
  State<SmartChartScreen> createState() => _SmartChartScreenState();
}

class _SmartChartScreenState extends State<SmartChartScreen> {

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, 
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.navigate_before,color: Colors.black,),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 3.h,horizontal: 5.w),
        child: RotatedBox(
          quarterTurns: 3,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis:
            CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
            primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 400,
                majorTickLines: const MajorTickLines(size: 0)),
            series: [BarSeries<GraphData,dynamic>(
              dataSource: <GraphData>[
                GraphData('Oct', 0),
                GraphData('Sept', 0),
                GraphData('Aug', 0),
                GraphData('July', 00),
                GraphData('June', 0),
                GraphData('May', 0),
                GraphData('Apr', 0),
                GraphData('Mar', 210),
                GraphData('Feb', 230),
                GraphData('Jan', 200),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              xValueMapper: (GraphData data, _) => data.month,
              yValueMapper: (GraphData data, _) => data.usage,
            ),],
            tooltipBehavior: _tooltipBehavior,
          ),
        ),
      ),
    );
  }
}

class GraphData{
  final String month;
  final double usage;
  GraphData(this.month,this.usage);
}
