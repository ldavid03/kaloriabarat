part of 'my_widgets.dart';
class UpdateMealDialog extends StatelessWidget {
  final List<Meal> meals;
  final int i;
  final TextEditingController quantityController;

  UpdateMealDialog({super.key, required this.meals, required this.i})
      : quantityController = TextEditingController(text: meals[i].quantity.toString());

  @override
  Widget build(BuildContext context) {

    final Meal updatedMeal = meals[i];
    return AlertDialog(
      title: const Text('Change Meal', textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min ,
        children: [
          Text(' ${meals[i].consumable.name}', textAlign: TextAlign.center,),
          TextFormField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Quantity',
            ),
          ),
          
        ],
      ),
      
      actions: [
        TextButton(
          child: const Text('Update',textAlign: TextAlign.center),
          onPressed: () async {
            try{
updatedMeal.quantity = int.parse(quantityController.text);
            updatedMeal.calories = (updatedMeal.consumable.calories * (updatedMeal.quantity/updatedMeal.consumable.referenceQuantity)).toInt();
            await FirebaseFirestore.instance
              .collection('meals')
              .doc(updatedMeal.mealId)
              .update({
                'quantity': updatedMeal.quantity,
                 'calories': updatedMeal.calories,

                });

            meals[i] = updatedMeal;
            Navigator.pop(context, updatedMeal.quantity);
            }

            catch (e){
              return;
            }

          },
        ),
        TextButton(
          child: const Text('Delete',textAlign: TextAlign.center),
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