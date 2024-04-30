part of 'create_consumable_bloc.dart';

sealed class CreateConsumableState extends Equatable {
  const CreateConsumableState();
  
  @override
  List<Object> get props => [];
}

final class CreateConsumableInitial extends CreateConsumableState {}

final class CreateConsumableFailure extends CreateConsumableState {}
final class CreateConsumableLoading extends CreateConsumableState {}
final class CreateConsumableSuccess extends CreateConsumableState {}
