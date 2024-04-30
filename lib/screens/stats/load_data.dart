import 'dart:developer';

import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:collection/collection.dart';
import 'package:user_repository/user_repository.dart';

Future<List<int>> loadData(MyUser myUser) async {
  CalorieIntakeRepository calorieIntakeRepository = FirebaseCalorieIntakeRepo();
  List<Meal> meals = await calorieIntakeRepository.getUsersMeals(myUser);
  log("Meals: ${meals.length}");
  List<int> dailyCalories = [];
  dailyCalories = meals.map((meal) => meal.calories).toList();
  log("Daily Calories: ${dailyCalories.length}");

  var mealsGroupedByDate = groupBy(meals, (Meal meal) => meal.date);
  dailyCalories = mealsGroupedByDate.entries.map((entry) {
    var date = entry.key;
    var mealsOnThisDate = entry.value;
    var totalCaloriesOnThisDate = mealsOnThisDate.fold(0, (sum, meal) => sum + meal.calories);
    return totalCaloriesOnThisDate;
  }).toList();

  var dailyCalories2 = mealsGroupedByDate.entries.map((entry) {
    var mealsOnThisDate = entry.value;
    var totalCaloriesOnThisDate = mealsOnThisDate.fold(0, (sum, meal) => sum + meal.calories);
  return totalCaloriesOnThisDate;
  }).toList();
  return dailyCalories2;
}



Future<List<Map<String, int>>> loadData2(MyUser myUser) async {
  CalorieIntakeRepository calorieIntakeRepository = FirebaseCalorieIntakeRepo();
  List<Meal> meals = await calorieIntakeRepository.getUsersMeals(myUser);
  log("Meals: ${meals.length}");
  List<int> dailyCalories = [];
  dailyCalories = meals.map((meal) => meal.calories).toList();
  log("Daily Calories: ${dailyCalories.length}");

  var mealsGroupedByType = groupBy(meals, (Meal meal) => meal.type);

var averageCaloriesByType = mealsGroupedByType.entries.map((entry) {
  var type = entry.key;
  var mealsOfThisType = entry.value;
  var totalCaloriesOfThisType = mealsOfThisType.fold(0, (sum, meal) => sum + meal.calories);
  var averageCaloriesOfThisType = (totalCaloriesOfThisType / mealsOfThisType.length).round();
  return {type: averageCaloriesOfThisType};
}).toList();

return averageCaloriesByType;
}



Future<int> loadData3(MyUser myUser, int x) async {
  CalorieIntakeRepository calorieIntakeRepository = FirebaseCalorieIntakeRepo();
  List<Meal> meals = await calorieIntakeRepository.getUsersMeals(myUser);
  DateTime today = DateTime.now();
  DateTime startDate = today.subtract(Duration(days: x));

  var mealsInLastXDays = meals.where((meal) => meal.date.isAfter(startDate) && meal.date.isBefore(today));

  var mealsGroupedByDate = groupBy(mealsInLastXDays, (Meal meal) => meal.date);
  var dailyCalories = mealsGroupedByDate.entries.map((entry) {
    var date = entry.key;
    var mealsOnThisDate = entry.value;
    var totalCaloriesOnThisDate = mealsOnThisDate.fold(0, (sum, meal) => sum + meal.calories);
    return totalCaloriesOnThisDate;
  }).toList();

  var totalCaloriesInLastXDays = dailyCalories.fold(0, (sum, calories) => sum + calories);
  var averageCaloriesInLastXDays = (totalCaloriesInLastXDays / x).round();

  return averageCaloriesInLastXDays;
}
