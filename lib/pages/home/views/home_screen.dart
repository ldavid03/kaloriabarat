import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloriabarat/my_widgets/my_widgets.dart';
import 'package:kaloriabarat/pages/add_consumable/blocs/create_consumable_bloc/create_consumable_bloc.dart';
import 'package:kaloriabarat/pages/add_meal/blocs/create_meal_bloc/create_meal_bloc.dart';
import 'package:kaloriabarat/pages/add_meal/blocs/get_consumables_bloc/get_consumables_bloc.dart';
import 'package:kaloriabarat/pages/add_meal/views/add_meal_screen.dart';
import 'package:kaloriabarat/pages/add_meal/views/add_meal_guest_screen.dart';
import 'package:kaloriabarat/pages/authenticaiton/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:kaloriabarat/pages/home/blocs/get_meals_bloc/get_meals_bloc.dart';
import 'package:kaloriabarat/pages/chatbot/views/chat_screen.dart';
import 'package:kaloriabarat/pages/main/views/main_screen.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatefulWidget {
  final String? userEmail;
  final bool isMale;
  const HomeScreen({super.key, this.userEmail = "", this.isMale = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDialogOpen = false; 
  late bool isGuest;
  int goalCalories = 0;
  int index = 0;
  late Color selectedItem = Theme.of(context).colorScheme.primary;
  Color unselectedItem = Colors.black;

  @override
  void initState() {
    isGuest = widget.userEmail == "";
    super.initState();
  }

  void handleDialogStatusChanged(bool isOpen) {
    setState(() {
      isDialogOpen = isOpen;
    });
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
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Scaffold(
                  bottomNavigationBar: MyBottomNavigationBar(
                    onTap: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    index: index, isGuest: isGuest,
                  ),
                  resizeToAvoidBottomInset:true,
                  floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: index == 0 && !isDialogOpen
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
                            child: const AddMealScreen(),
                          ),
                        ),
                      );
                      if (newMeal != null) {
                        setState(() {
                          state2.meals.insert(0, Meal.copy(newMeal));
                        });
                      }
                    },
                    shape: const CircleBorder(),
                    child: MyFloatButton(),
                  ) : null,
                  body: index == 0
                      ? MainScreen(state2.meals, state2.user, handleDialogStatusChanged)
                      : ChatScreen(state2.meals, state2.user),
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
                builder: (BuildContext context) => const AddMealGuestScreen(),
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
            return MainScreen(value, guest, handleDialogStatusChanged);
          },
        ),
      );
    }
  }
}
