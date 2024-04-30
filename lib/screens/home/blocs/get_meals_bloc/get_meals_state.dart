part of 'get_meals_bloc.dart';

sealed class GetMealsState extends Equatable {
  const GetMealsState();
  
  @override
  List<Object> get props => [];
}

final class GetMealsInitial extends GetMealsState {}

final class GetMealsLoading extends GetMealsState {}
final class GetMealsFailure extends GetMealsState{}
final class GetMealsSuccess extends GetMealsState {
  final List<Meal> meals;
  final MyUser user;
  const GetMealsSuccess(this.meals, this.user);

  @override
  List<Object> get props => [meals, user];
}