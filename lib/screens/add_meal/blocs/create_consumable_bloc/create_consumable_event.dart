part of 'create_consumable_bloc.dart';

sealed class CreateConsumableEvent extends Equatable {
  const CreateConsumableEvent();

  @override
  List<Object> get props => [];
}

class CreateConsumable extends CreateConsumableEvent{
  final Consumable consumable;

  const CreateConsumable(this.consumable);

  @override
  List<Object> get props => [consumable];
}