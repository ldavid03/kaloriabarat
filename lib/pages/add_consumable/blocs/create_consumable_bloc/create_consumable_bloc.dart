import 'package:bloc/bloc.dart';
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_consumable_event.dart';
part 'create_consumable_state.dart';

class CreateConsumableBloc extends Bloc<CreateConsumableEvent, CreateConsumableState> {
  CalorieIntakeRepository calorieIntakeRepository;
  
  CreateConsumableBloc(this.calorieIntakeRepository) : super(CreateConsumableInitial()) {
    on<CreateConsumable>((event, emit) async{
      emit(CreateConsumableLoading());
      try {
        await calorieIntakeRepository.createConsumable(event.consumable);
    
        emit(CreateConsumableSuccess());
      } catch (e) {
        emit(CreateConsumableFailure());
      }
    });
  }
}
