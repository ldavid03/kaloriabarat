import 'package:cloud_firestore/cloud_firestore.dart';

class ConsumableEntity{
  String consumableId;
  String userId;
  String name;
  int calories;
  int referenceQuantity;
  String unit;

  ConsumableEntity({
    required this.consumableId,
    required this.userId,
    required this.name,
    required this.calories,
    required this.referenceQuantity,
    required this.unit,
  });

  Map<String, Object?> toDocument(){
    return{
      'consumableId': consumableId,
      'userId': userId,
      'name': name,
      'calories': calories,
      'referenceQuantity': referenceQuantity,
      'unit': unit,
    };
  }

  static ConsumableEntity fromDocument(Map<String, dynamic> doc){
    return ConsumableEntity(
      consumableId: doc['consumableId'] as String,
      userId: doc['userId'] as String,
      name: doc['name'] as String,
      calories: doc['calories'] as int,
      referenceQuantity: doc['referenceQuantity'] as int,
      unit: doc['unit'] as String,
    );
  }

  static ConsumableEntity fromSnapshot(DocumentSnapshot snap) {
      return ConsumableEntity(
        consumableId: snap.id,
        userId: snap['userId'],
        name: snap['name'],
        calories: snap['calories'],
        referenceQuantity: snap['referenceQuantity'],
        unit: snap['unit'],
      );
    }
  
}