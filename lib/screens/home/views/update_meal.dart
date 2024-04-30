import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calorie_intake_repository/src/models/meal.dart';
import 'package:flutter/material.dart';

class UpdateDeleteDialog extends StatelessWidget {
  final List<Meal> meals;
  final int i;
  final TextEditingController quantityController;

  UpdateDeleteDialog({required this.meals, required this.i})
      : quantityController = TextEditingController(text: meals[i].quantity.toString());

  @override
  Widget build(BuildContext context) {
    final Meal updatedMeal = meals[i];
    return AlertDialog(
      title: Text('Change Meal', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min ,
        children: [
          Text(' ${meals[i].consumable.name}', textAlign: TextAlign.center,),
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Update',textAlign: TextAlign.center),
          onPressed: () async {
            updatedMeal.quantity = int.parse(quantityController.text);
            updatedMeal.calories = (updatedMeal.consumable.calories * (updatedMeal.quantity/updatedMeal.consumable.referenceQuantity)).toInt();
            // Code to update the food goes here
            await FirebaseFirestore.instance
              .collection('meals')
              .doc(updatedMeal.mealId)
              .update({
                'quantity': updatedMeal.quantity,
                 'calories': updatedMeal.calories, // Update calories field

                });

            meals[i] = updatedMeal;
            Navigator.pop(context, updatedMeal.quantity);
          },
        ),
        TextButton(
          child: Text('Delete',textAlign: TextAlign.center),
          onPressed: () async {
            // Code to delete the food goes here
            await FirebaseFirestore.instance
              .collection('meals')
              .doc(updatedMeal.mealId)
              .delete();
            
            meals.removeAt(i);
            Navigator.pop(context, -1);
          },
        ),
      ],
    );
  }
}