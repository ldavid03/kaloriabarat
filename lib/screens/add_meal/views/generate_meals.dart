import 'dart:math' as mt;
import 'dart:developer' as dev;
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:kaloriabarat/static_data/mealTypes.dart' as mealTypes;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

void generateMeals(String userId) async {
  var uuid = Uuid();
  var random = mt.Random();

  List<Map<String, dynamic>> myMealTypes =mealTypes.myMealTypes; 

  // Fetch the user's consumables from Firestore
  var consumablesQuery = await FirebaseFirestore.instance
      .collection('consumables')
      .where('userId', isEqualTo: userId)
      .get();
  List<Consumable> consumables = consumablesQuery.docs
      .map((doc) => Consumable.fromEntity(ConsumableEntity.fromSnapshot(doc)))
      .toList();
  dev.log(consumables.length.toString());
  // Generate meals for the past 60 days
  for (var i = 0; i < 60; i++) {
    var date = DateTime.now().subtract(Duration(days: i));

    // Generate 5 meals for each day
    for (var j = 0; j < 5; j++) {
      var mealId = uuid.v4();
      var type = myMealTypes[random.nextInt(myMealTypes.length)];
      var quantity = random.nextInt(491) + 10; // Random int between 10 and 500
      var consumable = consumables[random.nextInt(consumables.length)];
      var calories =
          (consumable.calories * (quantity / consumable.referenceQuantity))
              .toInt();
      try {
        FirebaseFirestore.instance.collection('meals').doc(mealId).set({
          'mealId': mealId,
          'userId': userId,
          'type': type,
          'quantity': quantity,
          'consumable': consumable,
          'calories': calories,
          'date': Timestamp.fromDate(date),
        });
      } catch (e) {
        dev.log(e.toString());
      }
    }
  }
}
