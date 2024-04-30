import 'package:bloc/bloc.dart';
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

part 'get_meals_event.dart';
part 'get_meals_state.dart';

class GetMealsBloc extends Bloc<GetMealsEvent, GetMealsState> {
  CalorieIntakeRepository calorieIntakeRepository;

  GetMealsBloc(this.calorieIntakeRepository, user) : super(GetMealsInitial()) {
    on<GetMeals>((event, emit) async {
      emit(GetMealsLoading());
      try{
        List<Meal> meals = await calorieIntakeRepository.getUsersMeals(user);
        DateTime today = DateTime.now();

        meals = meals.where((meal) {
          return 
            meal.date.year == today.year && 
            meal.date.month == today.month && 
            meal.date.day == today.day;
        }).toList();
        emit(GetMealsSuccess(meals, user)); 
      } catch(e){
        emit(GetMealsFailure());  
      }
    });
  }
}
