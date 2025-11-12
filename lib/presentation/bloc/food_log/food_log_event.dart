import 'package:equatable/equatable.dart';
import '../../../domain/entities/food_entry.dart';

abstract class FoodLogEvent extends Equatable {
  const FoodLogEvent();

  @override
  List<Object?> get props => [];
}

class LogFoodEntry extends FoodLogEvent {
  final FoodEntry entry;

  const LogFoodEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

class UpdateFoodEntry extends FoodLogEvent {
  final FoodEntry entry;

  const UpdateFoodEntry(this.entry);

  @override
  List<Object?> get props => [entry];
}

class DeleteFoodEntry extends FoodLogEvent {
  final String entryId;

  const DeleteFoodEntry(this.entryId);

  @override
  List<Object?> get props => [entryId];
}
