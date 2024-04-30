import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

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

class AddMeal2 extends StatefulWidget {
  @override
  _AddMeal2State createState() => _AddMeal2State();
}

class _AddMeal2State extends State<AddMeal2> {
  String _title = '';
  String _measureUnit = '11';
  final mealTypeController = TextEditingController();
  final mealController = TextEditingController();
  final consumableController = TextEditingController();

  final mealDate = DateTime.now();
  final userId = "random_id";

  Meal meal = Meal.empty;
  List<Map<String, dynamic>> myMealTypes = mealTypes.myMealTypes;
  List<Consumable> consumables = [];
  Color selectedColor = Color.fromRGBO(100, 3, 100, 1).withOpacity(0.1);

  @override
  void initState() {
    _measureUnit = '';
    consumableController.text = _title;
    meal = Meal.empty;
    meal.mealId = Uuid().v1();
    
    mealTypeController.text = myMealTypes[0]['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: MyText("Add Meal", "xl", "b"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SpaceHeight('m'),
        
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //MEAL TYPE
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: kToolbarHeight,
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
                                    value: mealTypeController.text, // Step 3

                                  isDense: true,
                                  decoration: const InputDecoration.collapsed(
                                      hintText: ''),
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
                                      mealTypeController.text = newValue!;
                                      // Update the color based on the selected meal type
                                      selectedColor = myMealTypes.firstWhere(
                                          (mealType) =>
                                              mealType['name'] ==
                                              newValue)['color'];
                                    });
                                  },
                                  hint: Text('Select a meal type'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SpaceHeight('m'),

                    
        
                    Container(
                      height: kToolbarHeight, // Set a fixed height
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: consumableController,
                              textAlignVertical: TextAlignVertical.bottom,
                              readOnly: true,
                              onTap: () async {
                                      Consumable? result = await showSearch(
                                          context: context,
                                          delegate: CustomSearchDelegate(consumables: consumables,userId:  userId));
                                      if (result != Consumable.empty &&
                                          result != null) {
                                        setState(() {
                                          _measureUnit = result.unit;
                                          _title = result.name;
                                          meal.consumable = result;
                                          log('---${meal.consumable.calories}');
                                          consumableController.text = _title;
                                        });
                                      } else {
                                        setState(() {
                                          _measureUnit = '';
                                          _title = '';
                                          consumableController.text = _title;
                                        });
                                      }
                                    },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      colorScheme.tertiary.withOpacity(0.5),
                                  prefixIcon: const Icon(FontAwesomeIcons.burger,
                                      size: 16, color: Colors.grey),
                                  suffixIcon: const Icon(Icons.search),
                                  hintText: "Pick a food",
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                          
                        ],
                      ),
                    ),

                    SpaceHeight('m'),
                    
                    Row(
                      children: [
                        
                        Expanded(
                          child: SizedBox(
                            height: kToolbarHeight,
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: mealController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  isDense: true,
                                  filled: true,
                                  fillColor:
                                      colorScheme.tertiary.withOpacity(0.5),
                                  prefixIcon: const Icon(
                                      FontAwesomeIcons.scaleBalanced,
                                      size: 16,
                                      color: Colors.grey),
                                  hintText: "Quantity",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(12),
                                        right: Radius.zero),
                                    borderSide: BorderSide.none,
                                  )),
                            ),
                          ),
                        ),
                        Container(
                          height: kToolbarHeight, // Set the height as needed
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(12), left: Radius.zero),
                            color: colorScheme.tertiary.withOpacity(0.5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                "g",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                                              SpaceHeight('l'),

                    ActionButton(onPressed: () {
                        try {
                          setState(() {
                            meal.type = mealTypeController.text;
                            meal.quantity = int.parse(mealController.text);
                            meal.quantity = int.parse(mealController.text);
                            meal.calories = (meal.quantity /
                                    meal.consumable.referenceQuantity *
                                    meal.consumable.calories)
                                .toInt();
                            // Add any other properties you need for the Meal
                          });
        
                          Navigator.pop(context, meal);
                        } catch (e) {
                          return;
                        }
                      },ctx:context, str:"Save"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomSearchDelegate extends SearchDelegate<Consumable> {
//   List<Consumable> consumables;
//   String userId;
//   String appId = localdata.EDAMAM_APPID;
//   String appKey = localdata.EDAMAM_APPKEY;

//   CustomSearchDelegate({required this.consumables, required this.userId});

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//         },
//       )
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         icon: const Icon(Icons.arrow_back),
//         onPressed: () {
//           close(context,
//               Consumable.empty); // Replace null with a valid Consumable object
//         });
//   }

//   Timer? _debounce;
//   StreamController<List<Consumable>> _results = StreamController();

//   @override
//   Widget buildResults(BuildContext context) {
//     if (query.length > 2) {
//       if (_debounce?.isActive ?? false) _debounce?.cancel();
//       _debounce = Timer(const Duration(seconds: 1), () {
//         fetchFoods(query).then((results) {
//           _results.add(results);
//         });
//       });
//     }

//     return StreamBuilder<List<Consumable>>(
//       stream: _results.stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           var results = snapshot.data!;
//           return ListView.builder(
//             itemCount: results.length,
//             itemBuilder: (context, index) {
//               var result = results[index];
//               return ListTile(
//                 title: Text('${result.name} - ${result.calories}'),
//                 onTap: () {
//                   close(context, result); // Return the selected result
//                 },
//               );
//             },
//           );
//         } else {
//           return const Text('No results found.');
//         }
//       },
//     );
//   }

//   Future<List<Consumable>> fetchFoods(String query) async {
//     var filteredConsumables = consumables
//         .where((consumable) =>
//             consumable.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//     final response = await http.get(
//       Uri.parse(
//           'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$appId&app_key=$appKey'),
//     );

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       var hints = data['hints'] as List;
//       log(data.toString());
//       var resultsFromApi =
//           hints.map((item) => Consumable.fromJson(item, userId)).toList();
//       (hints as List).forEach((item) {
//         (item['measures'] as List).forEach((measure) {
//           if (measure['label'] == 'Milliliter') {
//             log('~~~~~');
//             log(measure['weight'].toString());
//           }
//         });
//       });
//       return filteredConsumables..addAll(resultsFromApi);
//     } else {
//       throw Exception('Failed to load foods');
//     }
//   }

//   @override
//   void showResults(BuildContext context) {
//     if (query.length > 2) {
//       fetchFoods(query).then((results) {
//         _results.add(results);
//       });
//     }
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.length > 2) {
//       if (_debounce?.isActive ?? false) _debounce?.cancel();
//       _debounce = Timer(const Duration(seconds: 1), () {
//         fetchFoods(query).then((results) {
//           _results.add(results);
//         });
//       });
//     }

//     return StreamBuilder<List<Consumable>>(
//       stream: _results.stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (snapshot.hasData) {
//           var results = snapshot.data!;
//           return ListView.builder(
//             itemCount: results.length,
//             itemBuilder: (context, index) {
//               var result = results[index];
//               return ListTile(
//                 title: Text('${result.name} - ${result.calories}'),
//                 onTap: () {
//                   close(context, result);
//                 },
//               );
//             },
//           );
//         } else {
//           return const Text('No results found.');
//         }
//       },
//     );
//   }
// }
