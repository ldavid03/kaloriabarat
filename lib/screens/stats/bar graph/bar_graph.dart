import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/stats/bar%20graph/bar_data.dart';
class MyBarGraph extends StatelessWidget {
  final List<int>  data;
  final BuildContext ctx;
  const MyBarGraph({super.key, required this.data, required this.ctx});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(dailyCalories: data);
    myBarData.initializeBarData();
    return BarChart(
      BarChartData(
          maxY:7000,
          minY:0,
          barGroups: myBarData.barData
          .map(
            (data) => BarChartGroupData(
              x: data.x,
              barRods: [ 
                BarChartRodData(toY: data.y, color:getColorScheme(ctx).secondary, width: 20.0),
              ],
            ),
          ).toList(),
      ),
    );
  }
}