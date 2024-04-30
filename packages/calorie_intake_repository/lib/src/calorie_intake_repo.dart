import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:user_repository/user_repository.dart';

abstract class CalorieIntakeRepository {
  Future<void> createConsumable(Consumable consumable);

  Future<List<Consumable>> getConsumables();

  Future<void> createMeal(Meal meal);

  Future<List<Meal>> getMeals();
  Future<List<Meal>> getUsersMeals(MyUser user);
  Future<List<Consumable>> getConsumables2(String userId);
}