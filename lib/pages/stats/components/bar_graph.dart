import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/pages/stats/components/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List<Map<int, String>> data;
  final BuildContext ctx;
  const MyBarGraph({super.key, required this.data, required this.ctx});

  @override
  Widget build(BuildContext context) {
    List<int> intValues = data.map((item) => item.keys.first).toList();
    List<String> daysOfWeek = data.map((item) => item.values.first).toList();
    BarData myBarData =
        BarData(dailyCalories: intValues, dayOfWeek: daysOfWeek);
    myBarData.initializeBarData();
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        maxY: 4000,
        minY: 0,
        barGroups: myBarData.barData
            .map(
              (data) => BarChartGroupData(
                x: data.y.toInt(),
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: getColorScheme(ctx).secondary,
                    width: 20.0,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
