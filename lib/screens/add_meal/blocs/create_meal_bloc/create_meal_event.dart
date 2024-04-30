part of 'create_meal_bloc.dart';

sealed class CreateMealEvent extends Equatable {
  const CreateMealEvent();

  @override
  List<Object> get props => [];
}

class CreateMeal extends CreateMealEvent {
  final Meal meal;

  const CreateMeal(this.meal);

  @override
  List<Object> get props => [meal];
}