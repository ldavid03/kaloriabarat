
part of 'my_widgets.dart';

class MealTypeDropdown extends StatefulWidget {
  final Function(String) onChanged;
  final List<Map<String, dynamic>> mealTypes;

  MealTypeDropdown({required this.onChanged, required this.mealTypes});

  @override
  State<MealTypeDropdown> createState() => _MealTypeDropdownState();
}

class _MealTypeDropdownState extends State<MealTypeDropdown> {
  String? selectedMealType;
  Color selectedColor = Colors.white;

  @override
  void initState() {
    super.initState();
    selectedMealType = widget.mealTypes[0]['name'];
    selectedColor = widget.mealTypes[0]['color'];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 56,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: selectedColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: DropdownButtonHideUnderline(
          child: Row(
            children: [
              const Icon(
                FontAwesomeIcons.utensils,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  items: widget.mealTypes.map((mealType) {
                    return DropdownMenuItem<String>(
                      value: mealType['name'],
                      child: Container(
                        child: Text(mealType['name']),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMealType = newValue!;
                      // Update the color based on the selected meal type
                      selectedColor = widget.mealTypes.firstWhere((mealType) =>
                          mealType['name'] == newValue)['color'];
                    });
                    widget.onChanged(newValue!);
                  },
                  value: selectedMealType,
                  hint: Text('Select a meal type'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}