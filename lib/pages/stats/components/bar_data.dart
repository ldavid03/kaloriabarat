import 'package:kaloriabarat/pages/stats/components/individual_bar.dart';

class BarData {
  final List<int> dailyCalories;
  final List<String> dayOfWeek;
  List<IndividualBar> barData = [];

  BarData({required this.dailyCalories, required this.dayOfWeek});

  void initializeBarData() {
    for (int i = 0; i < dailyCalories.length; i++) {
      barData
          .add(IndividualBar(x: dayOfWeek[i], y: dailyCalories[i].toDouble()));
    }
  }
}
