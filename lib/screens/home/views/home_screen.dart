import 'dart:developer' as dev;
import 'dart:math' as math;
import 'dart:math';

import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/add_meal/blocs/create_consumable_bloc/create_consumable_bloc.dart';
import 'package:kaloriabarat/screens/add_meal/blocs/create_meal_bloc/create_meal_bloc.dart';
import 'package:kaloriabarat/screens/add_meal/blocs/get_consumables_bloc/get_consumables_bloc.dart';
import 'package:kaloriabarat/screens/add_meal/views/add_meal.dart';
import 'package:kaloriabarat/screens/add_meal/views/add_meal_guest.dart';
import 'package:kaloriabarat/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:kaloriabarat/screens/home/blocs/get_meals_bloc/get_meals_bloc.dart';
import 'package:kaloriabarat/screens/home/views/chat_screen.dart';
import 'package:kaloriabarat/screens/home/views/main_screen.dart';
import 'package:kaloriabarat/screens/stats/stats.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatefulWidget {
  //              'Welcome, ${widget.userEmail} you are In now',
  final String? userEmail;
  final bool isMale;
  const HomeScreen({Key? key, this.userEmail = "", this.isMale = true})
      : super(key: key);
  //logout

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isGuest;
  int goalCalories = 0;
  int index = 0;
  late Color selectedItem = Theme.of(context).colorScheme.primary;
  Color unselectedItem = Colors.black;

  @override
  void initState() {
    dev.log('HomeScreen');
    isGuest = widget.userEmail == "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userEmail != "") {
      return BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          return BlocBuilder<GetMealsBloc, GetMealsState>(
              builder: (context2, state2) {
            if (state2 is GetMealsSuccess) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Scaffold(
                  //bottomnavbar
                  bottomNavigationBar: MyBottomNavigationBar(
                    onTap: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    index: index, isGuest: isGuest,
                  ),
                  resizeToAvoidBottomInset:true,

                  //floatingbutton
                  floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: index == 0
                  ? FloatingActionButton(
                    onPressed: () async {
                      var newMeal = await Navigator.push(
                        context2,
                        MaterialPageRoute<Meal>(
                          builder: (BuildContext context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => CreateConsumableBloc(
                                    FirebaseCalorieIntakeRepo()),
                              ),
                              BlocProvider(
                                create: (context) => GetConsumablesBloc(
                                    FirebaseCalorieIntakeRepo())
                                  ..add(GetConsumables()),
                              ),
                              BlocProvider(
                                  create: (context) => CreateMealBloc(
                                      FirebaseCalorieIntakeRepo())),
                            ],
                            child: const AddMeal(),
                          ),
                        ),
                      );
                      if (newMeal != null) {
                        setState(() {
                          state2.meals.insert(0, Meal.copy(newMeal));
                          dev.log(state2.meals.toString());
                        });
                      }
                    },
                    shape: const CircleBorder(),
                    child: MyFloatButton(),
                  ) : null,
                  body: index == 0
                      ? MainScreen(state2.meals, state2.user)
                      : const ChatScreen(),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          });
        },
      );
    } else {
      List<Meal> temp = [];
      MyUser guest = MyUser.empty;
      guest.goalCalories = widget.isMale ? 2500 : 2000;
      ValueNotifier<List<Meal>> guestMeals = ValueNotifier<List<Meal>>([]);
      return Scaffold(
        bottomNavigationBar: MyBottomNavigationBar(
                    onTap: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    index: 0, isGuest : isGuest
                  ),
                  resizeToAvoidBottomInset:true,
        



        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var newMeal = await Navigator.push(
              context,
              MaterialPageRoute<Meal>(
                builder: (BuildContext context) => AddMeal2(),
              ),
            );
            if (newMeal != null) {
              temp.insert(0, Meal.copy(newMeal));
              guestMeals.value = List.from(temp);
            }
          },
          shape: const CircleBorder(),
          child: MyFloatButton(),
        ),
        body: ValueListenableBuilder<List<Meal>>(
          valueListenable: guestMeals,
          builder: (context, value, child) {
            return MainScreen(value, guest);
          },
        ),
      );
    }
  }
}
