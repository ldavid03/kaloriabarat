import 'package:kaloriabarat/screens/stats/bar%20graph/individual_bar.dart';

class BarData {
    final List<int> dailyCalories;


    BarData({required this.dailyCalories});

    List<IndividualBar> barData = [];

    void initializeBarData(){
      for (int i = 0; i < dailyCalories.length; i++) {
        barData.add(IndividualBar(x: i %7 +1, y: dailyCalories[i].toDouble()));
      }
    }
}
