import 'package:bloc/bloc.dart';
import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_consumables_event.dart';
part 'get_consumables_state.dart';

class GetConsumablesBloc extends Bloc<GetConsumablesEvent, GetConsumablesState> {
  CalorieIntakeRepository calorieIntakeRepository;

  GetConsumablesBloc(this.calorieIntakeRepository) : super(GetConsumablesInitial()) {
    on<GetConsumables>((event, emit) async{
      emit(GetConsumablesLoading());
      try {
        final consumables = await calorieIntakeRepository.getConsumables();
        emit(GetConsumablesSuccess(consumables));
      } catch (e) {
        emit(GetConsumablesFailure());
      }
    });
  }
}
