import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/pages/stats/components/bar_graph.dart';
import 'package:kaloriabarat/pages/stats/controllers/load_data.dart';
import 'package:user_repository/user_repository.dart';

class StatsScreen extends StatefulWidget {
  final MyUser myUser;
  const StatsScreen({required this.myUser, super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<Map<int, String>> weeklyCalorieIntakeReportData = [];
  List<Map<String, int>> averageDailyCaloriesByMealType = [];
  List<String> daysOfWeek = [];

  int averageCalorieIntakeValue = 0;

  @override
  void initState() {
    super.initState();
    loadd();
  }

  Future<void> loadd() async {
    var weeklyCalorieIntakeReport =
        await calculateWeeklyCalorieIntakeReport(widget.myUser);
    var today = DateFormat('E').format(DateTime.now());
    var todaysName = today.substring(0, 3);
    weeklyCalorieIntakeReport = sortDays(todaysName, weeklyCalorieIntakeReport);
    averageDailyCaloriesByMealType =
        await calulateWeeklyAverageCaloriesByMealType(widget.myUser);
    averageCalorieIntakeValue =
        await calculateAverageDailyCalorieIntake(widget.myUser);

    if (!mounted) return;

    setState(() {
      weeklyCalorieIntakeReportData = weeklyCalorieIntakeReport;
      daysOfWeek = weeklyCalorieIntakeReportData
          .map((item) => item.values.first)
          .toList();
    });
  }

  List<Map<int, String>> sortDays(
      String startingDay, List<Map<int, String>> unsortedDays) {
    List<String> orderedDays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat'
    ];
    int startingIndex = orderedDays.indexOf(startingDay.substring(0, 3));
    List<String> rotatedDays = orderedDays.sublist(startingIndex)
      ..addAll(orderedDays.sublist(0, startingIndex));
    log(rotatedDays.length.toString());
    Map<String, int> dayIndexMap = {};
    for (int i = 0; i < rotatedDays.length; i++) {
      dayIndexMap[rotatedDays[i]] = i;
    }
    unsortedDays.sort((a, b) =>
        dayIndexMap[a.values.first]!.compareTo(dayIndexMap[b.values.first]!));
    return unsortedDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const MyText("Statistics", "xl", "b"),
        backgroundColor: getColorScheme(context).secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: getColorScheme(context).tertiary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Center(child: MyText('Daily Average', "xm", "n")),
                      const SpaceHeight('s'),
                      MyText(averageCalorieIntakeValue.toString(), "xxl", "b"),
                    ],
                  ),
                ),
              ),
              const SpaceHeight('m'),
              Container(
                decoration: BoxDecoration(
                  color: getColorScheme(context).tertiary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Center(child: MyText('Weekly report', "xm", "n")),
                      const SpaceHeight('s'),
                      SizedBox(
                        height: 200,
                        child: MyBarGraph(
                            data: weeklyCalorieIntakeReportData, ctx: context),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(55, 15, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: daysOfWeek.map((day) => Text(day)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpaceHeight('m'),
              Container(
                decoration: BoxDecoration(
                  color: getColorScheme(context).tertiary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const Center(
                          child: MyText('Meal types average', "xm", "n")),
                      const SpaceHeight('s'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: averageDailyCaloriesByMealType.map((entry) {
                            var type = entry.keys.first;
                            var averageCalorieIntakeValue = entry.values.first;
                            return Row(
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: MyText('$type: ', "l", "n")),
                                MyText('$averageCalorieIntakeValue', "ls", "b",
                                    color: "secondary"),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
