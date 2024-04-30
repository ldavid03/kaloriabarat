import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaloriabarat/static_data/apiData.dart' as localdata;
import 'package:kaloriabarat/static_data/mealTypes.dart' as mealTypes;
import 'package:http/http.dart' as http;
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/add_meal/blocs/create_meal_bloc/create_meal_bloc.dart';
import 'package:kaloriabarat/screens/add_meal/blocs/get_consumables_bloc/get_consumables_bloc.dart';
import 'package:kaloriabarat/screens/add_meal/views/add_consumable.dart';
import 'package:kaloriabarat/screens/add_meal/views/generate_consumables.dart';
import 'package:kaloriabarat/screens/add_meal/views/generate_meals.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  String _title = '';
  String _measureUnit = '11';
  bool isConsumableExpanded = false;
  TextEditingController mealController = TextEditingController();
  TextEditingController mealTypeController = TextEditingController();
  String _dropdownValue = 'ml';
  List<Map<String, dynamic>> myMealTypes = mealTypes.myMealTypes;
  TextEditingController consumableController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late Meal meal;
  String selectedValue = '';
  bool isLoading = false;
  Color selectedColor = mealTypes.myMealTypes[0]['color'];

  @override
  void initState() {
    _measureUnit = '';
    consumableController.text = _title;
    dateController.text = DateFormat('yyyy. MM. dd.').format(DateTime.now());
    meal = Meal.empty;
    meal.mealId = Uuid().v1();
    mealTypeController.text = myMealTypes[0]['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocListener<CreateMealBloc, CreateMealState>(
      listener: (context, state) {
        if (state is CreateMealSuccess) {
          Navigator.pop(context, meal);
        } else if (state is CreateMealLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              toolbarHeight: 80,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              title: MyText("Add Meal", "xl", "b"),
            ),
            body: BlocBuilder<GetConsumablesBloc, GetConsumablesState>(
              builder: (context, state) {
                if (state is GetConsumablesSuccess) {
                  return Container(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewInsets.bottom,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SpaceWidth('m'),
                          Flexible(
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                //MEAL TYPE

                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 56,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: selectedColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12)),
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
                                            child:
                                                DropdownButtonFormField<String>(
                                              isDense: true,
                                              decoration: const InputDecoration
                                                  .collapsed(hintText: ''),
                                              items: myMealTypes.map((mealType) {
  return DropdownMenuItem<String>(
    value: mealType['name'],
    child: Container(
      child: Text(mealType['name']),
    ),
  );
}).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  mealTypeController.text =
                                                      newValue!;
                                                  // Update the color based on the selected meal type
                                                  selectedColor = myMealTypes
                                                      .firstWhere((mealType) =>
                                                          mealType['name'] ==
                                                          newValue)['color'];
                                                });
                                              },
                                              value:
                                                  'Breakfast', // Set the default value

                                              hint: Text('Select a meal type'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SpaceHeight('m'),

                                //choose a food
                                Container(
                                  height: kToolbarHeight, // Set a fixed height
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: consumableController,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          readOnly: true,
                                          onTap: () async {
                                            Consumable? result =
                                                await showSearch(
                                                    context: context,
                                                    delegate:
                                                        CustomSearchDelegate(
                                                            consumables: state
                                                                .consumables,
                                                            userId: userId));
                                            if (result != Consumable.empty &&
                                                result != null) {
                                              setState(() {
                                                _measureUnit = result.unit;
                                                _title = result.name;
                                                meal.consumable = result;
                                                consumableController.text =
                                                    _title;
                                              });
                                            } else {
                                              setState(() {
                                                _measureUnit = '';
                                                _title = '';
                                                consumableController.text =
                                                    _title;
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: colorScheme.tertiary
                                                  .withOpacity(0.5),
                                              prefixIcon: const Icon(
                                                  FontAwesomeIcons.burger,
                                                  size: 16,
                                                  color: Colors.grey),
                                              suffixIcon: Icon(Icons.search),
                                              hintText: "Pick a food",
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                                borderSide: BorderSide.none,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SpaceHeight('m'),
                                ActionButton(
                                    onPressed: () async {
                                      var newConsumable =
                                          await getConsumableCreation(
                                              context, userId);
                                      if (newConsumable == null) return;
                                      setState(() {
                                        state.consumables
                                            .insert(0, newConsumable);
                                      });
                                    },
                                    ctx: context,
                                    str: "Create Consumable"),

                                SpaceHeight('m'),

                                //MEAL QUANRTITY
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: TextFormField(
                                          controller: mealController,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              isDense: true,
                                              filled: true,
                                              fillColor: colorScheme.tertiary
                                                  .withOpacity(0.5),
                                              prefixIcon: const Icon(
                                                  FontAwesomeIcons
                                                      .scaleBalanced,
                                                  size: 16,
                                                  color: Colors.grey),
                                              hintText: "Quantity",
                                              border: const OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.horizontal(
                                                        left:
                                                            Radius.circular(12),
                                                        right: Radius.zero),
                                                borderSide: BorderSide.none,
                                              )),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: 56, // Set the height as needed
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.horizontal(
                                                right: Radius.circular(12),
                                                left: Radius.zero),
                                        color: colorScheme.tertiary
                                            .withOpacity(0.5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            _measureUnit,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SpaceHeight('m'),

                                DatePickerField(
                                  initialDate: meal.date,
                                  onDateChanged: (newDate) {
                                    meal.date = newDate;
                                  },
                                ),
                              ],
                            )),
                          ),
                          SpaceHeight('m'),
                         // SizedBox(height: 32,child: TextButton(onPressed: () {generateConsumables(userId);},child: const Text("GENERATE DATA")),),
                          SpaceHeight('m'),
                          ActionButton(
                              onPressed: () {
                                try {
                                  setState(() {
                                    meal.userId = userId;
                                    meal.type = mealTypeController.text;
                                    meal.quantity =
                                        int.parse(mealController.text);
                                    meal.calories = (meal.quantity /
                                            meal.consumable.referenceQuantity *
                                            meal.consumable.calories)
                                        .toInt();
                                  });
                                  context
                                      .read<CreateMealBloc>()
                                      .add(CreateMeal(meal));
                                } catch (e) {
                                  return;
                                }
                              },
                              ctx: context,
                              str: "Save"),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<Consumable> {
  List<Consumable> consumables;
  String userId;
  String appId = localdata.EDAMAM_APPID;
  String appKey = localdata.EDAMAM_APPKEY;

  CustomSearchDelegate({required this.consumables, required this.userId});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context,
              Consumable.empty); // Replace null with a valid Consumable object
        });
  }

  Timer? _debounce;
  StreamController<List<Consumable>> _results = StreamController();

  @override
  Widget buildResults(BuildContext context) {
    if (query.length > 2) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () {
        fetchFoods(query).then((results) {
          _results.add(results);
        });
      });
    }

    return StreamBuilder<List<Consumable>>(
      stream: _results.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return ListTile(
                title: Text('${result.name} - ${result.calories}'),
                onTap: () {
                  close(context, result); // Return the selected result
                },
              );
            },
          );
        } else {
          return const Text('No results found.');
        }
      },
    );
  }

  Future<List<Consumable>> fetchFoods(String query) async {
    var filteredConsumables = consumables
        .where((consumable) =>
            consumable.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final response = await http.get(
      Uri.parse(
          'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$appId&app_key=$appKey'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var hints = data['hints'] as List;
      log(data.toString());
      var resultsFromApi =
          hints.map((item) => Consumable.fromJson(item, userId)).toList();
      (hints as List).forEach((item) {
        (item['measures'] as List).forEach((measure) {
          if (measure['label'] == 'Milliliter') {
            log('~~~~~');
            log(measure['weight'].toString());
          }
        });
      });
      return filteredConsumables..addAll(resultsFromApi);
    } else {
      throw Exception('Failed to load foods');
    }
  }

  @override
  void showResults(BuildContext context) {
    if (query.length > 2) {
      fetchFoods(query).then((results) {
        _results.add(results);
      });
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 2) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(seconds: 1), () {
        fetchFoods(query).then((results) {
          _results.add(results);
        });
      });
    }

    return StreamBuilder<List<Consumable>>(
      stream: _results.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              var result = results[index];
              return ListTile(
                title: Text('${result.name} - ${result.calories}'),
                onTap: () {
                  close(context, result);
                },
              );
            },
          );
        } else {
          return const Text('No results found.');
        }
      },
    );
  }
}
