import '../entities/entities.dart';

class Consumable{
  String consumableId;
  String userId;
  String name;
  int calories;
  int referenceQuantity;
  String unit;
  
  Consumable({
    required this.consumableId,
    required this.userId,
    required this.name,
    required this.calories,
    required this.referenceQuantity,
    required this.unit,
  });

  static final empty = Consumable(
    consumableId: '',
    userId: '',
    name: '',
    calories: 0,
    referenceQuantity: 0,
    unit: '',
  );
  factory Consumable.fromJson(Map<String, dynamic> json, String userId) {
    var funit = 'g';
    var frefQuan = 100;
    (json['measures'] as List).forEach((measure) {
              if (measure['label'] == 'Milliliter') {
            funit = 'ml';
            frefQuan = ((measure['weight'] as double)*100).toInt();
              }
        });
    
    var food = json['food'];
    return Consumable(
      consumableId: food['foodId'],
      userId: userId,
      name: food['label'],
      calories: (food['nutrients']['ENERC_KCAL'] as num).toInt(),
      unit: funit,
      referenceQuantity: frefQuan,
    );
  }

  ConsumableEntity toEntity(){
    return ConsumableEntity(
      consumableId: consumableId,
      userId: userId,
      name: name,
      calories: calories,
      referenceQuantity: referenceQuantity,
      unit: unit,
    );
  }

  static Consumable fromEntity(ConsumableEntity entity){
    return Consumable(
      consumableId: entity.consumableId,
      userId:  entity.userId,
      name: entity.name,
      calories: entity.calories,
      referenceQuantity: entity.referenceQuantity,
      unit: entity.unit,
    );
  }
}
