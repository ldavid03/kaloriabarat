import 'dart:math';
import 'package:kaloriabarat/static_data/meal_types.dart';

import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

void generateConsumables(String userId) {
  var faker = Faker();
  var uuid = const Uuid();
  var random = Random();

  List<Consumable> consumables = [];
  for (var i = 0; i < 20; i++) {
    Consumable c = Consumable(
      consumableId: uuid.v4(),
      userId: userId,
      name: faker.food.dish(),
      calories: random.nextInt(350) + 110,
      referenceQuantity: 100,
      unit: 'g',
    );

    FirebaseFirestore.instance
        .collection('consumables')
        .doc(c.consumableId)
        .set({
      'consumableId': c.consumableId,
      'userId': userId,
      'name': c.name,
      'calories': c.calories,
      'referenceQuantity': c.referenceQuantity,
      'unit': c.unit,
    });
    consumables.add(c);
  }

  List<Map<String, dynamic>> mealTypes = myMealTypes;

  for (var i = 0; i < 9; i++) {
    var date = DateTime.now().subtract(Duration(days: i));
    int mealsPerDay = random.nextInt(4) + 2;
    for (var j = 0; j < mealsPerDay; j++) {
      Consumable c = consumables[random.nextInt(consumables.length)];
      int q = random.nextInt(200) + 50;
      Meal m = Meal(
        mealId: uuid.v4(),
        userId: userId,
        type: mealTypes[random.nextInt(mealTypes.length)]['name'],
        quantity: q,
        consumable: c,
        calories: (q * c.calories / c.referenceQuantity).round(),
        date: date,
      );

      FirebaseFirestore.instance.collection('meals').doc(m.mealId).set({
        'mealId': m.mealId,
        'userId': userId,
        'type': m.type,
        'quantity': m.quantity,
        'consumable': m.consumable.toEntity().toDocument(),
        'calories': m.calories,
        'date': Timestamp.fromDate(date),
      });
    }
  }
}
