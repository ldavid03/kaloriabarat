part of 'create_meal_bloc.dart';

sealed class CreateMealState extends Equatable {
  const CreateMealState();
  
  @override
  List<Object> get props => [];
}

final class CreateMealInitial extends CreateMealState {}

final class CreateMealFailure extends CreateMealState {}
final class CreateMealLoading extends CreateMealState {}
final class CreateMealSuccess extends CreateMealState {}
