import 'package:equatable/equatable.dart';

abstract class FoodLogState extends Equatable {
  const FoodLogState();

  @override
  List<Object?> get props => [];
}

class FoodLogInitial extends FoodLogState {
  const FoodLogInitial();
}

class FoodLogLogging extends FoodLogState {
  const FoodLogLogging();
}

class FoodLogSuccess extends FoodLogState {
  final String message;

  const FoodLogSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class FoodLogError extends FoodLogState {
  final String message;

  const FoodLogError(this.message);

  @override
  List<Object?> get props => [message];
}
