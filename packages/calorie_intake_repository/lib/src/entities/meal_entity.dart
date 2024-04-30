
import 'package:calorie_intake_repository/src/entities/consumable_entity.dart';
import 'package:calorie_intake_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealEntity{
  String mealId;
  String userId;
  String type;
  int quantity;
  Consumable consumable;
  int calories;
  DateTime date;

  MealEntity({
    required this.mealId,
    required this.userId,
    required this.type,
    required this.quantity,
    required this.consumable,
    required this.calories,
    required this.date,
  });

  Map<String, Object?> toDocument(){
    return{
      'mealId': mealId,
      'userId': userId,
      'type': type,
      'quantity': quantity,
      'consumable': consumable.toEntity().toDocument(),
      'calories': calories,
      'date': date,
    };
  }

  static MealEntity fromDocument(Map<String, dynamic> doc){
    return MealEntity(
      mealId: doc['mealId'] as String,
      userId: doc['userId'] as String,
      type: doc['type'] as String,
      quantity: doc['quantity'] as int,
      consumable: Consumable.fromEntity(ConsumableEntity.fromDocument(doc['consumable'])),
      calories: doc['calories'] as int,
      date: (doc['date'] as Timestamp).toDate(),
    );
  }
}