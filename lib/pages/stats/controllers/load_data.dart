import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:user_repository/user_repository.dart';

Future<List<Map<int, String>>> calculateWeeklyCalorieIntakeReport(MyUser myUser) async {
  CalorieIntakeRepository calorieIntakeRepository = FirebaseCalorieIntakeRepo();
  List<Meal> meals = await calorieIntakeRepository.getUsersMeals(myUser);
  DateTime now = DateTime.now();
  DateTime sevenDaysAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 7));
  meals = meals
      .where((meal) =>
          meal.date.isAfter(sevenDaysAgo) &&
          !isSameDay(meal.date, now))
      .toList();
  var mealsGroupedByDate = groupBy(meals, (Meal meal) => DateTime(meal.date.year, meal.date.month, meal.date.day));
  List<Map<int, String>> dailyCalories =
      mealsGroupedByDate.entries.map((entry) {
    var date = entry.key;
    var mealsOnThisDate = entry.value;
    var totalCaloriesOnThisDate =
        mealsOnThisDate.fold(0, (sum, meal) => sum + meal.calories);
    var dayOfWeek = DateFormat('E').format(date);
    var firstLetterOfDay = dayOfWeek.substring(0, 3);
    return {totalCaloriesOnThisDate: firstLetterOfDay};
  }).toList();

  return dailyCalories;
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

Future<List<Map<String, int>>> calulateWeeklyAverageCaloriesByMealType(MyUser myUser) async {
  CalorieIntakeRepository calorieIntakeRepository = FirebaseCalorieIntakeRepo();
  List<Meal> meals = await calorieIntakeRepository.getUsersMeals(myUser);
  var mealsGroupedByType = groupBy(meals, (Meal meal) => meal.type);
  var averageCaloriesByType = mealsGroupedByType.entries.map((entry) {
    var type = entry.key;
    var mealsOfThisType = entry.value;
    var totalCaloriesOfThisType =
        mealsOfThisType.fold(0, (sum, meal) => sum + meal.calories);
    var averageCaloriesOfThisType =
        (totalCaloriesOfThisType / mealsOfThisType.length).round();
    return {type: averageCaloriesOfThisType};
  }).toList();
  return averageCaloriesByType;
}

Future<int> calculateAverageDailyCalorieIntake(MyUser myUser) async {
  CalorieIntakeRepository calorieIntakeRepository = FirebaseCalorieIntakeRepo();
  List<Meal> meals = await calorieIntakeRepository.getUsersMeals(myUser);
  DateTime today = DateTime.now();
  DateTime sevenDaysAgo = today.subtract(const Duration(days: 7));
  var mealsInLast7Days = meals.where(
      (meal) => meal.date.isAfter(sevenDaysAgo) && meal.date.isBefore(today));
  var mealsGroupedByDate = groupBy(mealsInLast7Days, (Meal meal) => meal.date);
  var dailyCalories = mealsGroupedByDate.entries.map((entry) {
    var mealsOnThisDate = entry.value;
    var totalCaloriesOnThisDate =
        mealsOnThisDate.fold(0, (sum, meal) => sum + meal.calories);
    return totalCaloriesOnThisDate;
  }).toList();

  dailyCalories.removeWhere((calories) => calories == 0);

  if (dailyCalories.isEmpty) {
    return 0;
  }

  var totalCaloriesInLast7Days =
      dailyCalories.fold(0, (sum, calories) => sum + calories);
  var averageCaloriesInLast7Days =
      (totalCaloriesInLast7Days / dailyCalories.length).round();

  return averageCaloriesInLast7Days;
}
