import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/stats/bar%20graph/bar_graph.dart';
import 'package:kaloriabarat/screens/stats/load_data.dart';
import 'package:user_repository/user_repository.dart';

class StatsScreen extends StatefulWidget {
  final MyUser myUser;
  const StatsScreen({required this.myUser, Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<int> data1 = [];
  List<Map<String, int>> data2 = [];
  int averageCalories = 0;

  @override
  void initState() {
    super.initState();
    loadd();
  }

  Future<void> loadd() async {
    var newData = await loadData(widget.myUser);
    var newData2 = await loadData2(widget.myUser);
    var newData3 = await loadData3(widget.myUser, 7);

    if (!mounted) return;

    setState(() {
      List<int> averageData = [];
      for (var i = 0; i < newData.length; i += 2) {
        var average =
            ((newData[i] + (i + 1 < newData.length ? newData[i + 1] : 0)) / 2)
                .round();
        averageData.add(average);
      }
      data1 = averageData;
      data2 = newData2;
      averageCalories = newData3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: MyText("Statistics", "xl", "b"),
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
                      Center(child: MyText('Weekly Average', "xm", "n")),
                      SpaceHeight('s'),
                      MyText(averageCalories.toString(), "xxl", "b"),
                    ],
                  ),
                ),
              ),
              SpaceHeight('m'),
              Container(
                decoration: BoxDecoration(
                  color: getColorScheme(context).tertiary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Center(child: MyText('Monthly report', "xm", "n")),
                      SpaceHeight('s'),
                      SizedBox(
                        height: 200,
                        child: MyBarGraph(data: data1, ctx: context),
                      ),
                    ],
                  ),
                ),
              ),
              SpaceHeight('m'),
              Container(
                decoration: BoxDecoration(
                  color: getColorScheme(context).tertiary.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Center(child: MyText('Meal types average', "xm", "n")),
                      SpaceHeight('s'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: data2.map((entry) {
                            var type = entry.keys.first;
                            var averageCalories = entry.values.first;
                            return Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: MyText('$type: ', "l", "n")),
                                
                                MyText('$averageCalories', "l", "b",color: "primary"),
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
