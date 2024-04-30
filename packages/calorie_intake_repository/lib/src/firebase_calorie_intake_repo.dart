import 'dart:developer';

import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseCalorieIntakeRepo implements CalorieIntakeRepository{
  final consumableCollection = FirebaseFirestore.instance.collection('consumables');
  final mealCollection = FirebaseFirestore.instance.collection('meals');

  @override
  Future<void> createConsumable(Consumable consumable) async {
    try{
      await consumableCollection
      .doc(consumable.consumableId)
      .set(consumable.toEntity().toDocument());
    }
    catch(e){
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Consumable>> getConsumables() async {
    try{
      return await consumableCollection
      .get()
      .then((value) => value.docs.map((e) =>
        Consumable.fromEntity(ConsumableEntity.fromDocument(e.data()))
      ).toList());
    }
    catch (e) {
      log(e.toString());
      rethrow;
    }
  }

    @override
  Future<void> createMeal(Meal meal) async {
    try{
      await mealCollection
      .doc(meal.mealId)
      .set(meal.toEntity().toDocument());
    }
    catch(e){
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Meal>> getMeals() async {
    try{
      return await mealCollection
      .get()
      .then((value) => value.docs.map((e) =>
        Meal.fromEntity(MealEntity.fromDocument(e.data()))
      ).toList());
    }
    catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Meal>> getUsersMeals(MyUser user) async {
    try{
      return await mealCollection
      .get()
      .then((value) => value.docs.map((e) =>
        Meal.fromEntity(MealEntity.fromDocument(e.data()))
      ).toList())
      .then((meals) => meals.where((meal) => meal.userId == user.userId).toList());
    }
    catch (e) {
      log(e.toString());
      rethrow;
    }
  }


Future<List<Consumable>> getConsumables2(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('consumables')
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data != null ? Consumable.fromEntity(ConsumableEntity.fromDocument(data)) : null;
    }).where((consumable) => consumable != null).toList().cast<Consumable>();
  } catch (e) {
    return [];
  }
}

  
}