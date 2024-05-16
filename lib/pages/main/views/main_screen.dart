import 'dart:developer' as dev;
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaloriabarat/app.dart';
import 'package:kaloriabarat/static_data/meal_types.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/pages/set_goal/views/set_goal_screen.dart';
import 'package:kaloriabarat/pages/stats/views/stats_screen.dart';
import 'package:kaloriabarat/pages/update_profile/views/update_profile_screen.dart';
import 'package:user_repository/user_repository.dart';

class MainScreen extends StatefulWidget {
  final List<Meal> meals;
  final MyUser myUser;
  final Function(bool) onDialogStatusChanged;
  const MainScreen(this.meals, this.myUser, this.onDialogStatusChanged,
      {super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ValueNotifier<bool> _isFirstTime = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    MyUser myUser = widget.myUser;

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
                  isGuest ? Container() : ProfilePic(isGuest),
                  isGuest ? Container() : const SpaceWidth('m'),
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
              const SpaceHeight('m'),
              GestureDetector(
                onTap: () async {
                  if (isGuest) return;
                  if (myUser.height == 0) {
                    var x = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetGoalScreen(widget.myUser)),
                    );
                    if (x != null) {
                      setState(() {
                        myUser = x;
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
                          isGuest
                              ? "Default Goal"
                              : myUser.height == 0
                                  ? "Set Goal"
                                  : "Today's calorie intake",
                          "l",
                          "b"),
                      const SizedBox(height: 12),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyText(
                                "${widget.meals.fold(0, (total, meal) => total + meal.calories).toString()} / ${widget.myUser.goalCalories}",
                                "xxl",
                                "b"),
                            const MyText(" kcal", "l", "b")
                          ]),
                    ],
                  ),
                ),
              ),
              const SpaceHeight('l'),
              GestureDetector(
                  onTap: () {
                    if (isGuest) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyApp(FirebaseUserRepo())),
                        (Route<dynamic> route) => false,
                      );
                    } else {
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
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: MyText(
                              isGuest
                                  ? "Sign up for the best experience"
                                  : "Check your stats",
                              "l",
                              "b")))),
              const SpaceHeight('l'),
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
              widget.meals.isEmpty
                  ? const Expanded(
                      child: Center(
                          child: MyText("No meals logged yet", "m", "n",
                              color: "primary")),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: widget.meals.length,
                          itemBuilder: (context, int i) {
                            Meal meal = widget.meals[i];
                            return InkWell(
                              onTap: () async {
                                if (isGuest) return;
                                widget.onDialogStatusChanged(true);

                                int? result = await showDialog(
                                  context: context,
                                  builder: (context) => UpdateMealDialog(
                                      meals: widget.meals, i: i),
                                );
                                if (result != null) {
                                  setState(() {
                                    if (result == -1) {
                                      dev.log(widget.meals.length.toString());
                                      dev.log(i.toString());
                                    }
                                  });
                                }
                                widget.onDialogStatusChanged(false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: getColorScheme(context)
                                          .tertiary
                                          .withOpacity(0.3),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 90,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: myMealTypes
                                                        .firstWhere((mealType) =>
                                                            mealType['name'] ==
                                                            meal.type)['color'],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Center(
                                                    child: MyText(
                                                        widget.meals[i].type,
                                                        "m",
                                                        "n"),
                                                  ),
                                                ),
                                                const SpaceHeight('xs'),
                                                MyText(
                                                    "${widget.meals[i].calories.toString()} kcal",
                                                    "m",
                                                    "b"),
                                              ],
                                            ),
                                            const SpaceWidth('m'),
                                            MyText(
                                                widget.meals[i].consumable.name,
                                                "m",
                                                "n")
                                          ],
                                        ),
                                        const Icon(
                                            FontAwesomeIcons.penToSquare),
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
