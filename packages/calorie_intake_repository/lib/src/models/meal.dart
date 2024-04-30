import 'package:calorie_intake_repository/calorie_intake_repository.dart';

class Meal{
  String mealId;
  String userId;
  String type;
  int quantity;
  Consumable consumable;
  int calories;
  DateTime date;

  Meal({
    required this.mealId,
    required this.userId,
    required this.type,
    required this.quantity,
    required this.consumable,
    required this.calories,
    required this.date,
  });

  static final empty = Meal(
    mealId: '',
    userId: '',
    type: '',
    quantity: 0,
    consumable: Consumable.empty,
    calories: 0,
    date: DateTime.now(),
  );

  Meal.copy(Meal meal)
      : mealId = meal.mealId,
        userId = meal.userId,
        type = meal.type,
        quantity = meal.quantity,
        consumable = meal.consumable,
        calories = meal.calories,
        date = meal.date;

  MealEntity toEntity(){
    return MealEntity(
      mealId: mealId,
      userId: userId,
      type: type,
      quantity: quantity,
      consumable: consumable,
      calories: calories,
      date: date,
    );
  } 

  static Meal fromEntity(MealEntity entity){
    return Meal(
      mealId: entity.mealId,
      userId: entity.userId ,
      type: entity.type,
      quantity: entity.quantity,
      consumable: entity.consumable,
      calories: entity.calories,
      date: entity.date,
    );
  } 
}
