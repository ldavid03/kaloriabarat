import 'dart:math' as math;
import 'dart:developer' as dev;
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaloriabarat/app.dart';
import 'package:kaloriabarat/static_data/mealTypes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:kaloriabarat/screens/auth/views/welcome_screen.dart';
import 'package:kaloriabarat/screens/update_profile/views/goal_calculate_screen.dart';
import 'package:kaloriabarat/screens/home/views/update_meal.dart';
import 'package:kaloriabarat/screens/stats/stats.dart';
import 'package:kaloriabarat/screens/update_profile/update_profile.dart';
import 'package:user_repository/user_repository.dart';

class MainScreen extends StatefulWidget {
  final List<Meal> meals;
  final MyUser myUser;
  const MainScreen(this.meals, this.myUser, {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  ValueNotifier<bool> _isFirstTime = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    MyUser myUser = widget.myUser;

    String totalKcal =
        widget.meals.fold(0, (total, meal) => total + meal.calories).toString();
    int kcal = myUser.goalCalories;
    bool isGuest = widget.myUser.email == '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isFirstTime.value && isGuest) {
        showDialog(
          context: context,
          builder: (context) => GuestAlerDialog(),
        );
        _isFirstTime.value = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: colorScheme.secondary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            GestureDetector(
              onTap: () async {
                if (isGuest) return;
                final updatedUser = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen(widget.myUser)),
                );
                if (updatedUser != null) {
                  setState(() {
                    widget.myUser.name = updatedUser.name;
                    widget.myUser.goalCalories = updatedUser.goalCalories;
                  });
                }
              },
              child: Row(
                children: [
                  isGuest ?   Container() :ProfilePic(isGuest ),
                  isGuest ? Container() :SpaceWidth('m'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(isGuest ? "Guest" : widget.myUser.name, "l", "b"),
                    ],
                  ),
                ],
              ),
            ),
            MyLogOutButton(isGuest)
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
          child: Column(
            children: [
              //header

              SpaceHeight('m'),
              GestureDetector(
                onTap: () async {
                  if (isGuest) return;
                  if (myUser.height == 0) {
                    var x = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GoalCalculateScreen(widget.myUser)),
                    );
                    if (x != null) {
                      setState(() {
                        myUser = x;
                        kcal = myUser.goalCalories;
                      });
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2.2,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(12),
                    
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                         isGuest? "Default Goal" :   myUser.height == 0
                              ? "Set Goal"
                              : "Today's calorie intake", "l", "b"),
                      const SizedBox(height: 12),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                                "${widget.meals.fold(0, (total, meal) => total + meal.calories).toString()} / ${widget.myUser.goalCalories}","xxl","b"),
                            MyText(" kcal", "l", "b")
                          ]),
                    ],
                  ),
                ),
              ),
              SpaceHeight('l'),
              GestureDetector(
                      onTap: () {
                        if(isGuest){
                          Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyApp(FirebaseUserRepo())),
                          (Route<dynamic> route) => false,
                        );
                        }
                        else{
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StatsScreen(myUser: widget.myUser)),
                        );
                        }
                        
                      },
                      child: Container(
                        height: kToolbarHeight,
                        width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            
                            color: colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Center(child: MyText(isGuest? "Sign up for the best experience": "Check your stats", "l", "b")))),
              SpaceHeight('l'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Todays Meals",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isGuest
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StatsScreen(myUser: widget.myUser)),
                            );
                          },
                          child: Text(
                            "Calories",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.outline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20),

              //meals list

              widget.meals.isEmpty ?  Expanded(
                child: Container(
                  child: Center(child: MyText("No meals logged yet", "m", "n",color:"primary")),
                ),
              ) :
              Expanded(
                child: ListView.builder(
                    itemCount: widget.meals.length,
                    itemBuilder: (context, int i) {
                      Meal meal = widget.meals[i];

                      //meal
                      return InkWell(
                        onTap: () async {
                          if (isGuest) return;
                          int? result = await showDialog(
                            context: context,
                            builder: (context) =>
                                UpdateDeleteDialog(meals: widget.meals, i: i),
                          );
                          if (result != null) {
                            setState(() {
                              if (result == -1) {
                                dev.log(widget.meals.length.toString());
                                dev.log(i.toString());
                              } 
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color:getColorScheme(context).tertiary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:CrossAxisAlignment.center,
                                        children: [
                                          
                                          Container(
                                            width:90,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: myMealTypes
                                                  .firstWhere((mealType) =>
                                                      mealType['name'] ==
                                                      meal.type)['color'],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            
                                            child: Center(
                                              child: MyText(
                                                widget.meals[i].type,"m","n"),
                                            ),
                                          ),
                                          SpaceHeight('xs'),
                                          MyText(
                                        "${widget.meals[i].calories.toString()} kcal","m","b"),
                                        ],
                                      ),
                                      SpaceWidth('m'),
                                      MyText(widget.meals[i].consumable.name, "m","n")
                                    ],
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
