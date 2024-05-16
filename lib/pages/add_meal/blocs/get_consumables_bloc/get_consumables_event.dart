part of 'get_consumables_bloc.dart';

sealed class GetConsumablesEvent extends Equatable {
  const GetConsumablesEvent();

  @override
  List<Object> get props => [];
}

class GetConsumables extends GetConsumablesEvent{}