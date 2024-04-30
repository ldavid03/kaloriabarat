part of 'get_meals_bloc.dart';

sealed class GetMealsEvent extends Equatable {
  const GetMealsEvent();

  @override
  List<Object> get props => [];
}

class GetMeals extends GetMealsEvent {}
