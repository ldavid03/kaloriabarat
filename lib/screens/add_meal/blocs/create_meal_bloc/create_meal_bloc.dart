import 'package:bloc/bloc.dart';
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_meal_event.dart';
part 'create_meal_state.dart';

class CreateMealBloc extends Bloc<CreateMealEvent, CreateMealState> {
  final CalorieIntakeRepository calorieIntakeRepository;

  CreateMealBloc(this.calorieIntakeRepository) : super(CreateMealInitial()) {
    on<CreateMeal>((event, emit) async{
      emit(CreateMealLoading());
      try {
        await calorieIntakeRepository.createMeal(event.meal);
        emit(CreateMealSuccess());
      } catch (e) {
        emit(CreateMealFailure());
      }
    });
  }
}
