part of 'get_consumables_bloc.dart';

sealed class GetConsumablesState extends Equatable {
  const GetConsumablesState();
  
  @override
  List<Object> get props => [];
}

final class GetConsumablesInitial extends GetConsumablesState {}

final class GetConsumablesFailure extends GetConsumablesState {}
final class GetConsumablesLoading extends GetConsumablesState {}
final class GetConsumablesSuccess extends GetConsumablesState {
  final List<Consumable> consumables;

  const GetConsumablesSuccess(this.consumables);

  @override
  List<Object> get props => [consumables];
}
